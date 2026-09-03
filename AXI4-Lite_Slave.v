module AXI_Lite_Slave (
    ACLK_SLAVE,ARESETN_SLAVE,ARADDR_SLAVE,ARVALID_SLAVE,ARREADY_SLAVE,
    AWADDR_SLAVE,AWVALID_SLAVE,AWREADY_SLAVE,WDATA_SLAVE,WSTRB_SLAVE,WVALID_SLAVE,
    BRESP_SLAVE,BVALID_SLAVE,BREADY_SLAVE,RDATA_SLAVE,RVALID_SLAVE,RREADY_SLAVE,WREADY_SLAVE,RRESP_SLAVE
);
    parameter  DAT_PAR = 32 ;
    input [DAT_PAR-1:0] WDATA_SLAVE ;
    input [7:0] AWADDR_SLAVE , ARADDR_SLAVE ;
    input [3:0]  WSTRB_SLAVE ;
    output ARREADY_SLAVE , AWREADY_SLAVE  , BVALID_SLAVE , WREADY_SLAVE , RVALID_SLAVE ;
    output [31:0] RDATA_SLAVE ;
    input AWVALID_SLAVE , ARVALID_SLAVE , WVALID_SLAVE , RREADY_SLAVE , BREADY_SLAVE ;
    input ACLK_SLAVE , ARESETN_SLAVE ;
    output [1:0] BRESP_SLAVE , RRESP_SLAVE ;
    wire [31:0] W_TEMP ;
    parameter IDLE = 0 , ACTIVE = 1 ;
    reg cs , ns ;
    AXI4_Lite_Ram ram (.ARADDR_RAM(ARADDR_SLAVE) , .AWADDR_RAM(AWADDR_SLAVE) , .WDATA_RAM(W_TEMP) , .ACLK_RAM(ACLK_SLAVE) ,
    .ARESETN_RAM(ARESETN_SLAVE) , .RDATA_RAM(RDATA_SLAVE) , .WREADY_RAM(WREADY_SLAVE) , .ARREADY_RAM(ARREADY_SLAVE));
    always @(posedge ACLK_SLAVE or negedge ARESETN_SLAVE) begin
        if (~ARESETN_SLAVE) begin
            cs <= IDLE ;
        end
        else begin
            cs <= ns ;    
        end
    end
    always @(*) begin
        if (ARVALID_SLAVE || WVALID_SLAVE || AWVALID_SLAVE || RREADY_SLAVE || BREADY_SLAVE) begin
            ns = ACTIVE ;
        end
        else begin
            ns = IDLE ;
        end
    end
    assign ARREADY_SLAVE = (ARVALID_SLAVE && RREADY_SLAVE && cs == ACTIVE)?1:0;
    assign RVALID_SLAVE = (~ARREADY_SLAVE && ~ARVALID_SLAVE && cs == ACTIVE && RREADY_SLAVE)?1:0;
    assign WREADY_SLAVE = (WVALID_SLAVE && BREADY_SLAVE && cs == ACTIVE)?1:0;
    assign AWREADY_SLAVE = (AWVALID_SLAVE && cs == ACTIVE && BREADY_SLAVE)?1:0;
    assign BVALID_SLAVE = (~AWREADY_SLAVE && cs == ACTIVE && ~WREADY_SLAVE && BREADY_SLAVE)?1:0;
    assign W_TEMP ={WDATA_SLAVE[31:24]*WSTRB_SLAVE[3],WDATA_SLAVE[23:16]*WSTRB_SLAVE[2],WDATA_SLAVE[15:8]*WSTRB_SLAVE[1],WDATA_SLAVE[7:0]*WSTRB_SLAVE[0]};
    assign BRESP_SLAVE = (cs == IDLE)?2'b11:2'b00;
    assign RRESP_SLAVE = (cs == IDLE)?2'b11:2'b00;
endmodule
