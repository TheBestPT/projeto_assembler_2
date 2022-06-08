@Data Section
.data
/*
"Global" Variables
 */
.balign 4
    testNumber: .single 5.0
.balign 4
    scanInputInt: .asciz "%d"
.balign 4
    inputOption: .fill 50, 1, 0
.balign 4
    scanInputString: .asciz "%f\n"
.balign 4
    insertInt: .asciz "Insira um inteiro: "
.balign 4
    testInt: .asciz "%d"
.balign
    mainMenu: .asciz "Menu\n1 - sqrt\n2 - fabs\n3 - fatorial\n4 - exp\n5- sinh\n6 - cosh\n\nEscolha uma opção: "
.align 4
    zero: .single 0.0
.align 4
    one: .single 1.0
.align 4
    dois: .single 2.0
.align 4
    two: .single 2.0
/*
SQRT VARIABLES
 */
.align 4
    val1: .single 1.0 @y0
.align 4
    val2: .single 0.5 @1/2
.align 4
    limit: .single 1e-5
.balign 4 
    sqrt_print: .asciz "Insert (x) value for sqrt(x): "
.align 4
    numero: .fill 3, 4, 0
.balign 4 
    scanfp: .asciz "%f"
.align 4
    resultado: .asciz "O resultado é: %f\n"

/*
FABS VARIABLES
 */
.align 4
    numeroFabs: .fill 3, 4, 0
.align 4
    fabs_print: .asciz "Insert (x) value for fabs(x): "

/*
EXP VARIABLES
 */
.align 4
    numeroExp: .fill 3, 4, 0
.align 4
    exp_print: .asciz "Insert (x) value for exp(x): "

/*
SINH VARIABLES
 */

.align 4
    sinh_print: .asciz "Insert (x) value for sinh(x): "

/*
COSH VARIABLES
 */

.align 4
    cosh_print: .asciz "Insert (x) value for cosh(x): "
@External C functions

.global scanf
.global printf

@Code Section
.Section .text
.global main
.arch armv8-a
.arm


