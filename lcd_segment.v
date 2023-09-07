module lcd_seg(data_in, display_out);

  input [7:0] data_in;
  output [4:0] display_out [7:0]; 
  
always @(*) begin
    case (data_in)
        8'b01100001:
            display_out = 8'b00000011;  //a
        8'b01100010:
            display_out = 8'b00000011;  //a
    endcase
end
endmodule
