module MemoryReadFSM (
    input clk,             
    input reset,           
    input [1:0] Op,        
    input Func,           
    output reg AdrSrc,    
    output reg ALUSrcA,   
    output reg [1:0] ALUSrcB, 
    output reg [1:0] ALUOp,   
    output reg [1:0] ResultSrc, 
    output reg IRWrite,   
    output reg NextPC,    
    output reg RegWrite,   
    output reg MemRead     
);

   
    localparam FETCH    = 3'b000;  // S0: Fetch
    localparam DECODE   = 3'b001;  // S1: Decode
    localparam MEM_ADR  = 3'b010;  // S2: MemAdr
    localparam MEM_READ = 3'b011;  // S3: MemRead
    localparam MEM_WB   = 3'b100;  // S4: MemWB

    reg [2:0] current_state, next_state; 


    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= FETCH; 
        else
            current_state <= next_state; 
    end

   
    always @(*) begin
        
        next_state = current_state;
        case (current_state)
            FETCH: 
                next_state = DECODE; 
            DECODE: 
                if (Op == 2'b01)
                    next_state = MEM_ADR;
                else
                    next_state = FETCH;
            MEM_ADR: 
                next_state = MEM_READ;
            MEM_READ: 
                next_state = MEM_WB; 
            MEM_WB: 
                next_state = FETCH; 
        endcase
    end

    
    always @(*) begin
       
        AdrSrc = 0; ALUSrcA = 0; ALUSrcB = 2'b00; ALUOp = 2'b00; 
        ResultSrc = 2'b00; IRWrite = 0; NextPC = 0; RegWrite = 0; MemRead = 0;

        case (current_state)
            FETCH: begin
                AdrSrc = 0;
                ALUSrcA = 1;
                ALUSrcB = 2'b10;
                ALUOp = 2'b00;
                ResultSrc = 2'b10;
                IRWrite = 1;
                NextPC = 1;
            end
            DECODE: begin
                ALUSrcA = 1;
                ALUSrcB = 2'b10;
                ALUOp = 2'b00;
                ResultSrc = 2'b10;
            end
            MEM_ADR: begin
                ALUSrcA = 0;
                ALUSrcB = 2'b01;
                ALUOp = 2'b00;
            end
            MEM_READ: begin
                MemRead = 1;
                AdrSrc = 1;
                ResultSrc = 2'b00;
            end
            MEM_WB: begin
                ResultSrc = 2'b01;
                RegWrite = 1;
            end
        endcase
    end

endmodule
