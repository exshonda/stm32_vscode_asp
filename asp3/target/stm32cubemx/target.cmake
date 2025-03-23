
set(ARCHDIR ${PROJECT_SOURCE_DIR}/arch/arm_m_gcc)
set(TARGETDIR ${PROJECT_SOURCE_DIR}/target/stm32cubemx)

list(APPEND ASP3_CFG_FILES
    ${TARGETDIR}/target_kernel.cfg
)

list(APPEND ASP3_KERNEL_CFG_TRB_FILES
    ${TARGETDIR}/target_kernel.trb
)

list(APPEND ASP3_CHECK_TRB_FILES
    ${TARGETDIR}/target_check.trb
)

list(APPEND ASP3_INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}/Core/Inc
    ${CMAKE_SOURCE_DIR}/Drivers/STM32H5xx_HAL_Driver/Inc
    ${CMAKE_SOURCE_DIR}/Drivers/STM32H5xx_HAL_Driver/Inc/Legacy
    ${CMAKE_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32H5xx/Include
    ${CMAKE_SOURCE_DIR}/Drivers/CMSIS/Include
    ${TARGETDIR}
)

list(APPEND ASP3_COMPILE_DEFS
    USE_FULL_LL_DRIVER 
    USE_NUCLEO_64 
    USE_HAL_DRIVER
    STM32H563xx
    $<$<CONFIG:Debug>:DEBUG>
    USE_TIM_AS_HRT
    TOPPERS_FPU_ENABLE
    TOPPERS_FPU_LAZYSTACKING
    TOPPERS_FPU_CONTEXT
)

list(APPEND ASP3_TARGET_C_FILES
    ${TARGETDIR}/target_kernel_impl.c
    ${TARGETDIR}/target_timer.c
    ${TARGETDIR}/target_serial.c
)

include(${ARCHDIR}/stm32h5xx_stm32cube/arch.cmake)
