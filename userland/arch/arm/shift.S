/* https://cirosantilli.com/linux-kernel-module-cheat#arm-shift-suffixes */

#include <lkmc.h>

LKMC_PROLOGUE

    /* lsr */
    ldr r0, =0xFFF00FFF
    mov r1, r0, lsl 8
    ldr r2, =0xF00FFF00
    LKMC_ASSERT_EQ_REG(r1, r2)

    /* lsl */
    ldr r0, =0xFFF00FFF
    mov r1, r0, lsr 8
    ldr r2, =0x00FFF00F
    LKMC_ASSERT_EQ_REG(r1, r2)

    /* ror */
    ldr r0, =0xFFF00FFF
    mov r1, r0, ror 8
    ldr r2, =0xFFFFF00F
    LKMC_ASSERT_EQ_REG(r1, r2)

    /* asr negative */
    ldr r0, =0x80000008
    mov r1, r0, asr 1
    ldr r2, =0xC0000004
    LKMC_ASSERT_EQ_REG(r1, r2)

    /* asr positive */
    ldr r0, =0x40000008
    mov r1, r0, asr 1
    ldr r2, =0x20000004
    LKMC_ASSERT_EQ_REG(r1, r2)

    /* There are also direct shift mnemonics for the mov shifts.
     *
     * They assembly to the exact same bytes as the mov version
     */
    ldr r0, =0xFFF00FFF
    lsl r1, r0, 8
    ldr r2, =0xF00FFF00
    LKMC_ASSERT_EQ_REG(r1, r2)

    /* If used with the `mov` instruction, it results in a pure shift,
     * but the suffixes also exist for all the other data processing instructions.
     *
     * Here we illustrate a shifted add instruction which calculates:
     *
     * ....
     * r1 = r1 + (r0 << 1)
     * ....
     */
    ldr r0, =0x10
    ldr r1, =0x100
    add r1, r1, r0, lsl 1
    ldr r2, =0x00000120
    LKMC_ASSERT_EQ_REG(r1, r2)

    /* The shift takes up the same encoding slot as the immediate,
     * therefore it is not possible to both use an immediate and shift.
     *
     * Error: shift expression expected -- `add r1,r0,1,lsl#1'
     */
#if 0
    add r1, r0, 1, lsl 1
#endif

    /* However, you can still encode shifted bitmasks of
     * limited width in immediates, so why not just use the
     * assembler pre-processing for it?
     */
    ldr r1, =0x100
    add r1, r1, (0x10 << 1)
    ldr r2, =0x00000120
    LKMC_ASSERT_EQ_REG(r1, r2)

LKMC_EPILOGUE
