@Data Section
.data
.align 4
    val1: .single 1.0 @y0
.align 4
    val2: .single 0.5 @1/2
.align 4
    limit: .single 1e-5

.align 4
    sqrt_print: .asciz "Insert (x) value of sqrt: "
.align 4
    value: .fill 3, 4, 0
.align 4
    scanfp: .asciz "%f"
.align 4
    result: .asciz "O resultado é: %f\n"


.global main
.global printf

.section .text
.global scanf
.arch armv8-a
.arm


main:
    PUSH {LR}
    @Print message to user
    LDR R0, =sqrt_print
    BL printf

    @Read values of x
    LDR R0, =scanfp
    LDR R1, =value
    BL scanf

    @Load float to S0
    LDR R1, =value
    VLDR S0, [R1]

    BL _sqrt

    /*LDR R2, =value
    VLDR S1, [R2]
    VMOV.F32 S1, S0
    LDR R0, =result
    BL printf*/

    
    VCVT.F64.F32 D0, S0
    VMOV.F32 R1, R2, D0
    LDR R0, =result
    
    BL printf
    


    POP {LR}

    BX LR






@ sqrt funtion
    @ Input: s0 -> x
    @ Output: s0 -> sqrt(x)
_sqrt:
    PUSH {LR}
    
    LDR R0, =val1
    VLDR S1, [R0] @ K value 

    LDR R0, =val2
    VLDR S3, [R0] @ 1/2

    LDR R0, =limit
    VLDR S5, [R0] @limit


    _sqrt_loop:
        VDIV.F32 S2, S0, S1 @ X / YK    
        VADD.F32 S2, S2, S1@ YK + X/YK
        VMUL.F32 S2, S2, S3@ 0.5 * (YK + (YK + X / YK))

        VSUB.F32 S4, S1, S2
        VMOV.F32 S1, S2
        VABS.F32 S4, S4
        VCMP.F32 S4, S5
        VMRS APSR_nzcv, FPSCR
    BGT _sqrt_loop
    
    VMOV.F32 S0, S2

    POP {LR}
BX LR 
