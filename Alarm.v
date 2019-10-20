module alclock(clk, rst, h1in, h0in, m1in, m0in, alon, aloff, alset, clset, h1out, h0out, m1out, m0out, s1out, s0out, Alarm_out);
input clk, rst, alon, aloff, alset, clset;
input [1:0]h1in;
input [3:0]h0in,m1in,m0in;
output wire [1:0]h1out;
output wire [3:0]h0out, m1out,m0out, s1out, s0out;
output reg Alarm_out;
reg [1:0]th1;
reg [3:0]th0, tm1, tm0, ts1, ts0;
reg [1:0]ah1;
reg [3:0]ah0, am1, am0, as1, as0;
reg [7:0] thhh;

always@(posedge clk or posedge rst)
begin
    if(rst)
    begin
        th0<=2'b00;
        th1<=4'b0000;
        tm0<=4'b0000;
        tm1<=4'b0000;
        ts0<=4'b0000;
        ts1<=4'b0000;
    end
    else if(alset)
    begin
        ah1<=h1in;
        ah0<=h0in;
        am1<=m1in;
        am0<=m0in;
        as1<=4'b0000;
        as0<=4'b0000;
    end
    else if(clset)
    begin
        th0<=h0in;
        th1<=h1in;
        tm0<=m0in;
        tm1<=m1in;
        ts0<=4'b0000;
        ts1<=4'b0000;
    end
    else
    begin
        ts0<=ts0+1;
		  if({th1,th0,tm1,tm0,ts1,ts0}>=22'b1000110101100101011001)
        begin
            th1<=4'b0000;
            th1<=th1+1;
        end
		  if(th1<2'b10)     
				if({th0,tm1,tm0,ts1,ts0}>=20'b10010101100101011001)
					begin
						th0<=4'b0000;
							th1<=th1+1;
					end
		  else
				if({th0,tm1,tm0,ts1,ts0}>=20'b00110101100101011001)
						th0<=4'b0000;
		  
		  
		  if({tm1,tm0,ts1,ts0}>=16'b0101100101011001)
        begin
            tm1<=4'b0000;
				if(th0<4'b1001)
            th0<=th0+1;
        end
		  
		  
        if({tm0,ts1,ts0}>=12'b100101011001)
        begin
            tm0<=4'b0000;
				if(tm1<4'b0101)
            tm1<=tm1+1;
        end
        
        
      
		  if({ts1,ts0}>=8'b01011001)
        begin
            ts1<=4'b0000;
				if(tm0<4'b1001)
            tm0<=tm0+1;
        end
		  
		  if(ts0==9)
        begin
            ts0<=4'b0000;
				if(ts1<4'b0101)
					ts1<=ts1+1;
        end
		  
		  thhh<={ts1,ts0}+1;
    end
end
always@(posedge clk or posedge rst)
begin
    if(rst)
        Alarm_out=0;
    else
    begin
        if({th1,th0,tm1,tm0,ts1,ts0}=={ah1,ah0,am1,am0,as1,as0})
            if(alon)
                Alarm_out<=1;
            if(aloff)
                Alarm_out<=0;
    end
	 if(aloff)
                Alarm_out<=0;
end

assign h1out=th1;
assign h0out=th0;
assign m1out=tm1;
assign m0out=tm0;
assign s1out=ts1;
assign s0out=ts0;

endmodule

