module spi_shifter(PCLK,PRESET_n,ss_i,send_data_i,lsbfe_i,cpha_i,cpol_i,miso_receive_sclk_i,miso_receive_sclk0_i,data_mosi_i,miso_i,receive_data_i,mosi_o,data_miso_o,mosi_send_sclk_i,mosi_send_sclk0_i);
	input [7:0]data_mosi_i;
	input PCLK,PRESET_n,ss_i,send_data_i,lsbfe_i,cpha_i,cpol_i,miso_receive_sclk_i,miso_receive_sclk0_i,miso_i,mosi_send_sclk_i,mosi_send_sclk0_i;
	input receive_data_i;
	output reg mosi_o;
	output reg [7:0]data_miso_o;
	reg [7:0]shift_register,temp_reg;
	reg [2:0]count,count1;
	reg [2:0]count2,count3;

	always@(posedge PCLK or negedge PRESET_n)
	begin
		if(!PRESET_n)
			shift_register<=8'b00000000;
		else 
			begin
				if(send_data_i==1)
					shift_register<=data_mosi_i;
				else
					shift_register<=shift_register;
			end
	end
	always@(*)
	begin
		if(receive_data_i==1)
			data_miso_o=temp_reg;
		else
			data_miso_o=8'b00000000;
	end
	//transmite data bit by bit(mosi)...
	always@(posedge PCLK or negedge PRESET_n)
	begin
		if(!PRESET_n)
		begin
			mosi_o<=1'b0;
			count<=3'b000;
		        count1<=3'b111;
			end
		else if(!ss_i)
		begin
			if((!cpha_i && cpol_i)||(cpha_i && !cpol_i))
			begin
				if(lsbfe_i)
				begin
					if(count<=3'd7)
					begin
						if(mosi_send_sclk_i)
							begin
								mosi_o<=shift_register[count];
								count<=count+1'b1;
							end
						end
						else
							count<=3'b0;
					
					end
				else
				begin
					if(count1>=3'b0)
					begin
						if(mosi_send_sclk_i)
						begin
							mosi_o<=shift_register[count1];
							count1<=count1-1'b1;
						end
					end
					else
						count1<=3'd7;
				end
			end
			else
			begin
				if(lsbfe_i)
				begin
					if(count<=3'd7)
					begin
						if(mosi_send_sclk0_i)
						begin
							mosi_o<=shift_register[count];
							count<=count+1'b1;
						end
					end
					else
						count<=3'b0;
				end
				else
				begin
					if(count1>=3'b0)
					begin
						if(mosi_send_sclk0_i)
						begin
							mosi_o<=shift_register[count1];
							count1<=count1-1'b1;
						end
					end
					else
						count1<=3'd7;
				end
			end
		end
	end
	
	//receive data bit by bit(miso)

	always@(posedge PCLK or negedge PRESET_n)
	begin
		if(!PRESET_n)
		begin
			temp_reg<=8'b0;
			count2<=3'b0;
			count3<=3'd7;
		end
		else if(!ss_i)
		begin
			if((!cpha_i && cpol_i)||(cpha_i && !cpol_i))
			begin
				if(lsbfe_i)
				begin
					if(count2<=3'd7)
					begin
						if(miso_receive_sclk0_i)
						begin
							temp_reg[count2]<=miso_i;
							count2<=count2+1'b1;
						end
					end
					else
						count2<=3'b0;
				end
				else
				begin
					if(count3>=3'b0)
					begin
						if(miso_receive_sclk0_i)
						begin
							temp_reg[count3]<=miso_i;
							count3<=count3-1'b1;
						end
					end
					else
						count3<=3'd7;
				end
			end
			else
			begin
				if(lsbfe_i)
				begin
					if(count2<=3'd7)
					begin
						if(miso_receive_sclk_i)
						begin
							temp_reg[count2]<=miso_i;
							count2<=count2+1'b1;
						end
					end
					else
						count2<=3'b0;
				end
				else
				begin
					if(count3>=3'b0)
					begin
						if(miso_receive_sclk_i)
						begin
							temp_reg[count3]<=miso_i;
							count3<=count3-1'b1;
						end
					end
					else
						count3<=3'd7;
				end
			end
		end
	end

							
					
endmodule






