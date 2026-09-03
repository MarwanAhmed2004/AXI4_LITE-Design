module AXI4_Lite_top #(parameter  DAT_PAR = 32 )(
    ACLK,ARESETN,ARADDR,
    AWADDR,WDATA,WSTRB,RDATA
);
    input [7:0] ARADDR , AWADDR ;
    input ACLK , ARESETN ;
    output [DAT_PAR-1:0] RDATA ;
    input [DAT_PAR-1:0] WDATA ;
    input [3:0]  WSTRB ;
    AXI4_Lite_Master #(DAT_PAR) master1  (.ARADDR(ARADDR) , .AWADDR(AWADDR) , .WDATA(WDATA) , 
    .WSTRB(WSTRB) , .ACLK(ACLK) , .ARESETN(ARESETN_tb) , .RDATA(RDATA));
endmodule