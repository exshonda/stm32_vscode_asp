/**
  ******************************************************************************
  * @file      startup_stm32h563xx.s
  * @author    MCD Application Team
  * @brief     STM32H563xx devices vector table GCC toolchain.
  *            This module performs:
  *                - Set the initial SP
  *                - Set the initial PC == Reset_Handler,
  *                - Set the vector table entries with the exceptions ISR address,
  *                - Configure the clock system
  *                - Branches to main in the C library (which eventually
  *                  calls main()).
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2023 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */

  .syntax unified
	.cpu cortex-m33
	.fpu softvfp
	.thumb

.global g_pfnVectors
.global _kernel_default_ext_handler
.global _kernel_default_int_handler

/* start address for the initialization values of the .data section.
defined in linker script */
.word _sidata
/* start address for the .data section. defined in linker script */
.word _sdata
/* end address for the .data section. defined in linker script */
.word _edata
/* start address for the .bss section. defined in linker script */
.word _sbss
/* end address for the .bss section. defined in linker script */
.word _ebss

/**
  * @brief  This is the code that gets called when the processor first
  *          starts execution following a reset event. Only the absolutely
  *          necessary set is performed, after which the application
  *          supplied main() routine is called.
  * @param  None
  * @retval : None
  */

    .section	.text.Reset_Handler
	.weak	Reset_Handler
	.type	Reset_Handler, %function
Reset_Handler:
  ldr   r0, =_estack
  mov   sp, r0          /* set stack pointer */
/* Call the clock system initialization function.*/
  bl  SystemInit

/* Copy the data segment initializers from flash to SRAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_sidata
  movs r3, #0
  b LoopCopyDataInit

CopyDataInit:
  ldr r4, [r2, r3]
  str r4, [r0, r3]
  adds r3, r3, #4

LoopCopyDataInit:
  adds r4, r0, r3
  cmp r4, r1
  bcc CopyDataInit

/* Zero fill the bss segment. */
  ldr r2, =_sbss
  ldr r4, =_ebss
  movs r3, #0
  b LoopFillZerobss

FillZerobss:
  str  r3, [r2]
  adds r2, r2, #4

LoopFillZerobss:
  cmp r2, r4
  bcc FillZerobss

/* Call static constructors */
  bl __libc_init_array
/* Call the application's entry point.*/
  bl main

LoopForever:
    b LoopForever

  .size Reset_Handler, .-Reset_Handler

/**
 * @brief  This is the code that gets called when the processor receives an
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 *
 * @param  None
 * @retval : None
*/
  .section .text.Default_Handler,"ax",%progbits
Default_Handler:
Infinite_Loop:
  b Infinite_Loop
  .size Default_Handler, .-Default_Handler

/******************************************************************************
*
* The STM32H563xx vector table.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
******************************************************************************/
  .section .isr_vector,"a",%progbits
  .type g_pfnVectors, %object

