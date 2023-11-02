`timescale 1ns / 1ps

module pes_lcd_tb();

  // Inputs
  reg CLK;
  reg DATA;
  reg OPER;
  reg ENB;
  reg RST;

  // Outputs
  wire RDY;
  wire LCD_RS;
  wire LCD_RW;
  wire LCD_E;
  wire [7:0] LCD_DB;

  // Instantiate the pes_lcd module
  pes_lcd dut (
    .CLK(CLK),
    .DATA(DATA),
    .OPER(OPER),
    .ENB(ENB),
    .RST(RST),
    .RDY(RDY),
    .LCD_RS(LCD_RS),
    .LCD_RW(LCD_RW),
    .LCD_E(LCD_E),
    .LCD_DB(LCD_DB)
  );

  // Clock generation
  always begin
    #5 CLK = ~CLK; // 24MHz clock period
  end

  // Stimulus generation
  initial begin
    CLK = 0;
    DATA = 8'b11011011; // Example data
    OPER = 2'b01; // Example operation: Data
    ENB = 1;
    RST = 0;

    // Reset LCD
    #10 RST = 1;

    // Wait for some cycles
    #50;

    // Send data to LCD
    #10 ENB = 1;
    #10 ENB = 0;
    #10 ENB = 1;

    // Wait for RDY signal to be high (indicating the module is idle)
    wait(RDY);

    // Add more test cases or simulation steps as needed

    // End simulation
    $stop;
  end

endmodule
