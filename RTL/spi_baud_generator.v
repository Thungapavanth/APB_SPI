module spi_baud_generator(PCLK,PRESET_n,spi_mode_i,spiswai_i,sppr_i,spr_i,cpol_i,cpha_i,ss_i,SCLK_o,BaudRateDivisor_o,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o);
	input PCLK,PRESET_n,spiswai_i,cpol_i,cpha_i,ss_i;
	input [1:0]spi_mode_i;
	input [2:0]sppr_i,spr_i;
	output reg SCLK_o,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o;
	output [11:0]BaudRateDivisor_o;
	wire pre_sclk_s;
	reg [11:0]count_s;


	assign BaudRateDivisor_o =(sppr_i+1'b1)*(2**(spr_i+1'b1));
	assign pre_sclk_s =(cpol_i)? 1'b1:1'b0;
		
	always@(posedge PCLK,negedge PRESET_n)
		begin
			if(!PRESET_n)
			begin
				count_s<=12'b0;
				SCLK_o<=pre_sclk_s;
			end
			
			else if((!ss_i)&&(!spiswai_i)&&((spi_mode_i==2'b00)||(spi_mode_i==2'b01)))
				begin
					if(count_s==((BaudRateDivisor_o/2)-1))
					begin
						SCLK_o<=~SCLK_o;
						count_s<=12'b0;
					end
					else
						count_s<=count_s+1'b1;
				end
			else
			begin
				SCLK_o<=pre_sclk_s;
				count_s<=12'b0;
			end
		end
	always@(posedge PCLK,negedge PRESET_n)
		begin
		if(!PRESET_n)
		begin
			miso_receive_sclk_o<=1'b0;
			miso_receive_sclk0_o<=1'b0;
		end
			else if((!cpha_i && cpol_i)||(cpha_i && !cpol_i))
			begin
				if(SCLK_o)
				begin
					if(count_s==((BaudRateDivisor_o/2)-1))
				
						miso_receive_sclk0_o<=1'b1;
					else
					miso_receive_sclk0_o<=1'b0;
				end
		         	else
				miso_receive_sclk0_o<=1'b0;
			end
			else if((!cpha_i && !cpol_i)||(cpha_i && cpol_i))
			begin
				if(!SCLK_o)
				begin
					if(count_s==((BaudRateDivisor_o/2)-1))
				
						miso_receive_sclk_o<=1'b1;
					else
					miso_receive_sclk_o<=1'b0;
				end
		        	else
				miso_receive_sclk_o<=1'b0;
			end
			else 
			begin
			miso_receive_sclk_o<=1'b0;
			miso_receive_sclk0_o<=1'b0;
		        end
  

	end
	always@(posedge PCLK,negedge PRESET_n)
		begin
		if(!PRESET_n)
		begin
			mosi_send_sclk_o<=1'b0;
			mosi_send_sclk0_o<=1'b0;
		end
			else if((!cpha_i && cpol_i)||(cpha_i && !cpol_i))
			begin
				if(SCLK_o)
				begin
					if(count_s==((BaudRateDivisor_o/2)-2))
				
						mosi_send_sclk0_o<=1'b1;
					else
					mosi_send_sclk0_o<=1'b0;
				end
		         	else
				mosi_send_sclk0_o<=1'b0;
			end
			else if((!cpha_i && !cpol_i)||(cpha_i && cpol_i))
			begin
				if(!SCLK_o)
				begin
					if(count_s==((BaudRateDivisor_o/2)-2))
				
						mosi_send_sclk_o<=1'b1;
					else
					mosi_send_sclk_o<=1'b0;
				end
		        	else
				mosi_send_sclk_o<=1'b0;
			end
			else 
			begin
			mosi_send_sclk_o<=1'b0;
			mosi_send_sclk0_o<=1'b0;
		        end
  

	end
	
endmodule

