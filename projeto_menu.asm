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
    mainMenu: .asciz "Menu\n1 - sqrt\n2 - fabs\n3 - fatorial\n4 - exp\n5 - sinh\n6 - cosh\n7 - tanh\n8 - hypot\n9 - powint\n10 - ldexp\n11 - ln\n12 - pow\n\nEscolha uma opção: "
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
.align 4
    numero1: .fill 3, 4, 0
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
LEXP
 */
.align 4
    ldexp_mul_print: .asciz "Insert (x) value for lexp multiplyer number(x): "
.align 4
    ldexp_expon_print: .asciz "Insert (x) value for lexp exponent(x): "
.align 4
    numeroMulLdexp: .fill 3, 4, 0
.align 4
    exponentLdexp: .fill 3, 4, 0
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

/*
TANH VARIABLES
 */

.align 4
    tanh_print: .asciz "Insert (x) value for cosh(x): "


/*
HYPOT VARIABLES
 */
.align 4
    hypotc1_print: .asciz "Insert (c1) value for hypot: "
.align 4
    hypotc2_print: .asciz "Insert (c2) value for hypot: "
.align 4
    c1_nr: .single 0.0
.align 4
    c2_nr: .single 0.0

/*
LN VARIABLES
 */

.align 4
    ln_print: .asciz "Insert (x) value for ln(x): "
.align 4
    lnlimit: .single 1000.0

/*
POW VARIABLES
 */
.align 4
    pow_base_print: .asciz "Insert (x) value for base of pow(x): "
.align 4
    pow_expon_print: .asciz "Insert (x) value for exponent of pow(y): "
.align 4
    pow_base: .fill 3, 4, 0
.align 4
    pow_exponent: .fill 3, 4, 0


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

    CMP R0, #7
    BLEQ _callTanh

    CMP R0, #8
    BLEQ _callHypot

    CMP R0, #9
    BLEQ _callPowInt

    CMP R0, #10
    BLEQ _callLdexp

    CMP R0, #11
    BLEQ _callLn

    CMP R0, #12
    BLEQ _callPow

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

_callTanh:
    PUSH {R0, LR}
    
    @Print message to user
    LDR R0, =tanh_print
    BL printf

    @Read values of x
    LDR R1, =numero
    LDR R0, =scanfp
    BL scanf

    @Load float to 50
    LDR R1, =numero
    VLDR S0, [R1]

    BL _tanh

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR

_callHypot:
    PUSH {R0, LR}

    LDR R0, =hypotc1_print
    BL printf

    LDR R1, =c1_nr
    LDR R0, =scanfp
    BL scanf

    LDR R0, =hypotc2_print
    BL printf

    LDR R1, =c2_nr
    LDR R0, =scanfp
    BL scanf

    LDR R1, =c1_nr
    VLDR S0, [R1]

    LDR R1, =c2_nr
    VLDR S1, [R1]

    BL _hypot

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
    //MOV R0, #3
    LDR R1, =two
    VLDR S1, [R1]
    

    BL _powInt2

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR


_callLdexp:
    PUSH {R0, LR}

    @Print message to user
    LDR R0, =ldexp_mul_print
    BL printf

    @Read values of x
    LDR R1, =numeroMulLdexp
    LDR R0, =scanfp
    BL scanf

    LDR R0, =ldexp_expon_print
    BL printf

    @Read values of x
    LDR R1, =exponentLdexp
    LDR R0, =scanfp
    BL scanf

    LDR R1, =numeroMulLdexp
    VLDR S0, [R1]

    LDR R1, =exponentLdexp
    VLDR S1, [R1]
    

    BL _ldexp

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR

_callLn:
    PUSH {R0, LR}
    
    @Print message to user
    LDR R0, =ln_print
    BL printf

    @Read values of x
    LDR R1, =numero
    LDR R0, =scanfp
    BL scanf

    @Load float to 50
    LDR R1, =numero
    VLDR S0, [R1]

    BL _ln

    VCVT.F64.F32 D0, S0
    VMOV R1, R2, D0
    LDR R0, =resultado
    BL printf
    POP {R0, LR}
BX LR

_callPow:
    PUSH {R0, LR}
    LDR R0, =pow_base_print
    BL printf

    LDR R1, =pow_base
    LDR R0, =scanfp
    BL scanf

    LDR R0, =pow_expon_print
    BL printf

    LDR R1, =pow_exponent
    LDR R0, =scanfp
    BL scanf

    LDR R1, =pow_base
    VLDR S0, [R1]

    LDR R1, =pow_exponent
    VLDR S1, [R1]

    BL _pow

    @BL _exp

    

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
    VPUSH.F32 {S1-S5}
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
    VPOP.F32 {S1-S5}
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


/*
    (1 - E^-2X ) / 2E^-X
 */
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


/*
    (1 - E^-2X ) / (1 + E^-2X )
 */
_tanh:
    PUSH {LR}
    VPUSH.F32 {S1-S8}
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


    @1 - E^-2X
    /////////////////////////////////////////
    //VMUL.F32 S0, S5, S4
    //VNEG.F32 S0, S0
    //VMOV.F32 S0, S5
    VMUL.F32 S0, S5, S4
    BL _exp
    VDIV.F32 S8, S1, S0
    VSUB.F32 S8, S1, S8
    //VMUL.F32 S8, S8, S4
    /////////////////////////////////////////


    VDIV.F32 S0, S7, S8

    //VMOV.F32 S0, S7


    //VNEG.F32 S0, S0

    VPOP.F32 {S1-S8}
    POP {LR}
BX LR

/*
    H^2 = C1^2 + C2^2
 */
