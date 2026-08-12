module AXI4_Lite_Master (
    ACLK,ARESETN,ARADDR,ARVALID,ARREADY,
    AWADDR,AWVALID,AWREADY,WDATA,WSTRB,WVALID,RRESP,
    BRESP,BVALID,BREADY,RDATA,RVALID,RREADY,WREADY
);
    parameter  DAT_PAR = 32 ;
    input [7:0] ARADDR , AWADDR ;
    input [DAT_PAR-1:0] RDATA , WDATA ;
    input [3:0]  WSTRB ;
    input ARREADY , AWREADY  , BVALID  , RVALID ,WREADY ;
    input [1:0] BRESP , RRESP ;
    input ACLK , ARESETN ;
    output reg AWVALID , ARVALID , WVALID , RREADY , BREADY ;
    reg HANDSHAKE_WR , HANDSHAKE_RE ;
    reg [7:0] AWADDR_old , ARADDR_old  ; 
    reg [DAT_PAR-1:0] WDATA_old ;
    
    AXI_Lite_Slave slave1 (.ARADDR_SLAVE(ARADDR) , .AWADDR_SLAVE(AWADDR) , .WDATA_SLAVE(WDATA) , .WSTRB_SLAVE(WSTRB) , .ARVALID_SLAVE(ARVALID) , .RRESP_SLAVE(RRESP) ,
    .AWVALID_SLAVE(AWVALID) , .RVALID_SLAVE(RVALID) , .ACLK_SLAVE(ACLK) , .ARESETN_SLAVE(ARESETN) , .ARREADY_SLAVE(ARREADY) , .WVALID_SLAVE(WVALID) ,
    .AWREADY_SLAVE(AWREADY) , .RREADY_SLAVE(RREADY) , .BRESP_SLAVE(BRESP) , .BVALID_SLAVE(BVALID) , .BREADY_SLAVE(BREADY) , .RDATA_SLAVE(RDATA) ,.WREADY_SLAVE(WREADY));
    
    always @(posedge ACLK or negedge ARESETN) begin
        if (~ARESETN) begin
            AWVALID <=0 ;
            ARVALID <=0 ;
            WVALID <=0 ;
            BREADY <=0;
            RREADY <=0;
            HANDSHAKE_RE <= 0 ;
            HANDSHAKE_WR <= 0 ;
            AWADDR_old <= 8'h00 ;
            ARADDR_old <= 8'h00 ;
            WDATA_old <= 32'h00000000 ;
        end 
        else begin
            AWADDR_old <= AWADDR ;
            ARADDR_old <= ARADDR ;
            WDATA_old <= WDATA;
            if (ARADDR_old != ARADDR) begin
                ARVALID <= 1 ;
                RREADY <= 1 ;
            end    
            else if (ARREADY) begin
                HANDSHAKE_RE <= 1 ;
                ARVALID <= 0 ;
            end
            else if (RREADY && RVALID) begin
                HANDSHAKE_RE <= 0 ;
                RREADY <= 0 ;
            end
            else 
                HANDSHAKE_RE <= 0 ;        
            if (WDATA_old != WDATA || AWADDR_old != AWADDR )  begin
                WVALID <= 1 ;
                AWVALID <= 1 ;
                BREADY <= 1 ;
            end
            else if (AWREADY && WREADY) begin
                HANDSHAKE_WR <= 1 ;
                AWVALID <= 0 ;
                WVALID <= 0 ;
            end 
            else if (BVALID) begin
                HANDSHAKE_WR <= 0 ;
                BREADY <= 0 ;
            end
            else 
                HANDSHAKE_WR <= 0 ;          
        end    
    end
endmodule