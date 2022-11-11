module plusless
  (input [3:0] A, B,
    input Cin,
    output [3:0] Sum,
    output Cout);

    wire [3:0] p,g,c;
    wire a,b,d,e,f,h,i,j,k,l,m,o,q,r,s,t;
    xor R1(p[0],A[0],B[0]);
    xor R2(p[1],A[1],B[1]);
    xor R3(p[2],A[2],B[2]);
    xor R4(p[3],A[3],B[3]); //Esto hace el xor bit a bit
    and Q1(g[0],A[0],B[0]);
    and Q2(g[1],A[1],B[1]);
    and Q3(g[2],A[2],B[2]);
    and Q4(g[3],A[3],B[3]); // and bit a bit y lo guardan en p y g
    //assign p=A^B;//propagación
    //assign g=A&B; //generación

    //carry=gi + Pi*ci

    assign c[0]=Cin;
    and T1(a,p[0],c[0]);
    or  T2(c[1],g[0],a); //assign c[1]= g[0]|(p[0]&c[0]);

    and T3(b,p[1],a);
    and T4(d,p[1],g[0]);
    or  T5(e,b,d);
    or  T6(c[2],g[1],e); //assign c[2]= g[1] | (p[1]&g[0]) | p[1]&p[0]&c[0];

    and T7(f,p[2],b);
    and T8(h,p[2],d);
    and T9(i,p[2],g[1]);
    or  Y1(j,f,h);
    or  Y2(k,j,i);
    or  Y3(c[3],g[2],k);
    //assign c[3]= g[2] | (p[2]&g[1]) | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&c[0];

    and Y4(l,p[2],f);
    and Y5(m,p[3],h);
    and Y6(o,p[3],i);
    and Y7(q,p[3],g[2]);
    or  Y8(r,l,m);
    or  Y9(s,r,o);
    or  U1(t,s,q);

    //assign Cout= g[3] | (p[3]&g[2]) | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0] | p[3]&p[2]&p[1]&p[0]&c[0];
    //assign Sum=p^c;
    or  U2(Cout,g[3],t);
    xor U3(Sum[0],p[0],c[0]);
    xor U4(Sum[1],p[1],c[1]);
    xor U5(Sum[2],p[2],c[2]);
    xor U6(Sum[3],p[3],c[3]);

endmodule //sumador si se agrega 2's resta


module Twos
  (input [31:0] A,
    output [31:0] B);

    assign B = ~A+1;

endmodule //complemento 2

module suma
  (input [31:0] A,B,
    input cin,
    output [31:0] Sum,
    output  cout);

    wire [31:0] Sal;

    carry_look_ahead_32bit cla3(.a(A),.b(B), .cin(cin), .sum(Sal),.cout(cout));
    assign Sum=Sal;


endmodule //suma o resta

module DespD
	(input [31:0] A,B,
	input AluFlagIn,
	output reg [31:0] Y,
	output Flags);

reg Ne;	 // Negativo
reg C;
reg Ca;  //  Acarreo

	always @(A or B or AluFlagIn) begin
		Y <= (A >> B)|((AluFlagIn *(2**B -1)) << (32-B));
		end
assign Flags=A[31-B];
//always @(A, B, Y, AluFlagIn) begin

//		if (B==0)
//			Ca= 1'b0;
//		if (B!=0)
//			Ca = (B>n) ? AluFlagIn : A[B-1];

//		if (Y == 0);
//			C = 1'b1;
//		if (Y!=0)
//			C = 1'b0
endmodule

module DespI

	(input [31:0] A,B,
	input AluFlagIn,
	output reg [31:0] Y,
	output  Flags);

reg Ne;	 // Negativo
reg C;
reg Ca;  //  Acarreo

	always @(A or B or AluFlagIn) begin
		Y <= (A << B)|(AluFlagIn *(2**B -1));
		end

assign Flags=A[31-B];
	//always @(A, B, Y, AluFlagIn) begin

	//	if (B==0)
	//		assign Ca= 1'b0;
	//	else
	//		assign Ca = (B>n) ? AluFlagIn : A[B-1];
	//	if (Y == 0);
	//		assign C = 1'b1;
	//	else
	//		assign C = 1'b0
	//	if (Y[n] == 1)
	//		assign Ne = 1'b1
	//	else
	//		assign Ne = 1'b0
	//	end
endmodule

module carry_look_ahead_32bit(a,b, cin, sum,cout);
input [31:0] a,b;
input cin;
output [31:0] sum;
output cout;
wire c1,c2,c3,c4,c5,c6,c7;


plusless cla1 (.A(a[3:0]), .B(b[3:0]), .Cin(cin), .Sum(sum[3:0]), .Cout(c1));
plusless cla2 (.A(a[7:4]), .B(b[7:4]), .Cin(c1), .Sum(sum[7:4]), .Cout(c2));
plusless cla3 (.A(a[11:8]), .B(b[11:8]), .Cin(c2), .Sum(sum[11:8]), .Cout(c3));
plusless cla4 (.A(a[15:12]), .B(b[15:12]), .Cin(c3), .Sum(sum[15:12]), .Cout(c4));
plusless cla5 (.A(a[19:16]), .B(b[19:16]), .Cin(c4), .Sum(sum[19:16]), .Cout(c5));
plusless cla6 (.A(a[23:20]), .B(b[23:20]), .Cin(c5), .Sum(sum[23:20]), .Cout(c6));
plusless cla7 (.A(a[27:24]), .B(b[27:24]), .Cin(c6), .Sum(sum[27:24]), .Cout(c7));
plusless cla8 (.A(a[31:28]), .B(b[31:28]), .Cin(c7), .Sum(sum[31:28]), .Cout(cout));