_hypot:
    PUSH {LR}
    VPUSH.F32 {S1-S7}
    LDR R1, =one
    VLDR S2, [R1]

    LDR R1, =zero
    VLDR S3, [R1]

    LDR R1, =two
    VLDR S7, [R1]

    VMUL.F32 S4, S0, S0
    VMUL.F32 S5, S1, S1

    VADD.F32 S6, S5, S4

    VMOV.F32 S0, S6

    BL _sqrt

    //VMOV.F32 S0, S4
    VPOP.F32 {S1-S7}
    POP {LR}
BX LR









_powInt:
    PUSH {LR}
    VPUSH.F32 {S1-S3}
    LDR  R2, =one
    VLDR S1, [R2]

    MOV R1, #0
    CMP R0, #0
    BEQ end_powint_zero
    CMP R0, #1
    BEQ end_powint

    SUB R0, #1
    VMOV.F32 S3, S0
    powInt_loop:
        VMUL.F32 S3, S3, S0
        ADD R1, #1                
        CMP R1, R0 
    BNE powInt_loop
    VMOV.F32 S0, S3
    end_powint_zero:
        CMP R0, #0
        BNE end_powint
        VMOV.F32 S0, S1
        VPOP.F32 {S1-S3}
        POP {LR}
        BX LR
    end_powint:
        VPOP.F32 {S1-S3}
        POP {LR}
    BX LR


_powInt2:
    PUSH {LR}
    VPUSH.F32 {S1-S4}
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
    BEQ end_powint2
    @VERIFY IF IS 0
    VCMP.F32 S1, S4
    VMRS APSR_nzcv, FPSCR
    //VMOVEQ.F32 S0, S2
    BEQ end_powint2_zero
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
    end_powint2_zero:
        VADD.F32 S1, S2
        VCMP.F32 S1, S4
        VMRS APSR_nzcv, FPSCR
        BNE end_powint2
        VMOV.F32 S0, S1
        VPOP.F32 {S1-S4}
        POP {LR}
        BX LR

    end_powint2:
    VPOP.F32 {S1-S4}
    POP {LR}
BX LR


/*
    S0 - mul number
    S1 - exponent
 */
 
_ldexp:
    PUSH {LR}
    LDR R1, =dois
    VLDR S2, [R1]
    
    LDR R1, =one
    VLDR S3, [R1]

    LDR R1, =zero
    VLDR S4, [R1]

    @S5 - MUL NUMBER
    VMOV.F32 S5, S0
    @S6 - EXPONENT
    VMOV.F32 S6, S1

    @s0 - exponent base
    VMOV.F32 S0, S2
    VMOV.F32 S1, S6
    BL _powInt2

    VMUL.F32 S0, S5, S0

    POP {LR}
BX LR


/*
    function calculateLnx(n){
        let num, mul, cal, sum = 0;
        num = (n - 1) / (n + 1);
    
        // Terminating value of the loop
        // can be increased to improve the precision
        for(let i = 1; i <= 1000; i++)
        {
            mul = (2 * i) - 1;
            cal = Math.pow(num, mul);
            cal = cal / mul;
            sum = sum + cal;
        }
        sum = 2 * sum;
        return sum;
    }
 */
 /*
 S0 - n
  */
_ln:
    PUSH {LR}
    VPUSH.F32 {S1-S13}

    @Incrementador
    LDR R1, =one
    VLDR S4, [R1]

    @num
    LDR R1, =zero
    VLDR S5, [R1]

    @mul
    LDR R1, =zero
    VLDR S6, [R1]

    @cal
    LDR R1, =zero
    VLDR S7, [R1]

    @sum
    LDR R1, =zero
    VLDR S8, [R1]

    @limit
    LDR R1, =lnlimit
    VLDR S9, [R1]


    @two
    LDR R1, =two
    VLDR S10, [R1]

    @one
    LDR R1, =one
    VLDR S11, [R1]

    VSUB.F32 S12, S0, S11
    VADD.F32 S13, S0, S11
    VDIV.F32 S5, S12, S13

    ln_loop:
        @first step mul = (2 * i)
        VMUL.F32 S6, S4, S10
        @ mul = (2 * i) - 1
        VSUB.F32 S6, S11
        @end first setp

        @Second step Math.pow(num, mul)
        @PERSERVE N
        VMOV.F32 S2, S0

        VMOV.F32 S0, S5
        VMOV.F32 S1, S6

        BL _powInt2
        @End first

        @Third step cal = cal / mul
        VMOV.F32 S7, S0
        VDIV.F32 S7, S7, S6
        @End third

        @Fourth step sum = sum + cal
        VADD.F32 S8, S7
        @end fourth step

        VADD.F32 S4, S11
        VCMP.F32 S4, S9
        VMRS APSR_nzcv, FPSCR
    BLE ln_loop
    VMUL.F32 S8, S10
    VMOV.F32 S0, S8
    //VMOV.F32 S0, S6
    VPOP.F32 {S1-S13}
    POP {LR}
BX LR

/*_pow:
    PUSH {LR}
    VPUSH.F32 {S2-S3}

    @Peserve base
    VMOV.F32 S2, S0

    @ln
    //VMOV.F32 S0, S1 
    BL _ln


    VMUL.F32 S3, S1, S0

    VMOV.F32 S0, S3
    BL _exp
    //VMOV.F32 S0, S3
    VPOP.F32 {S2-S3}
    POP {LR}
BX LR*/


_pow:
    PUSH {LR}
    VPUSH.F32 {S1-S3}
    BL   _ln
    VPOP.F32 {S1-S3}
  

    VMUL.F32 S2, S0, S1
    VMOV.F32 S0, S2

    VPUSH.F32 {S1-S3}
    BL   _exp
    VPOP.F32 {S1-S3}
    POP  {LR}
BX LR
