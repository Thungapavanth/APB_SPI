module spi_top_module_tb(); 
	  
    reg         PCLK; 
    reg         PRESET_n; 
    reg  [2:0]  PADDR_i; 
    reg         PWRITE_i; 
    reg         PSEL_i; 
    reg         PENABLE_i; 
    reg  [7:0]  PWDATA_i; 
    wire [7:0]  PRDATA_o; 
    wire        PREADY_o; 
    wire        PSLVERR_o; 
    wire        sclk_o; 
    wire        mosi_o; 
    wire        ss_o; 
    reg         miso_i; 
    wire        spi_interrupt_request_o;

   spi_top_module DUT(.PCLK(PCLK),.PRESET_n(PRESET_n),.PADDR_i(PADDR_i),.PWRITE_i(PWRITE_i),.PSEL_i(PSEL_i),.PENABLE_i(PENABLE_i),.miso_i(miso_i),.PWDATA_i(PWDATA_i),
	   .ss_o(ss_o),.SCLK_o(sclk_o),.spi_interrupt_request_o(spi_interrupt_request_o),.mosi_o(mosi_o),.PREADY_o(PREADY_o),.PSLVERR_o(PSLVERR_o),
	   .PRDATA_o(PRDATA_o)); 
 
   
  integer i=0; 
 
     initial begin 
         PCLK = 0; 
         forever #5 PCLK = ~PCLK;   
      end 
 
     task initialize(); 
  begin 
   @(negedge PCLK); 
   	  PSEL_i    = 0; 
          PENABLE_i = 0; 
          PWRITE_i  = 0; 
          miso_i    = 0; 
          PADDR_i   = 0; 
          PWDATA_i  = 0; 
  end 
 endtask 
 
 
     task reset(); 
   begin 
   @(negedge PCLK) 
         PRESET_n  = 0; 
         @(negedge PCLK); 
         PRESET_n = 1; 
   end 
  endtask 
 
 
 
    task apb_write(input [2:0] addr, input [7:0] data); 
     begin 
        PADDR_i   = addr; 
        PWDATA_i  = data; 
        PWRITE_i  = 1; 
        PSEL_i    = 1; 
        PENABLE_i = 0; 
 
        @(negedge PCLK); 
        PENABLE_i = 1; 
 
        @(negedge PCLK); 
      	wait(PREADY_o); 
        //PSEL_i    = 0; 
        PENABLE_i = 0; 
       // PWRITE_i  = 0; 
		@(negedge PCLK); 
 
    end 
    endtask 
 
 
    task apb_read(input [2:0] addr); 
     begin 
        PADDR_i   = addr; 
        PWRITE_i  = 0; 
        PSEL_i    = 1; 
        PENABLE_i = 0; 
 
        @(negedge PCLK); 
        PENABLE_i = 1; 
 
        @(negedge PCLK); 
        wait(PREADY_o); 
        //$display("READ @ %0d = %0h", addr, PRDATA_o); 
        PSEL_i    = 0; 
        PENABLE_i = 0; 
		  @(negedge PCLK); 
 
    end 
    endtask 
   
  task in_0(input [7:0]a); 
  begin  
    for(i=7;i>=0;i=i-1) 
     begin 
      @(posedge sclk_o); 
      miso_i<=a[i]; 
     end 
  end 
 endtask 
 
 task in_1(input [7:0]a); 
  begin 
   wait(!ss_o)  
    for(i=0;i<8;i=i+1) 
     begin 
     @(posedge sclk_o);  
      miso_i<=a[i];       
     end 
  end 
 endtask 

      initial  
   begin 
   initialize(); 
   reset(); 
        apb_write(3'b000, 8'b01010110);  // CR1 
        apb_write(3'b001, 8'b00000000);  // CR2 
        apb_write(3'b010, 8'b00000001);  // BR 
		  apb_write(3'b101, 8'b10110110);  //DR
        in_1(8'b11010111);
        #100 apb_read(3'b101);   // Should read received byte 
	#1000 $finish; 
    end 
endmodule
