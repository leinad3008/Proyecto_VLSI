`timescale 1us / 1ns

module ALU_tb();


  reg [31:0] ALUA,ALUB;
  reg [3:0] control;
  reg Cin;
  reg clk;
  wire [31:0] ALUResult;
  wire [3:0] Cout;

  ALU DUT(.ALUA (ALUA), .ALUB(ALUB), .ALUControl(control), .ALUFlagIn(Cin), .Clk(clk), .ALUResult(ALUResult), .ALUFlags(Cout));
  
  	initial
	begin
	forever 
		#5 clk= ~clk;
	end
  
  
  initial begin
    $display("\n-- Starting Simulation --");
    $dumpfile("./ALU.vcd");
    $dumpvars(0,ALU_tb);

    control=4'h0; Cin=1'b1;
    #00 ALUA=32'd15;ALUB=32'd1; clk=0;
    #15 ALUA=32'd120;ALUB=32'd32;
    #10 ALUA=32'd192;ALUB=32'd69;
    #10 ALUA=32'd123412;ALUB=32'd64;
    #10 control=4'h1;
    #10 control=4'h2;
    #10 control=4'h3; 
    #10 control=4'h4; Cin=1'b0;
    #10 control=4'h5;
    #10 control=4'h6;
    #10 control=4'h7;
    #10 control=4'h8;
    #10 control=4'h9;

    #10;


    $display("-- Finishing Simulation--\n");
    $finish;
  end

  initial begin
    $monitor("A=%d, B=%d,control=%b, Cin=%b, Result=%d, Cout=%b", ALUA, ALUB,control, Cin,ALUResult,Cout);
  end

endmodule //