endmodule



module ALU
  (input [31:0] ALUA,
    input [31:0] ALUB,
    input [3:0] ALUControl, // add = 4'h0, sub = 4'h1, inc = 4'h2, dec = 4'h3,
                            // and = 4'h4, or = 4'h5, not = 4'h6, xor = 4'h7,
                            // shl = 4'h8, shr = 4'h9
    input ALUFlagIn,
    input Clk,
    output [31:0] ALUResult,
    output [3:0]ALUFlags);  // [3:0] = [V,C,Z,N]


  wire [31:0] Add, Btwos, Menos1, Mas1, Sub, And, Or, Xor, NotA, NotB, DespD, DespI;
  wire c1, c2, c3, c4, c5, c6;
  reg [31:0]ALU1;
  reg [3:0]ALU2;

  //generate

  //if (ALUControl==4'h0)

    Twos A(.A(ALUB),.B(Btwos));
    suma D(.A(ALUA),.B(ALUB), .cin(ALUFlagIn), .Sum(Add),.cout(c1));
    suma DU(.A(ALUA),.B(Btwos), .cin(ALUFlagIn), .Sum(Sub),.cout(c2));
    suma DUT(.A(ALUA),.B(32'd1), .cin(ALUFlagIn), .Sum(Mas1),.cout(c3));
    suma DUT1(.A(ALUA),.B(32'd4294967295), .cin(ALUFlagIn), .Sum(Menos1),.cout(c4));
    DespD DUT2(.A(ALUA),.B(ALUB), .AluFlagIn(ALUFlagIn), .Y(DespD), .Flags(c5));
    DespI DUT3(.A(ALUA),.B(ALUB), .AluFlagIn(ALUFlagIn), .Y(DespI), .Flags(c6));      

    
    assign And=ALUA&ALUB;
    assign Or =ALUA|ALUB;
    assign Xor=ALUA ^ ALUB;
    assign NotA=~ALUA;
    assign NotB=~ALUB;
  //endgenerate
  always @(negedge Clk) begin
    ALU1 = func(ALUControl,ALUFlagIn, Add,Sub,Mas1,Menos1,And,Or,Xor,NotA,NotB);
    ALU2 = flag(ALUA,ALUB,ALUResult,ALUControl,c1,c2,c3,c4,c5,c6);
  end

  assign ALUResult = ALU1;
  assign ALUFlags = ALU2;
  //assign ALUResult = func(ALUControl,ALUFlagIn, Add,Sub,Mas1,Menos1,And,Or,Xor,NotA,NotB);
  //assign ALUFlags= flag(ALUA,ALUB,ALUResult,ALUControl,c1,c2,c3,c4,c5,c6);

  
  function [31:0] func(input [3:0] ALUControl,input ALUFlagIn,input [31:0] Add, input [31:0]Sub, input [31:0] Mas1,input[31:0] Menos1,input [31:0] And, input [31:0] Or, input [31:0] Xor, input [31:0] NotA, input [31:0] notB );
    case (ALUControl)
      4'h0: func=Add;
      4'h1: func=Sub;
      4'h2: func=Mas1;
      4'h3: func=Menos1;
      4'h4: func=And;
      4'h5: func=Or;
      4'h6: begin
            case (ALUFlagIn)
              1'b0: func=NotA;
              default: func=NotB;
            endcase
            end
      4'h7: func=Xor;
      4'h8: func=DespD;
      4'h9: func=DespI;

    endcase
  endfunction


function [3:0] flag(input [31:0]ALUA,ALUB, input [31:0] ALUResult, input [3:0] ALUControl, input c1,c2,c3,c4,c5,c6);
  case (ALUControl)
  4'h0: begin
        flag[3]=0;
        flag[2]=c1;
        flag[0]=0;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        end

  4'h1: begin
        flag[3]=c2;
        flag[2]=0;
        if (ALUB>ALUA)
          flag[0]=1;
        else
          flag[0]=0;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        end
  4'h2: begin
        flag[3]=0;
        flag[2]=c3;
        flag[0]=0;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        end
  4'h3: begin
        flag[3]=c4;
        flag[2]=0;
        if (ALUA==0)
          flag[0]=1;
        else
          flag[0]=0;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        end
  4'h4: begin
        flag[3]=0;
        flag[2]=0;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        flag[0]=0;
        end

  4'h5: begin
        flag[3]=0;
        flag[2]=0;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        flag[0]=0;
        end
  4'h6: begin
        flag[3]=0;
        flag[2]=0;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        flag[0]=0;
        end
  4'h7: begin
        flag[3]=0;
        flag[2]=0;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        flag[0]=0;
        end
  4'h8: begin
        flag[3]=0;
        flag[2]=c5;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        flag[0]=0;
        end
  4'h9: begin
        flag[3]=0;
        flag[2]=c6;
        if (ALUResult=='b0)
          flag[1]=1;
        else
          flag[1]=0;
        flag[0]=0;
        end
  endcase
  
endfunction

endmodule
