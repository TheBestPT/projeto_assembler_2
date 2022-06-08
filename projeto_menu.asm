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
    mainMenu: .asciz "Menu\n1 - sqrt\n2 - fabs\n\nEscolha uma opção: "
.align 4
    zero: .single 0.0
.align 4
    one: .single 1.0
.align 4
    dois: .single 2.0
/*
SQRT VARIABLES
 */
.align 4
    val1: .single 1.0 @y0
    val2: .single 0.5 @1/2
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
    BLEQ _callPowInt

    CMP R0, #5
    BLEQ _callExp

    



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

_callPowInt:
    PUSH {R0, LR}
    LDR R1, =testNumber
    VLDR S0, [R1]
    //MOV R0, #2
    LDR R1, =dois
    VLDR S1, [R1]
    

    BL _powInt2

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR

_callExp:
    PUSH {R0, LR}
    LDR R1, =testNumber
    VLDR S0, [R1]
    //MOV R0, #2
    

    BL _exp

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

/*
    powInt expoentes inteiros
    Parametros
    R0 - expoente
    S0 - base
    Retrun
    S0 - resultado
 */
 
_powInt:
    PUSH {LR}
    LDR  R2, =one
    VLDR S1, [R2]

    MOV R1, #0
    CMP R0, #0
    /*VMRS APSR_nzcv, FPSCR
    VMOVEQ.F32 S0, S1
    POP {R0, R1, LR}
    BXEQ LR
    PUSH {R0, R1, LR}*/
    CMP R0, #2
    SUBGe R0, #1
    /*CMP R0, #0
    VMRS     APSR_nzcv, FPSCR
    VMOVEQ.F32 S0, S1
    POP {LR}
    BXEQ LR*/
    PUSH {LR}
    VMOV.F32 S3, S0
    powInt_loop:
        VMUL.F32 S3, S3, S0
        ADD R1, #1                
        CMP R1, R0 
    BNE powInt_loop
    VMOV.F32 S0, S3
    POP {LR}
BX LR


/*
    powInt expoentes inteiros
    Parametros
    S1 - expoente
    S0 - base
    Retrun
    S0 - resultado
 */
_powInt2:
    PUSH {LR}
    LDR  R2, =one
    VLDR S2, [R2]
    LDR R2, =zero
    VLDR S4, [R2]
    //MOV R1, #0
    /*CMP R0, #0
    CMP R0, #2
    SUBGE R0, #1*/
    @VERIFY IF ITS 1
    VCMP.F32 S1, S2
    VMRS APSR_nzcv, FPSCR
    POP {LR}
    BXEQ LR
    @VERIFY IF IS 0
    PUSH {LR}
    VCMP.F32 S1, S4
    VMRS APSR_nzcv, FPSCR
    VMOVEQ.F32 S0, S2
    POP {LR}
    BXEQ LR
    PUSH {LR}
    VSUB.F32 S1, S2
    VMOV.F32 S3, S0
    powInt2_loop:
        VMUL.F32 S3, S3, S0
        //ADD R1, #1                
        VADD.F32 S4, S2
        //CMP R1, R0 
        VCMP.F32 S4, S1
        VMRS APSR_nzcv, FPSCR
    BNE powInt2_loop
    VMOV.F32 S0, S3
    POP {LR}
BX LR







_exp:
    PUSH {LR}
    LDR R1, =one
    VLDR S1, [R1]

    LDR R1, =limit
    VLDR S8, [R1]

    @S0 - x
    VADD.F32 S3, S0, S1 @S3 - 1 + x
    @S4 - X
    
    VMOV.F32 S4, S0
    //MOV R4, #1 @Iterador
    VMOV.F32 S9, S0

    
    /*LDR R1, =dois
    VLDR S1, [R1]
    //CMP R0, #1
    @Params - S0, S1
    BL _powInt2*/
    @S1 - 1
    
    
    exp_loop:
        //MOV R0, R4
        //CMP R0, #1
        VMOV.F32 S1, S9
        @Params - R0, S0
        BLNE _powInt2
        LDR R1, =one
        VLDR S1, [R1]
        @Return S0
        VMOV.F32 S5, S0 @pow
        VMOV.F32 S0, S4
        BL _fatorial
        VMOV.F32 S6, S0@FATORIAL
        VDIV.F32 S7, S5, S6
        VADD.F32 S3, S7
        //ADD R4, #1
        VADD.F32 S9, S1
        VCMP.F32 S7, S8
        VMRS APSR_nzcv, FPSCR
    BGT exp_loop
    VMOV.F32 S0, S6


    POP {LR}
BX LR

