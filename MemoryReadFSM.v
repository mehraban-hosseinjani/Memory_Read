module MemoryReadFSM (
    input clk,             // سیگنال ساعت
    input reset,           // سیگنال ریست
    input [1:0] Op,        // نوع دستور (برای تشخیص عملیات Memory Read)
    input Func,            // تابع برای شناسایی دستور LDR
    output reg AdrSrc,     // کنترل انتخاب آدرس
    output reg ALUSrcA,    // ورودی اول ALU
    output reg [1:0] ALUSrcB, // ورودی دوم ALU
    output reg [1:0] ALUOp,   // نوع عملیات ALU
    output reg [1:0] ResultSrc, // کنترل انتخاب نتیجه
    output reg IRWrite,    // سیگنال نوشتن در رجیستر دستور
    output reg NextPC,     // سیگنال برای به‌روز‌رسانی PC
    output reg RegWrite,   // سیگنال نوشتن در رجیستر
    output reg MemRead     // سیگنال خواندن از حافظه
);

    // تعریف حالت‌ها به صورت مقادیر ثابت
    localparam FETCH    = 3'b000;  // S0: Fetch
    localparam DECODE   = 3'b001;  // S1: Decode
    localparam MEM_ADR  = 3'b010;  // S2: MemAdr
    localparam MEM_READ = 3'b011;  // S3: MemRead
    localparam MEM_WB   = 3'b100;  // S4: MemWB

    reg [2:0] current_state, next_state; // حالت فعلی و بعدی

    // بلاک انتقال وضعیت‌ها
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= FETCH; // بازگشت به حالت Fetch در صورت ریست
        else
            current_state <= next_state; // انتقال به حالت بعدی
    end

    // منطق انتقال بین وضعیت‌ها
    always @(*) begin
        // مقدار پیش‌فرض برای جلوگیری از خطا
        next_state = current_state;
        case (current_state)
            FETCH: 
                next_state = DECODE; // انتقال به Decode
            DECODE: 
                if (Op == 2'b01) // اگر دستور Memory Read باشد
                    next_state = MEM_ADR;
                else
                    next_state = FETCH;
            MEM_ADR: 
                next_state = MEM_READ; // انتقال به حالت خواندن حافظه
            MEM_READ: 
                next_state = MEM_WB; // انتقال به نوشتن در رجیستر
            MEM_WB: 
                next_state = FETCH; // بازگشت به Fetch برای دستور بعدی
        endcase
    end

    // منطق خروجی بر اساس وضعیت فعلی
    always @(*) begin
        // مقداردهی پیش‌فرض به سیگنال‌ها
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
