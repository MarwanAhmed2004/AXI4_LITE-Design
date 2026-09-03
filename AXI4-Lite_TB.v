module AXI4_Lite_TB (
);

    reg [31:0] WDATA_tb ;
    reg [7:0] ARADDR_tb , AWADDR_tb ;
    reg ACLK_tb , ARESETN_tb ,RD_EN_TB;
    reg [3:0]  WSTRB_tb ;
    wire [31:0] RDATA_tb1 ,RDATA_golden_tb1 ;
    AXI4_Lite_top dut1 (.ARADDR(ARADDR_tb) , .AWADDR(AWADDR_tb) , .WDATA(WDATA_tb) , 
    .WSTRB(WSTRB_tb) , .ACLK(ACLK_tb) , .ARESETN(ARESETN_tb) , .RDATA(RDATA_tb1));
    AXI4_Lite_golden golden1 (.ARADDR_golden(ARADDR_tb) , .AWADDR_golden(AWADDR_tb) , .WDATA_golden(WDATA_tb) , .RD_EN(RD_EN_TB) , 
    .WSTRB_golden(WSTRB_tb) , .ACLK_golden(ACLK_tb) , .ARESETN_golden(ARESETN_tb) , .RDATA_golden(RDATA_golden_tb1));
    integer err_count = 0 , correct_count = 0 ;
    initial begin
        ACLK_tb = 0 ;
        forever begin
            #1 ACLK_tb = ~ACLK_tb;
        end
    end
    initial begin
        ARESETN_tb = 0 ;
        ARADDR_tb = 8'h00 ;
        AWADDR_tb = 8'h00;  
        WDATA_tb = 32'h00000000 ;
        WSTRB_tb = 4'b0000 ;
        RD_EN_TB = 0;
        @(negedge ACLK_tb);
        ARESETN_tb = 1 ;
        WSTRB_tb = 4'hf ;
        repeat (1000) begin
            WSTRB_tb = $random ;
            AWADDR_tb = $random ;
            WDATA_tb = $random ;
            repeat (5) 
                @(negedge ACLK_tb);
        end 
        RD_EN_TB = 1;
        repeat (1000) begin
            ARADDR_tb = $random ; 
            @(negedge ACLK_tb);
            if (RDATA_golden_tb1 != RDATA_tb1) begin
                $display ("ERROR RDATA =%h , RDATA_GOLDEN = %h" ,RDATA_tb1,RDATA_golden_tb1);
                err_count = err_count+1;
            end
            else
                correct_count = correct_count + 1 ;
            repeat (4) 
                @(negedge ACLK_tb);
        end
         $display ("ERROR COUNTS =%d , CORRECT COUNTS = %d" ,err_count,correct_count);
        $stop ;
    end
endmodule
