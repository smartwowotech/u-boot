/*
 * uart 初始化：uart1 UART_8N1 115200
 * function：
 * 		my_uart1_asm_init
 * 		my_uart_display:   该函数用于显示 R4 的值(4Byte)
 */

#include <linux/linkage.h>
ENTRY(my_uart1_asm_init)
	#gpio_mode_init
	/*
		UART0 pin:
			GPA0_0   RSRXD0
			GPA0_1	 RSTXD0
			GPA0_2	RSCTS0
			GPA0_3	RSRTS0
	*/
	ldr r0, =0xE0200000  @ GPA0CON, Address = 0xE020_0000
	ldr r1, [r0]
	ldr r1, =0x00002222  @set uart mode
	str r1, [r0]
	
	#uart_init
	ldr r0, =0xE2900000
	ldr r1, =0x00000003
	str r1, [r0]  		@ULCON0 UART_8N1
	
	ldr r1, =0x305
	str r1, [r0,#0x4]
	
	mov r1, #1
	str r1, [r0, #0x8] 	@UFCON enable FIFO
	
	ldr r1, =0x00000022
	str r1, [r0, #0x28]    	@UBRDIV 115200
	ldr r1, =0x0000DDDD
	str r1, [r0,#0x4]
	
200:
	mov	pc, lr
ENDPROC(my_uart1_asm_init)	

delay:
	mov r9, #0
	ldr r12, =0xBEBC200 @200MHz = 0xBEBC200
delay_:
	add r9, r9, #0x1
	cmp r9, r12
	bne delay_
	mov pc, lr
	
ENTRY(my_uart1_display)
	mov r12, r4    			@get data
	ldr r0, =0xE2900020    @print
	mov r10, #28   @28bit
	@mov r4, #0
	mov r5, #0
display_:
	lsr r9, r12, r10      @r12中的值 逻辑右移 R10(第一次：移动28,第二次:移动24bit...一次只能打印1byte)
	and r9, r9, #0xf     @ascii 值4bit
	
	cmp r9, #0x9          @跟9比较，大于说明是字符
	addhi r9, r9, #0x37    @无符号 >,字符 加37
	addls r9, r9, #0x30  @无符号 <=
	str r9, [r0]			@direction print
	@add r4, r9, r4 , lsl #4  @save result
	sub r10, r10, #4
	cmp r10, #-4
	bne display_

	mov pc, lr
ENDPROC(my_uart1_display)


