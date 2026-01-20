module spi_slave_select(PCLK,PRESET_n,mstr_i,send_data_i,spiswai_i,spi_mode_i,ss_o,baudratedivisor_i,tip_o,receive_data_o);
	input PCLK,PRESET_n,mstr_i,send_data_i,spiswai_i;
	input [1:0]spi_mode_i;
	input [11:0]baudratedivisor_i;
	output reg ss_o,receive_data_o;
	output tip_o;
	reg [15:0]count_s;
	wire [15:0] target_s;
	reg rcv_s;
	
	
	assign target_s =(8*baudratedivisor_i);
	assign tip_o = ~ss_o;

	always@(posedge PCLK or negedge PRESET_n)
	begin
		if(!PRESET_n)
		begin
			count_s<=16'hffff;
			ss_o<=1'b1;
			rcv_s<=1'b0;
		end
		else if(mstr_i && (spi_mode_i==2'b00)||(spi_mode_i==2'b01) && (!spiswai_i))
		begin
			if(send_data_i)
			begin
				ss_o<=0;
		    		count_s<=16'h0;
			end
			else if(count_s < (target_s-1'b1))
			begin
				ss_o<=0;
				count_s<=count_s+16'h1;
				rcv_s<=1'b0;
			end
			 else if(count_s==(target_s-1'b1))
			 begin
			   
				 rcv_s<=1'b1;
				 count_s <= 16'hffff;
				 ss_o<=1;
			 end
			 else
			 begin
				 ss_o<=1;
			 	 rcv_s<=0;
			 	 count_s<=16'hFFFF;	 
			 end
		 end
		else
		begin
			ss_o<=1;
			rcv_s<=0;
			count_s<=16'hFFFF;
		end
	end
	always@(posedge PCLK or negedge PRESET_n)
	begin
		if(!PRESET_n)
		begin
			receive_data_o<=1'b0;
		end
		else
			receive_data_o<=rcv_s;
	end
endmodule

