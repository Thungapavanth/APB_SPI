module spi_slave_interface_tb();
	reg PCLK, PRESET_n, PWRITE_i, PSEL_i, PENABLE_i;
	reg [2:0] PADDR_i;
	reg [7:0] PWDATA_i;
	reg ss_o;
	reg [7:0] miso_data_i;
	reg receive_data_i, tip_i;

	wire [7:0] PRDATA_o;
	wire mstr_o, cpol_o, cpha_o, lsbfe_o, spiswai_o;
	wire [2:0] sppr_o, spr_o;
	wire send_data_o;
	wire [7:0]mosi_data_o;
	wire [1:0] spi_mode_o;
	wire spi_interrupt_request_o, PREADY_o, PSLVERR_o;
	
	spi_slave_interface DUT(PCLK, PRESET_n, PWRITE_i, PSEL_i, PENABLE_i, PADDR_i, PWDATA_i, ss_o, miso_data_i,receive_data_i, tip_i, PRDATA_o, mstr_o, cpol_o, cpha_o, lsbfe_o, spiswai_o,sppr_o, spr_o,spi_interrupt_request_o, PREADY_o, PSLVERR_o, send_data_o, mosi_data_o, spi_mode_o);
	
	parameter c=10;
	always
	begin
		#(c/2)	PCLK=1'b1;
		#(c/2)	PCLK=1'b0;
	end
	
	task rst_slave_interface;
	begin
		@(negedge PCLK)
			PRESET_n=1'b0;
		@(negedge PCLK)
			PRESET_n=1'b1;			
	end
	endtask
	
	task initialize;
	begin
		ss_o=1'b0;
		tip_i=1'b1;
	end
	endtask
	
	task config_spi_reg(input [2:0]addr, input [7:0]wdata);
	begin
		@(posedge PCLK)
		PSEL_i=1'b1;
		PENABLE_i=1'b0; 
		PWRITE_i=1'b1;	
		PADDR_i=addr;
		PWDATA_i=wdata;
		
		@(posedge PCLK)
		PSEL_i=1'b1;
		PENABLE_i=1'b1;
		PWRITE_i=1'b1;	
		PADDR_i=addr;
		PWDATA_i=wdata;
				
		@(posedge PCLK)
		wait(PREADY_o)
		PENABLE_i=1'b0;						
	end
	endtask
	
	//miso data from peripheral to change in Data register (DR)
	task miso_data_peripheral(input [7:0]miso_data);
	begin
		@(posedge PCLK)
		miso_data_i=miso_data;
	end
	endtask
	
	initial
	begin
		initialize;
		rst_slave_interface;
		config_spi_reg(3'b000, 8'b0101_1101);
		config_spi_reg(3'b001, 8'b0000_0000);
		config_spi_reg(3'b010, 8'b0010_0001);
		config_spi_reg(3'b101, 8'b1100_1101);
		#100;
		miso_data_peripheral(8'b1010_0100);	
	end	
endmodule
