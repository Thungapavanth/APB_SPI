module spi_top_module(PCLK,PRESET_n,PADDR_i,PWRITE_i,PSEL_i,PENABLE_i,PWDATA_i,miso_i,PRDATA_o,PREADY_o,PSLVERR_o,SCLK_o,mosi_o,ss_o,spi_interrupt_request_o);
	input PCLK,PRESET_n,PSEL_i,PWRITE_i,PENABLE_i,miso_i;
	input [2:0]PADDR_i;
	input [7:0]PWDATA_i;
	output [7:0]PRDATA_o;
	output PREADY_o,PSLVERR_o,SCLK_o,ss_o,mosi_o,spi_interrupt_request_o;

// internal connections

	wire mstr_w,cpol_w,cpha_w,lsbfe_w,spiswai_w;
	wire [2:0]sppr_w,spr_w;
	wire [1:0]spi_mode_w;
	
	wire send_data_w,rec_data_w;
	wire [7:0]miso_data_w,mosi_data_w;

	wire miso_r_sclk_w;
	wire miso_r_sclk0_w;
	wire mosi_s_sclk_w;
	wire mosi_s_sclk0_w;

	wire [11:0]brd_w;
	wire tip_w;

	spi_slave_interface si(
	.pclk(PCLK),
	.preset_n(PRESET_n),
	.paddr_i(PADDR_i),
	.pwrite_i(PWRITE_i),
	.psel_i(PSEL_i),
	.penable_i(PENABLE_i),
	.pwdata_i(PWDATA_i),
	.ss_i(ss_o),
	.miso_data_i(miso_data_w),
	.rec_data_i(rec_data_w),
	.tip_i(tip_w),
	.prdata_o(PRDATA_o),
	.mstr_o(mstr_w),
	.cpol_o(cpol_w),
	.cpha_o(cpha_w),
	.lsbfe_o(lsbfe_w),
	.spiswai_o(spiswai_w),
	.sppr_o(sppr_w),
	.spr_o(spr_w),
	.spi_int_req_o(spi_interrupt_request_o),
	.pready_o(PREADY_o),
	.pslverr_o(PSLVERR_o),
	.send_data_o(send_data_w),
	.mosi_data_o(mosi_data_w),
	.spi_mode_o(spi_mode_w));

	spi_baud_generator bg(
	.PCLK(PCLK),
	.PRESET_n(PRESET_n),
	.spi_mode_i(spi_mode_w),
	.spiswai_i(spiswai_w),
	.sppr_i(sppr_w),
	.spr_i(spr_w),
	.cpol_i(cpol_w),
	.cpha_i(cpha_w),
	.ss_i(ss_o),
	.SCLK_o(SCLK_o),
	.miso_receive_sclk_o(miso_r_sclk_w),
	.miso_receive_sclk0_o(miso_r_sclk0_w),
	.mosi_send_sclk_o(mosi_s_sclk_w),
	.mosi_send_sclk0_o(mosi_s_sclk0_w),
	.BaudRateDivisor_o(brd_w));

   spi_shifter s(
	.PCLK(PCLK),
	.PRESET_n(PRESET_n),
	.ss_i(ss_o),
	.send_data_i(send_data_w),
	.lsbfe_i(lsbfe_w),
	.cpha_i(cpha_w),
	.cpol_i(cpol_w),
	.miso_receive_sclk_i(miso_r_sclk_w),
	.miso_receive_sclk0_i(miso_r_sclk0_w),
	.mosi_send_sclk_i(mosi_s_sclk_w),
	.mosi_send_sclk0_i(mosi_s_sclk0_w),
	.data_mosi_i(mosi_data_w),
	.miso_i(miso_i),
	.receive_data_i(rec_data_w),
	.mosi_o(mosi_o),
	.data_miso_o(miso_data_w));

   spi_slave_select ss(
	.PCLK(PCLK),
	.PRESET_n(PRESET_n),
	.mstr_i(mstr_w),
	.spiswai_i(spiswai_w),
	.spi_mode_i(spi_mode_w),
	.send_data_i(send_data_w),
	.baudratedivisor_i(brd_w),
	.receive_data_o(rec_data_w),
	.ss_o(ss_o),
	.tip_o(tip_w));


endmodule


