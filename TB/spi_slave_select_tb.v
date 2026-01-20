module spi_slave_select_tb();
	reg PCLK,PRESET_n,mstr_i,send_data_i,spiswai_i;
	reg [1:0]spi_mode_i;
	reg [11:0]baudratedivisor_i;
	wire ss_o,receive_data_o;
	wire tip_o;
	parameter CYCLE=10;
	spi_slave_select DUT(PCLK,PRESET_n,mstr_i,send_data_i,spiswai_i,spi_mode_i,ss_o,baudratedivisor_i,tip_o,receive_data_o);

	always
	begin
		#(CYCLE/2);
		PCLK=1'b0;
		#(CYCLE/2);
		PCLK=~PCLK;
	end
	task reset();
		begin
			@(negedge PCLK);
			PRESET_n=1'b0;
			//@(negedge PCLK);
			PRESET_n=1'b1;
		end
	endtask
	task initialize();
		begin
			{PCLK,PRESET_n,mstr_i,send_data_i,spiswai_i}=0;
			spi_mode_i=1'b0;
			baudratedivisor_i=12'b0;
		end
	endtask
	task stimulus(input a,b,c,e, input [1:0]x ,input[11:0]y);
		begin
			@(negedge PCLK);
			mstr_i=a;
			spiswai_i=b;
			send_data_i=c;
			@(negedge PCLK);
			send_data_i=e;
			spi_mode_i=x;
			baudratedivisor_i=y;
		end
	endtask
	initial
	begin
		initialize;
		reset;
		stimulus(1'b1,1'b0,1'b1,1'b0,2'b00,12'b10);
	end
	initial
	begin
	#1000 $finish;
	end
endmodule



