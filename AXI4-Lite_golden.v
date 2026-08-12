module AXI4_Lite_golden (
    ARADDR_golden , AWADDR_golden , WDATA_golden,
    WSTRB_golden , RDATA_golden , ACLK_golden , ARESETN_golden , RD_EN
);  
    parameter  DAT_PAR = 32 ;
    input [7:0] ARADDR_golden , AWADDR_golden ; 
    input [DAT_PAR-1:0] WDATA_golden ;
    input [3:0]  WSTRB_golden ;
    reg [1:0] BRESP_golden , RRESP_golden ;
    reg ARREADY_golden , AWREADY_golden , WREADY_golden, RREADY_golden, BVALID_golden , BREADY_golden , RVALID_golden ;
    output reg [DAT_PAR-1:0] RDATA_golden ;
    reg AWVALID_golden , ARVALID_golden , WVALID_golden , TRANSACTION_WRITE_END , TRANSACTION_READ_END ;
    input ACLK_golden , ARESETN_golden , RD_EN ;
    reg [DAT_PAR-1:0] mem_golden [255:0];
    
    always @(posedge ACLK_golden or negedge ARESETN_golden) begin
        if (~ARESETN_golden) begin
            RDATA_golden <= 32'h00000000 ;
            ARREADY_golden <= 0 ; 
            AWREADY_golden <= 0 ;
            WREADY_golden <= 0 ; 
            RREADY_golden <= 0 ; 
            BRESP_golden <= 2'b11 ;
            RRESP_golden <= 2'b11 ; 
            BVALID_golden <= 0 ; 
            BREADY_golden <= 0 ;
            RVALID_golden <= 0 ;
            AWVALID_golden <= 0 ; 
            ARVALID_golden <= 0 ; 
            WVALID_golden <= 0 ;
            TRANSACTION_WRITE_END <= 1 ; 
            TRANSACTION_READ_END <= 1 ;
        end 
        else begin
            if (RD_EN) begin
                if (TRANSACTION_READ_END) begin
                    ARVALID_golden <= 1 ;
                    RREADY_golden <= 1 ;
                    TRANSACTION_READ_END <= 0; 
                end  
                else if (RREADY_golden && ARVALID_golden && ~ARREADY_golden) 
                    ARREADY_golden <= 1 ; 
                else if (RREADY_golden && ARVALID_golden && ARREADY_golden) begin
                    ARREADY_golden <= 0 ;
                    ARVALID_golden <= 0 ;
                    RVALID_golden <= 1 ;
                    RRESP_golden <= 2'b00;
                    RDATA_golden <= mem_golden [ARADDR_golden] ;
                end 
                else if (RVALID_golden && RREADY_golden) begin
                    RVALID_golden <= 0 ;
                    RREADY_golden <= 0 ;
                end   
                else begin
                    TRANSACTION_READ_END <= 1;
                end 
            end 
            else begin
                if (TRANSACTION_WRITE_END && ~BVALID_golden) begin
                    AWVALID_golden <= 1;
                    WVALID_golden <= 1 ;
                    BREADY_golden <=1 ;
                    TRANSACTION_WRITE_END <= 0 ;
                end 
                else if (WVALID_golden && AWVALID_golden && ~AWREADY_golden && ~WREADY_golden) begin
                    AWREADY_golden <= 1 ; 
                    WREADY_golden <= 1 ;
                end 
                else if (AWREADY_golden && WREADY_golden && ~BVALID_golden) begin
                    BVALID_golden <=1;
                    AWVALID_golden <= 0 ;
                    WVALID_golden <= 0 ;
                    AWREADY_golden <= 0 ; 
                    WREADY_golden <= 0 ;
                    BRESP_golden <= 2'b00;
                    mem_golden [AWADDR_golden] <= {WDATA_golden[31:24]*WSTRB_golden[3],WDATA_golden[23:16]*WSTRB_golden[2],WDATA_golden[15:8]*WSTRB_golden[1],WDATA_golden[7:0]*WSTRB_golden[0]} ;
                end
                else if (BVALID_golden && ~TRANSACTION_WRITE_END) 
                    TRANSACTION_WRITE_END <= 1 ;
                else begin
                    BREADY_golden <=0 ;
                    BVALID_golden <=0;
                end 
            end
        end
    end
endmodule