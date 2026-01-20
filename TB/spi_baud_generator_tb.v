module spi_baud_generator_tb();
	reg pclk,preset,spiswai_i,cpol_i,cpha_i,ss_i;
	reg [1:0]spi_mode_i;
	reg [2:0]sppr_i,spr_i;
	wire sclk_o,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o;
	wire [11:0]BaudRateDivisor_o;
	parameter CYCLE=10;
	spi_baud_generator DUT(pclk,preset,spi_mode_i,spiswai_i,sppr_i,spr_i,cpol_i,cpha_i,ss_i,sclk_o,BaudRateDivisor_o,miso_receive_sclk_o,miso_receive_sclk0_o,mosi_send_sclk_o,mosi_send_sclk0_o);

	always
	begin
		#(CYCLE/2);
		pclk=1'b0;
		#(CYCLE/2);
		pclk=~pclk;
	end
	task initialize();
	begin
		cpol_i=1;
		cpha_i=0;
		spi_mode_i=2'b0;
		spiswai_i=1'b0;
		ss_i=1'b1;
	end
	endtask
	task reset();
	begin
		@(negedge pclk);
		preset=1'b0;
		@(negedge pclk);
		preset=1'b1;
	end
	endtask
	task stimulus(input i,j,input[2:0]m,n);
	begin
	@(negedge pclk);
		cpol_i=i;
		cpha_i=j;
		sppr_i=m;
		spr_i=n;
	end
	endtask
	initial
	begin
		initialize;
		reset;
      ss_i=0;
		stimulus(1'b0,1'b1,3'b000,3'b001);
	 	 
	 end
	 
	 
endmodule
			

