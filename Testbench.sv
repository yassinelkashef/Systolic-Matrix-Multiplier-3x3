`include "Matrix.sv"
`include "design.sv"
  `timescale 1ns/1ps
  module testbench #(parameter data_width=8) () ;

    bit                        t_clk     , t_rst;
    logic [data_width-1:0]     t_Cell_A1 , t_Cell_A2,t_Cell_A3;
    logic [data_width-1:0]     t_Cell_B1 , t_Cell_B2,t_Cell_B3;
    logic [(data_width*2):0]   t_cell_1  , t_cell_2 , t_cell_3 , t_cell_4 , t_cell_5;  
    logic [(data_width*2):0]   t_cell_6 , t_cell_7, t_cell_8, t_cell_9;
    Matrix M1,M2;

    Systolic_Array #(data_width) dut (t_clk, t_rst, t_Cell_A1, t_Cell_A2, t_Cell_A3, t_Cell_B1,
                                      t_Cell_B2, t_Cell_B3, t_cell_1, t_cell_2, t_cell_3, t_cell_4, t_cell_5, t_cell_6,
                                      t_cell_7, t_cell_8, t_cell_9);


    // generate clock to sequence tests
    initial begin
      repeat(21) begin
        #5 t_clk = ~ t_clk;
        $display("at time %t Matrix Output is:",$time);
        $write("| %d | %d | %d |\n", t_cell_1, t_cell_2, t_cell_3);
        $write("| %d | %d | %d |\n", t_cell_4, t_cell_5, t_cell_6);
        $write("| %d | %d | %d |\n", t_cell_7, t_cell_8, t_cell_9);
      end
    end

    initial begin
      t_rst = 1;
      #2 t_rst = 0;
      M1 = new;
      M2 = new;
      $display("Matrix A is");
      M1.display;
      $display("Matrix B is");
      M2.display;
    end
    initial begin //transaction

      #2;
      t_Cell_A1 = 7; t_Cell_A2 = 0; t_Cell_A3 = 0; //CORRECT
      t_Cell_B1 = 2; t_Cell_B2 = 0; t_Cell_B3 = 0; 
      #10;
      t_Cell_A1 = 4; t_Cell_A2 = 5; t_Cell_A3 = 0;//CORRECT
      t_Cell_B1 = 7; t_Cell_B2 = 5; t_Cell_B3 = 0;
      #10;
      t_Cell_A1 = 7; t_Cell_A2 = 6; t_Cell_A3 = 1;//CORRECT
      t_Cell_B1 = 8; t_Cell_B2 = 9; t_Cell_B3 = 3;
      #10;
      t_Cell_A1 = 0; t_Cell_A2 = 9; t_Cell_A3 = 9;
      t_Cell_B1 = 0; t_Cell_B2 = 5; t_Cell_B3 = 5;
      #10;
      t_Cell_A1 = 0; t_Cell_A2 = 0; t_Cell_A3 = 5;
      t_Cell_B1 = 0; t_Cell_B2 = 0; t_Cell_B3 = 7;
      #10;
      t_Cell_A1 = 0; t_Cell_A2 = 0; t_Cell_A3 = 0;
      t_Cell_B1 = 0; t_Cell_B2 = 0; t_Cell_B3 = 0;




    end

    initial begin
      $dumpfile("wave.vcd");
      $dumpvars;
    end

  endmodule

// ##################################################################################################################################################
//                                                             Systolic Array Algoerthim                                                          //
//##################################################################################################################################################

/*
output
# |     98 |    106 |     90 |
# |    124 |    124 |    108 |
# |    105 |    111 |     83 |


        
        _________
        0 0 0
        _________
        0 0 b9
        _________
        0 b8 b6
        _________
        b7 b5 b3
        _________
        b4 b2 0
        _________
        b1 0  0

 0 | 0|  0| a3| a2| a1 
   |  |   |   |   | 
 0 | 0| a6| a5| a4| 0 
   |  |   |   |   | 
 0 |a9| a8| a7|  0| 0 

*/
  