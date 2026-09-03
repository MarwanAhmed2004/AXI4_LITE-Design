module AXI4_Lite_Ram #(parameter DAT_PAR = 32 )(
    ACLK_RAM,ARESETN_RAM,ARADDR_RAM,
    AWADDR_RAM,WDATA_RAM,RDATA_RAM,ARREADY_RAM,WREADY_RAM
);
    input [DAT_PAR-1:0] WDATA_RAM ;
    input [7:0] ARADDR_RAM , AWADDR_RAM ;
    input ACLK_RAM , ARESETN_RAM , ARREADY_RAM , WREADY_RAM ;
    output reg [DAT_PAR-1:0] RDATA_RAM ;
    reg [DAT_PAR-1:0] mem [255:0] ;

    always @(posedge ACLK_RAM ) begin
        if (~ARESETN_RAM) begin
            RDATA_RAM <= 32'h00000000 ;
        end 
        else begin
            if (ARREADY_RAM) begin
              RDATA_RAM <= mem [ARADDR_RAM] ;  
            end
            if (WREADY_RAM) begin
                mem [AWADDR_RAM] <= WDATA_RAM ;
            end  
        end
    end
endmodule
