module counter
  #(parameter N = 3)
  (
    input clk,rst,
    inout [N-1:0] out_or_load,
    input we,trig,
    output out_pulse
);
reg [N-1:0] out;
wire [N-1:0] load;
reg trig_r,st;

assign out_or_load = we ? out: 4'bZ;
assign load = !we ? out_or_load :load;
assign out_pulse = (out == load);
  
always @(posedge clk or posedge rst)
begin 
	if(rst) begin
		out <= 0;
		st <= 0;
		trig_r <= 0;
	end
	else begin 
		trig_r <= trig;
		if(trig) begin  
			if ( trig_r^trig ) begin
				st<= 1'b1;
			end
		end
        else begin 
        	if (st ) begin 
        		if (we) begin 
        			out <= out + 1;
        			if(out == load ) begin 
        				out <= 0;
        			end
        		end
        		else begin 
        			st <= 0;
        		end
        	end
        end
    end
end
  
endmodule