main:

    PUSH {LR}
    LDR R0, =mainMenu
    BL printf

    LDR R0, =scanInputInt
    LDR R1, =inputOption
    BL scanf

    LDR R0, =inputOption
    LDRB R2, [R0, #0]
    MOV R0, R2




    //-------------- CALL sqrt 
    
    CMP R0, #1
    BLEQ _callSqrt

    CMP R0, #2
    BLEQ _callFabs

    CMP R0, #3
    BLEQ _callFatorial


    CMP R0, #4
    BLEQ _callExp

    CMP R0, #5
    BLEQ _callSinh

    CMP R0, #6
    BLEQ _callCosh

    POP {LR}
    BX LR

_exit: 
    MOV R7, #1
    SVC #0 @Invoke Syscall

_callSqrt:
    PUSH {R0, LR}

    @Print message to user
    LDR R0, =sqrt_print
    BL printf

    @Read values of x
    LDR R1, =numero
    LDR R0, =scanfp
    BL scanf

    @Load float to 50
    LDR R1, =numero
    VLDR S0, [R1]
    BL _sqrt

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf

    POP {R0, LR}
BX LR


_callFabs:
    PUSH {R0, LR}
    @Print message to user
    LDR R0, =fabs_print
    BL printf

    @Read values of x
    LDR R1, =numero
    LDR R0, =scanfp
    BL scanf

    @Load float to 50
    LDR R1, =numero
    VLDR S0, [R1]
    BL _fabs

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf

    POP {R0, LR}
BX LR

_callFatorial:
    PUSH {R0, LR}
    LDR R1, =testNumber
    VLDR S0, [R1]

    

    BL _fatorial

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR

_callExp:
    PUSH {R0, LR}

    @Print message to user
    LDR R0, =exp_print
    BL printf

    @Read values of x
    LDR R1, =numeroExp
    LDR R0, =scanfp
    BL scanf

    @Load float to 50
    LDR R1, =numeroExp
    VLDR S0, [R1]
    

    BL _exp

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR


_callSinh:
    PUSH {R0, LR}
    
    @Print message to user
    LDR R0, =sinh_print
    BL printf

    @Read values of x
    LDR R1, =numero
    LDR R0, =scanfp
    BL scanf

    @Load float to 50
    LDR R1, =numero
    VLDR S0, [R1]

    BL _sinh

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR

_callCosh:
    PUSH {R0, LR}
    
    @Print message to user
    LDR R0, =cosh_print
    BL printf

    @Read values of x
    LDR R1, =numero
    LDR R0, =scanfp
    BL scanf

    @Load float to 50
    LDR R1, =numero
    VLDR S0, [R1]

    BL _cosh

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR

//---------------------------------------------------------------------------------------------

//METHODS

//---------------------------------------------------------------------------------------------

/*  Sqrt

    Parametros:
    
*/
_sqrt:
    PUSH {LR}
    LDR R0, =val1
    VLDR S1, [R0] @ K value

    LDR R0, =val2
    VLDR S3, [R0] @ 1/2

    LDR R0, =limit
    VLDR S5, [R0] @ limit

    _sqrt_loop:
        VDIV.F32 S2, S0, S1 @ x/y_k
        VADD.F32 S2, S2, S1 @ y_k + x/y_k
        VMUL.F32 S2, S2, S3 @ 1/2 * y_k + x/y_k

        VSUB.F32 S4, S2, S1 @ y_k - y_k+1
        VABS.F32 S4, S4
        VMOV.F32 S1, S2

        VCMP.F32 S4, S5 
        VMRS APSR_nzcv, FPSCR
    BGT _sqrt_loop

    VMOV.F32 S0, S2
    POP {LR}
BX LR


_fabs:
    PUSH {LR}
    VPUSH {S1-S5}
    LDR R0, =zero
    VLDR S1, [R0] @ K value

    VCMP.F32 S0, S1
    VMRS APSR_nzcv, FPSCR
    VPOP {S1-S5}
    POP {LR}
    BXGE LR
    PUSH {LR}
    VPUSH {S1-S5}
    VNEG.F32 S0, S0
    VPOP {S1-S5}
    POP {LR}
BX LR



_fatorial:
    PUSH {LR}
    VPUSH.F32 {S1-S5}

        

    LDR  R0, =zero
    VLDR S1, [R0]                  @ S1 começa em 0 mas incrementa.
    VLDR S4, [R0]                  @ S4 é uma constante de 0.
    LDR  R0, =one
    VLDR S2, [R0]                  @ S2 é uma constante de 1.

    VCMP.F32 S0, S1
    VMRS APSR_nzcv, FPSCR
    VMOVEQ.F32 S0, S2
    @Comparar com 1
    VCMP.F32 S0, S2
    VMRS APSR_nzcv, FPSCR
    VMOVEQ.F32 S0, S2

    factorial_loop:
        VMOV.F32 S3, S1              @ S3 = i
        VMOV.F32 S5, S3              @ Criar cópia de S3 para S5. S5 é out.
        VSUB.F32 S3, S2              @ S3 -= 1.0
        factorial_loop_2:
            VMUL.F32 S5, S3            @ S5 *= S3
            VSUB.F32 S3, S2            @ S3 -= 1.0 (decrementa, i--)
            VCMP.F32 S3, S4            @ S3 > 0
            VMRS     APSR_nzcv, FPSCR
        BGT      factorial_loop_2
        VCMP.F32 S1, S0              @ i < range 
        VADD.F32 S1, S2              @ S1 += 1.0
        VMRS     APSR_nzcv, FPSCR
    BLT      factorial_loop
        VCMP.F32 S0, S2
        VMRS APSR_nzcv, FPSCR
        VMOVNE.F32 S0, S5
        VPOP.F32 {S1-S5}
        POP {LR}
BX   LR







_exp:
    PUSH {LR}
    VPUSH.F32 {S1-S13}
    LDR R1, =one
    VLDR S1, [R1]

    LDR R1, =zero
    VLDR S11, [R1]

    LDR R1, =two
    VLDR S12, [R1]

    LDR R1, =limit
    VLDR S8, [R1]

    @S0 - x
    @VADD.F32 S3, S0, S1 @S3 - 1 + x
    @S4 - X
    
    VMOV.F32 S4, S0
  
    LDR R1, =zero
    VLDR S9, [R1]
    
    exp_loop:
        VCMP.F32   S9, S11
        VMRS       APSR_nzcv, FPSCR
        VADDEQ.F32 S3, S1
        VADDEQ.F32 S9, S1
        BEQ        exp_loop

        VCMP.F32   S9, S1
        VMRS       APSR_nzcv, FPSCR
        VADDEQ.F32 S3, S4
        VADDEQ.F32 S9, S1
        BEQ        exp_loop

        @Params - R0, S0
        @BL _powInt2
        VMOV.F32 S10, S11
        VMOV.F32 S5, S1
        exp_pow_loop:
            VMUL.F32 S5, S4

            VSUB.F32 S13, S9, S1
            
            VCMP.F32 S10, S13
            VMRS     APSR_nzcv, FPSCR
            VADD.F32 S10, S1
            BLT      exp_pow_loop

        LDR R1, =one
        VLDR S1, [R1]

        VMOV.F32 S0, S9  @ S0 = i, i!
        BL _fatorial

        VMOV.F32 S6, S0@FATORIAL
        VDIV.F32 S7, S5, S6

        VADD.F32 S3, S7 @ out
    
        VADD.F32 S9, S1
        VCMP.F32 S7, S8
        VMRS APSR_nzcv, FPSCR


    BGE exp_loop

    VMOV.F32 S0, S3
    VPOP.F32 {S1-S13}
    POP {LR}
BX LR



/*
    (1 - E^-2X ) / 2E^-X
 */
_sinh:
    PUSH {LR}
    VPUSH.F32 {S1-S3}
    LDR R1, =one
    VLDR S1, [R1]

    LDR R1, =zero
    VLDR S2, [R1]

    VMOV.F32 S5, S0@x

    @E^-2X
    /////////////////////////////////////////
    LDR R1, =two
    VLDR S4, [R1]
    VMUL.F32 S0, S5, S4
    //VNEG.F32 S0, S0
    BL _exp
    VDIV.F32 S6, S1, S0
    /////////////////////////////////////////

    VSUB.F32 S7, S1, S6


    @2E^-X
    /////////////////////////////////////////
    //VMUL.F32 S0, S5, S4
    //VNEG.F32 S0, S0
    VMOV.F32 S0, S5
    BL _exp
    VDIV.F32 S8, S1, S0
    VMUL.F32 S8, S8, S4
    /////////////////////////////////////////


    VDIV.F32 S0, S7, S8

    //VMOV.F32 S0, S7


    //VNEG.F32 S0, S0

    VPOP.F32 {S1-S3}
    POP {LR}
BX LR

_cosh:
    PUSH {LR}
    VPUSH.F32 {S1-S3}
    LDR R1, =one
    VLDR S1, [R1]

    LDR R1, =zero
    VLDR S2, [R1]

    VMOV.F32 S5, S0@x

    @E^-2X
    /////////////////////////////////////////
    LDR R1, =two
    VLDR S4, [R1]
    VMUL.F32 S0, S5, S4
    //VNEG.F32 S0, S0
    BL _exp
    VDIV.F32 S6, S1, S0
    /////////////////////////////////////////

    VADD.F32 S7, S1, S6


    @2E^-X
    /////////////////////////////////////////
    //VMUL.F32 S0, S5, S4
    //VNEG.F32 S0, S0
    VMOV.F32 S0, S5
    BL _exp
    VDIV.F32 S8, S1, S0
    VMUL.F32 S8, S8, S4
    /////////////////////////////////////////


    VDIV.F32 S0, S7, S8

    //VMOV.F32 S0, S7


    //VNEG.F32 S0, S0

    VPOP.F32 {S1-S3}
    POP {LR}
BX LR