g_pfnVectors:
	.word	_estack
	.word	Reset_Handler
	.word	NMI_Handler
	.word	HardFault_Handler
	.word	MemManage_Handler
	.word	BusFault_Handler
	.word	cpuexc_handler
	.word	SecureFault_Handler
	.word	0
	.word	0
	.word	0
	.word	SVC_Handler
	.word	DebugMon_Handler
	.word	0
	.word	PendSV_Handler
	.word	target_systick_handler
	.word	WWDG_IRQHandler
	.word	PVD_AVD_IRQHandler
	.word	RTC_IRQHandler
	.word	RTC_S_IRQHandler
	.word	TAMP_IRQHandler
	.word	RAMCFG_IRQHandler
	.word	FLASH_IRQHandler
	.word	FLASH_S_IRQHandler
	.word	GTZC_IRQHandler
	.word	RCC_IRQHandler
	.word	RCC_S_IRQHandler
	.word	EXTI0_IRQHandler
	.word	EXTI1_IRQHandler
	.word	EXTI2_IRQHandler
	.word	EXTI3_IRQHandler
	.word	EXTI4_IRQHandler
	.word	EXTI5_IRQHandler
	.word	EXTI6_IRQHandler
	.word	EXTI7_IRQHandler
	.word	EXTI8_IRQHandler
	.word	EXTI9_IRQHandler
	.word	EXTI10_IRQHandler
	.word	EXTI11_IRQHandler
	.word	EXTI12_IRQHandler
	.word	EXTI13_IRQHandler
	.word	EXTI14_IRQHandler
	.word	EXTI15_IRQHandler
	.word	GPDMA1_Channel0_IRQHandler
	.word	GPDMA1_Channel1_IRQHandler
	.word	GPDMA1_Channel2_IRQHandler
	.word	GPDMA1_Channel3_IRQHandler
	.word	GPDMA1_Channel4_IRQHandler
	.word	GPDMA1_Channel5_IRQHandler
	.word	GPDMA1_Channel6_IRQHandler
	.word	GPDMA1_Channel7_IRQHandler
	.word	IWDG_IRQHandler
	.word	0
	.word	ADC1_IRQHandler
	.word	DAC1_IRQHandler
	.word	FDCAN1_IT0_IRQHandler
	.word	FDCAN1_IT1_IRQHandler
	.word	TIM1_BRK_IRQHandler
	.word	TIM1_UP_IRQHandler
	.word	TIM1_TRG_COM_IRQHandler
	.word	TIM1_CC_IRQHandler
	.word	TIM2_IRQHandler
	.word	TIM3_IRQHandler
	.word	TIM4_IRQHandler
	.word	target_hrt_handler
	.word	TIM6_IRQHandler
	.word	TIM7_IRQHandler
	.word	I2C1_EV_IRQHandler
	.word	I2C1_ER_IRQHandler
	.word	I2C2_EV_IRQHandler
	.word	I2C2_ER_IRQHandler
	.word	SPI1_IRQHandler
	.word	SPI2_IRQHandler
	.word	SPI3_IRQHandler
	.word	USART1_IRQHandler
	.word	USART2_IRQHandler
	.word	USART3_IRQHandler
	.word	UART4_IRQHandler
	.word	UART5_IRQHandler
	.word	LPUART1_IRQHandler
	.word	LPTIM1_IRQHandler
    .word	TIM8_BRK_IRQHandler
    .word	TIM8_UP_IRQHandler
    .word	TIM8_TRG_COM_IRQHandler
    .word	TIM8_CC_IRQHandler
    .word	ADC2_IRQHandler
	.word	LPTIM2_IRQHandler
	.word	TIM15_IRQHandler
	.word	TIM16_IRQHandler
	.word	TIM17_IRQHandler
	.word	USB_DRD_FS_IRQHandler
	.word	CRS_IRQHandler
	.word	UCPD1_IRQHandler
	.word	FMC_IRQHandler
	.word	OCTOSPI1_IRQHandler
	.word	SDMMC1_IRQHandler
	.word	I2C3_EV_IRQHandler
	.word	I2C3_ER_IRQHandler
	.word	SPI4_IRQHandler
	.word	SPI5_IRQHandler
	.word	SPI6_IRQHandler
	.word	USART6_IRQHandler
	.word	USART10_IRQHandler
	.word	USART11_IRQHandler
	.word	SAI1_IRQHandler
	.word	SAI2_IRQHandler
	.word	GPDMA2_Channel0_IRQHandler
	.word	GPDMA2_Channel1_IRQHandler
	.word	GPDMA2_Channel2_IRQHandler
	.word	GPDMA2_Channel3_IRQHandler
	.word	GPDMA2_Channel4_IRQHandler
	.word	GPDMA2_Channel5_IRQHandler
	.word	GPDMA2_Channel6_IRQHandler
	.word	GPDMA2_Channel7_IRQHandler
	.word	UART7_IRQHandler
	.word	UART8_IRQHandler
	.word	UART9_IRQHandler
	.word	UART12_IRQHandler
	.word	SDMMC2_IRQHandler
	.word	FPU_IRQHandler
	.word	ICACHE_IRQHandler
	.word	DCACHE1_IRQHandler
	.word	ETH_IRQHandler
	.word	ETH_WKUP_IRQHandler
	.word	DCMI_PSSI_IRQHandler
	.word	FDCAN2_IT0_IRQHandler
	.word	FDCAN2_IT1_IRQHandler
	.word	CORDIC_IRQHandler
 	.word   FMAC_IRQHandler
	.word	DTS_IRQHandler
	.word	RNG_IRQHandler
	.word	0
	.word	0
	.word	HASH_IRQHandler
	.word	0
	.word	CEC_IRQHandler
	.word	TIM12_IRQHandler
	.word	TIM13_IRQHandler
	.word	TIM14_IRQHandler
	.word	I3C1_EV_IRQHandler
	.word	I3C1_ER_IRQHandler
	.word	I2C4_EV_IRQHandler
	.word	I2C4_ER_IRQHandler
	.word	LPTIM3_IRQHandler
	.word	LPTIM4_IRQHandler
	.word	LPTIM5_IRQHandler
	.word	LPTIM6_IRQHandler

  .size g_pfnVectors, .-g_pfnVectors

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler.
* As they are weak aliases, any function with the same name will override
* this definition.
*
*******************************************************************************/

	.weak	NMI_Handler
	.thumb_set NMI_Handler,_kernel_default_exc_handler

	.weak	HardFault_Handler
	.thumb_set HardFault_Handler,_kernel_default_exc_handler

	.weak	MemManage_Handler
	.thumb_set MemManage_Handler,_kernel_default_exc_handler

	.weak	BusFault_Handler
	.thumb_set BusFault_Handler,_kernel_default_exc_handler

	.weak	UsageFault_Handler
	.thumb_set UsageFault_Handler,_kernel_default_exc_handler

	.weak	SecureFault_Handler
	.thumb_set SecureFault_Handler,_kernel_default_exc_handler

	.weak	SVC_Handler
	.thumb_set SVC_Handler,_kernel_default_exc_handler

	.weak	DebugMon_Handler
	.thumb_set DebugMon_Handler,_kernel_default_exc_handler

	.weak	PendSV_Handler
	.thumb_set PendSV_Handler,_kernel_default_exc_handler

	.weak	SysTick_Handler
	.thumb_set SysTick_Handler,_kernel_default_int_handler

	.weak	WWDG_IRQHandler
	.thumb_set WWDG_IRQHandler,_kernel_default_int_handler

	.weak	PVD_AVD_IRQHandler
	.thumb_set PVD_AVD_IRQHandler,_kernel_default_int_handler

	.weak	RTC_IRQHandler
	.thumb_set RTC_IRQHandler,_kernel_default_int_handler

	.weak	RTC_S_IRQHandler
	.thumb_set RTC_S_IRQHandler,_kernel_default_int_handler

	.weak	TAMP_IRQHandler
	.thumb_set TAMP_IRQHandler,_kernel_default_int_handler

	.weak	RAMCFG_IRQHandler
	.thumb_set RAMCFG_IRQHandler,_kernel_default_int_handler

	.weak	FLASH_IRQHandler
	.thumb_set FLASH_IRQHandler,_kernel_default_int_handler

	.weak	FLASH_S_IRQHandler
	.thumb_set FLASH_S_IRQHandler,_kernel_default_int_handler

	.weak	GTZC_IRQHandler
	.thumb_set GTZC_IRQHandler,_kernel_default_int_handler

	.weak	RCC_IRQHandler
	.thumb_set RCC_IRQHandler,_kernel_default_int_handler

	.weak	RCC_S_IRQHandler
	.thumb_set RCC_S_IRQHandler,_kernel_default_int_handler

	.weak	EXTI0_IRQHandler
	.thumb_set EXTI0_IRQHandler,_kernel_default_int_handler

	.weak	EXTI1_IRQHandler
	.thumb_set EXTI1_IRQHandler,_kernel_default_int_handler

	.weak	EXTI2_IRQHandler
	.thumb_set EXTI2_IRQHandler,_kernel_default_int_handler

	.weak	EXTI3_IRQHandler
	.thumb_set EXTI3_IRQHandler,_kernel_default_int_handler

	.weak	EXTI4_IRQHandler
	.thumb_set EXTI4_IRQHandler,_kernel_default_int_handler

	.weak	EXTI5_IRQHandler
	.thumb_set EXTI5_IRQHandler,_kernel_default_int_handler

	.weak	EXTI6_IRQHandler
	.thumb_set EXTI6_IRQHandler,_kernel_default_int_handler

	.weak	EXTI7_IRQHandler
	.thumb_set EXTI7_IRQHandler,_kernel_default_int_handler

	.weak	EXTI8_IRQHandler
	.thumb_set EXTI8_IRQHandler,_kernel_default_int_handler

	.weak	EXTI9_IRQHandler
	.thumb_set EXTI9_IRQHandler,_kernel_default_int_handler

	.weak	EXTI10_IRQHandler
	.thumb_set EXTI10_IRQHandler,_kernel_default_int_handler

	.weak	EXTI11_IRQHandler
	.thumb_set EXTI11_IRQHandler,_kernel_default_int_handler

	.weak	EXTI12_IRQHandler
	.thumb_set EXTI12_IRQHandler,_kernel_default_int_handler

	.weak	EXTI13_IRQHandler
	.thumb_set EXTI13_IRQHandler,_kernel_default_int_handler

	.weak	EXTI14_IRQHandler
	.thumb_set EXTI14_IRQHandler,_kernel_default_int_handler

	.weak	EXTI15_IRQHandler
	.thumb_set EXTI15_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA1_Channel0_IRQHandler
	.thumb_set GPDMA1_Channel0_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA1_Channel1_IRQHandler
	.thumb_set GPDMA1_Channel1_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA1_Channel2_IRQHandler
	.thumb_set GPDMA1_Channel2_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA1_Channel3_IRQHandler
	.thumb_set GPDMA1_Channel3_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA1_Channel4_IRQHandler
	.thumb_set GPDMA1_Channel4_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA1_Channel5_IRQHandler
	.thumb_set GPDMA1_Channel5_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA1_Channel6_IRQHandler
	.thumb_set GPDMA1_Channel6_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA1_Channel7_IRQHandler
	.thumb_set GPDMA1_Channel7_IRQHandler,_kernel_default_int_handler

	.weak	IWDG_IRQHandler
	.thumb_set IWDG_IRQHandler,_kernel_default_int_handler

	.weak	ADC1_IRQHandler
	.thumb_set ADC1_IRQHandler,_kernel_default_int_handler

	.weak	DAC1_IRQHandler
	.thumb_set DAC1_IRQHandler,_kernel_default_int_handler

	.weak	FDCAN1_IT0_IRQHandler
	.thumb_set FDCAN1_IT0_IRQHandler,_kernel_default_int_handler

	.weak	FDCAN1_IT1_IRQHandler
	.thumb_set FDCAN1_IT1_IRQHandler,_kernel_default_int_handler

	.weak	TIM1_BRK_IRQHandler
	.thumb_set TIM1_BRK_IRQHandler,_kernel_default_int_handler

	.weak	TIM1_UP_IRQHandler
	.thumb_set TIM1_UP_IRQHandler,_kernel_default_int_handler

	.weak	TIM1_TRG_COM_IRQHandler
	.thumb_set TIM1_TRG_COM_IRQHandler,_kernel_default_int_handler

	.weak	TIM1_CC_IRQHandler
	.thumb_set TIM1_CC_IRQHandler,_kernel_default_int_handler

	.weak	TIM2_IRQHandler
	.thumb_set TIM2_IRQHandler,_kernel_default_int_handler

	.weak	TIM3_IRQHandler
	.thumb_set TIM3_IRQHandler,_kernel_default_int_handler

	.weak	TIM4_IRQHandler
	.thumb_set TIM4_IRQHandler,_kernel_default_int_handler

	.weak	TIM5_IRQHandler
	.thumb_set TIM5_IRQHandler,_kernel_default_int_handler

	.weak	TIM6_IRQHandler
	.thumb_set TIM6_IRQHandler,_kernel_default_int_handler

	.weak	TIM7_IRQHandler
	.thumb_set TIM7_IRQHandler,_kernel_default_int_handler

	.weak	I2C1_EV_IRQHandler
	.thumb_set I2C1_EV_IRQHandler,_kernel_default_int_handler

	.weak	I2C1_ER_IRQHandler
	.thumb_set I2C1_ER_IRQHandler,_kernel_default_int_handler

	.weak	I2C2_EV_IRQHandler
	.thumb_set I2C2_EV_IRQHandler,_kernel_default_int_handler

	.weak	I2C2_ER_IRQHandler
	.thumb_set I2C2_ER_IRQHandler,_kernel_default_int_handler

	.weak	SPI1_IRQHandler
	.thumb_set SPI1_IRQHandler,_kernel_default_int_handler

	.weak	SPI2_IRQHandler
	.thumb_set SPI2_IRQHandler,_kernel_default_int_handler

	.weak	SPI3_IRQHandler
	.thumb_set SPI3_IRQHandler,_kernel_default_int_handler

	.weak	USART1_IRQHandler
	.thumb_set USART1_IRQHandler,_kernel_default_int_handler

	.weak	USART2_IRQHandler
	.thumb_set USART2_IRQHandler,_kernel_default_int_handler

	.weak	USART3_IRQHandler
	.thumb_set USART3_IRQHandler,_kernel_default_int_handler

	.weak	UART4_IRQHandler
	.thumb_set UART4_IRQHandler,_kernel_default_int_handler

	.weak	UART5_IRQHandler
	.thumb_set UART5_IRQHandler,_kernel_default_int_handler

	.weak	LPUART1_IRQHandler
	.thumb_set LPUART1_IRQHandler,_kernel_default_int_handler

	.weak	LPTIM1_IRQHandler
	.thumb_set LPTIM1_IRQHandler,_kernel_default_int_handler

	.weak	TIM8_BRK_IRQHandler
	.thumb_set TIM8_BRK_IRQHandler,_kernel_default_int_handler

	.weak	TIM8_UP_IRQHandler
	.thumb_set TIM8_UP_IRQHandler,_kernel_default_int_handler

	.weak	TIM8_TRG_COM_IRQHandler
	.thumb_set TIM8_TRG_COM_IRQHandler,_kernel_default_int_handler

	.weak	TIM8_CC_IRQHandler
	.thumb_set TIM8_CC_IRQHandler,_kernel_default_int_handler

	.weak	ADC2_IRQHandler
	.thumb_set ADC2_IRQHandler,_kernel_default_int_handler

	.weak	LPTIM2_IRQHandler
	.thumb_set LPTIM2_IRQHandler,_kernel_default_int_handler

	.weak	TIM15_IRQHandler
	.thumb_set TIM15_IRQHandler,_kernel_default_int_handler

	.weak	TIM16_IRQHandler
	.thumb_set TIM16_IRQHandler,_kernel_default_int_handler

	.weak	TIM17_IRQHandler
	.thumb_set TIM17_IRQHandler,_kernel_default_int_handler

	.weak	USB_DRD_FS_IRQHandler
	.thumb_set USB_DRD_FS_IRQHandler,_kernel_default_int_handler

	.weak	CRS_IRQHandler
	.thumb_set CRS_IRQHandler,_kernel_default_int_handler

	.weak	UCPD1_IRQHandler
	.thumb_set UCPD1_IRQHandler,_kernel_default_int_handler

	.weak	FMC_IRQHandler
	.thumb_set FMC_IRQHandler,_kernel_default_int_handler

	.weak	OCTOSPI1_IRQHandler
	.thumb_set OCTOSPI1_IRQHandler,_kernel_default_int_handler

	.weak	SDMMC1_IRQHandler
	.thumb_set SDMMC1_IRQHandler,_kernel_default_int_handler

	.weak	I2C3_EV_IRQHandler
	.thumb_set I2C3_EV_IRQHandler,_kernel_default_int_handler

	.weak	I2C3_ER_IRQHandler
	.thumb_set I2C3_ER_IRQHandler,_kernel_default_int_handler

	.weak	SPI4_IRQHandler
	.thumb_set SPI4_IRQHandler,_kernel_default_int_handler

	.weak	SPI5_IRQHandler
	.thumb_set SPI5_IRQHandler,_kernel_default_int_handler

	.weak	SPI6_IRQHandler
	.thumb_set SPI6_IRQHandler,_kernel_default_int_handler

	.weak	USART6_IRQHandler
	.thumb_set USART6_IRQHandler,_kernel_default_int_handler

	.weak	USART10_IRQHandler
	.thumb_set USART10_IRQHandler,_kernel_default_int_handler

	.weak	USART11_IRQHandler
	.thumb_set USART11_IRQHandler,_kernel_default_int_handler

	.weak	SAI1_IRQHandler
	.thumb_set SAI1_IRQHandler,_kernel_default_int_handler

	.weak	SAI2_IRQHandler
	.thumb_set SAI2_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA2_Channel0_IRQHandler
	.thumb_set GPDMA2_Channel0_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA2_Channel1_IRQHandler
	.thumb_set GPDMA2_Channel1_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA2_Channel2_IRQHandler
	.thumb_set GPDMA2_Channel2_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA2_Channel3_IRQHandler
	.thumb_set GPDMA2_Channel3_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA2_Channel4_IRQHandler
	.thumb_set GPDMA2_Channel4_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA2_Channel5_IRQHandler
	.thumb_set GPDMA2_Channel5_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA2_Channel6_IRQHandler
	.thumb_set GPDMA2_Channel6_IRQHandler,_kernel_default_int_handler

	.weak	GPDMA2_Channel7_IRQHandler
	.thumb_set GPDMA2_Channel7_IRQHandler,_kernel_default_int_handler

	.weak	UART7_IRQHandler
	.thumb_set UART7_IRQHandler,_kernel_default_int_handler

	.weak	UART8_IRQHandler
	.thumb_set UART8_IRQHandler,_kernel_default_int_handler

	.weak	UART9_IRQHandler
	.thumb_set UART9_IRQHandler,_kernel_default_int_handler

	.weak	UART12_IRQHandler
	.thumb_set UART12_IRQHandler,_kernel_default_int_handler

	.weak	SDMMC2_IRQHandler
	.thumb_set SDMMC2_IRQHandler,_kernel_default_int_handler

	.weak	FPU_IRQHandler
	.thumb_set FPU_IRQHandler,_kernel_default_int_handler

	.weak	ICACHE_IRQHandler
	.thumb_set ICACHE_IRQHandler,_kernel_default_int_handler

	.weak	DCACHE1_IRQHandler
	.thumb_set DCACHE1_IRQHandler,_kernel_default_int_handler

	.weak	ETH_IRQHandler
	.thumb_set ETH_IRQHandler,_kernel_default_int_handler

	.weak	ETH_WKUP_IRQHandler
	.thumb_set ETH_WKUP_IRQHandler,_kernel_default_int_handler

	.weak	DCMI_PSSI_IRQHandler
	.thumb_set DCMI_PSSI_IRQHandler,_kernel_default_int_handler

	.weak	FDCAN2_IT0_IRQHandler
	.thumb_set FDCAN2_IT0_IRQHandler,_kernel_default_int_handler

	.weak	FDCAN2_IT1_IRQHandler
	.thumb_set FDCAN2_IT1_IRQHandler,_kernel_default_int_handler

	.weak	CORDIC_IRQHandler
	.thumb_set CORDIC_IRQHandler,_kernel_default_int_handler

	.weak	FMAC_IRQHandler
	.thumb_set FMAC_IRQHandler,_kernel_default_int_handler

	.weak	DTS_IRQHandler
	.thumb_set DTS_IRQHandler,_kernel_default_int_handler

	.weak	RNG_IRQHandler
	.thumb_set RNG_IRQHandler,_kernel_default_int_handler

	.weak	HASH_IRQHandler
	.thumb_set HASH_IRQHandler,_kernel_default_int_handler

	.weak	CEC_IRQHandler
	.thumb_set CEC_IRQHandler,_kernel_default_int_handler

	.weak	TIM12_IRQHandler
	.thumb_set TIM12_IRQHandler,_kernel_default_int_handler

	.weak	TIM13_IRQHandler
	.thumb_set TIM13_IRQHandler,_kernel_default_int_handler

	.weak	TIM14_IRQHandler
	.thumb_set TIM14_IRQHandler,_kernel_default_int_handler

	.weak	I3C1_EV_IRQHandler
	.thumb_set I3C1_EV_IRQHandler,_kernel_default_int_handler

	.weak	I3C1_ER_IRQHandler
	.thumb_set I3C1_ER_IRQHandler,_kernel_default_int_handler

	.weak	I2C4_EV_IRQHandler
	.thumb_set I2C4_EV_IRQHandler,_kernel_default_int_handler

	.weak	I2C4_ER_IRQHandler
	.thumb_set I2C4_ER_IRQHandler,_kernel_default_int_handler

	.weak	LPTIM3_IRQHandler
	.thumb_set LPTIM3_IRQHandler,_kernel_default_int_handler

	.weak	LPTIM4_IRQHandler
	.thumb_set LPTIM4_IRQHandler,_kernel_default_int_handler

	.weak	LPTIM5_IRQHandler
	.thumb_set LPTIM5_IRQHandler,_kernel_default_int_handler

	.weak	LPTIM6_IRQHandler
	.thumb_set LPTIM6_IRQHandler,_kernel_default_int_handler
