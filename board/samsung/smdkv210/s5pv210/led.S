/*
 * 2016/07/10
 * function:
 	1.led1_on  (led1 on)
	2.led1_off (led1 off)
*/

#include <asm-offsets.h>
#include <config.h>
#include <asm/system.h>
#include <linux/linkage.h>

ENTRY(led1_on)
#GPC0CON_3 0xE020_0060
ldr r11, =0xE0200060
ldr r12, =0x00001000
str r12,  [r11]
#GPC0DAT_3 0xE0200064
ldr r11, =0xE0200064
ldr r12, =0x00000008
str r12, [r11]
mov pc, lr
ENDPROC(led1_on)

ENTRY(led1_off)
#GPC0CON_3 0xE020_0060
ldr r11, =0xE0200060
ldr r12, =0x00001000
str r12,  [r11]
#GPC0DAT_3 0xE0200064
ldr r11, =0xE0200064
ldr r12, =0x00000000
str r12, [r11]
mov pc, lr
ENDPROC(led1_off)