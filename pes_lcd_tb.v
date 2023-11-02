/*module pes_lcd_tb();

    // Inputs
    reg CLK;
    reg [7:0] DATA;
    reg [1:0] OPER;
    reg ENB;
    reg RST;
    
    // Outputs
    wire RDY;
    wire LCD_RS, LCD_RW, LCD_E; // Declare as wire
    wire [7:0] LCD_DB;

    // Instantiate the LCD module
    pes_lcd dut (
        .CLK(CLK),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .LCD_E(LCD_E),
        .LCD_DB(LCD_DB),
        .RDY(RDY),
        .DATA(DATA),
        .OPER(OPER),
        .ENB(ENB),
        .RST(RST)
    );
	
    initial begin
        $dumpfile("dump.vcd");
	$dumpvars;
    end
    
    
    always begin
        #5 CLK = ~CLK; // Generate a 10ns clock signal
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        CLK = 0;
        DATA = 8'b11011011; // Example data (8 bits wide)
        OPER = 2'b00; // Example operation (2 bits wide)
        ENB = 1'b1; // Enable signal (1 bit wide)
        RST = 1'b0; // Reset signal (1 bit wide)
        
        // Wait for a few clock cycles before starting the test
        #20;
        
        // Test case 1: Write data to the LCD
        #10 DATA = 8'b10101010; // Write data (8 bits wide)
        ENB = 1'b1; // Enable data transfer
        #10 ENB = 1'b0; // Disable data transfer
        
        // Test case 2: Read data from the LCD
        ENB = 1'b1; // Enable read operation
        #10 ENB = 1'b0; // Disable read operation
        
        // Simulation end
        $finish;
    end

endmodule

*/

module pes_lcd_tb();

    // Inputs
    reg CLK;
    reg [7:0] DATA;
    reg [1:0] OPER;
    reg ENB;
    reg RST;
    
    // Outputs
    wire RDY;
    wire LCD_RS, LCD_RW, LCD_E; // Outputs from the module
    wire [7:0] LCD_DB;

    // Instantiate the LCD module
    pes_lcd dut (
        .CLK(CLK),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .LCD_E(LCD_E),
        .LCD_DB(LCD_DB),
        .RDY(RDY),
        .DATA(DATA),
        .OPER(OPER),
        .ENB(ENB),
        .RST(RST)
    );

     initial begin
        $dumpfile("dump.vcd");
	$dumpvars;
    end
    
    
    always begin
        #5 CLK = ~CLK; // Generate a 10ns clock signal
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        CLK = 0;
        DATA = 8'b11011011; // Example data (8 bits wide)
        OPER = 2'b00; // Example operation (2 bits wide)
        ENB = 1'b1; // Enable signal (1 bit wide)
        RST = 1'b0; // Reset signal (1 bit wide)
        
        // Wait for a few clock cycles before starting the test
        #20;
        
        // Test case 1: Write data to the LCD

        #10 DATA = 8'b10101010; // Write data (8 bits wide)
        ENB = 1'b1; // Enable data transfer
        #10 ENB = 1'b0; // Disable data transfer
        
        // Test case 2: Read data from the LCD

        ENB = 1'b1; // Enable read operation
        #10 ENB = 1'b0; // Disable read operation
        
        // Test case 3: Reset the LCD module
        RST = 1'b1; // Set reset signal
        #10 RST = 1'b0; // Release reset signal
        
        // Test case 4: Send another data after reset

        #10 DATA = 8'b11110000; // Write data (8 bits wide)
        ENB = 1'b1; // Enable data transfer
        #10 ENB = 1'b0; // Disable data transfer
        
        // Test case 5: Perform an instruction operation

        #10 DATA = 8'b01010101; // Write instruction (8 bits wide)
        ENB = 1'b1; // Enable data transfer
        #10 ENB = 1'b0; // Disable data transfer
        
        // Simulation end
        $finish;
    end

endmodule


