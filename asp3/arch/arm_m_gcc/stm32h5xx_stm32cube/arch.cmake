
list(APPEND ASP3_SYMVAL_TABLES
    ${ARCHDIR}/common/core_sym.def
)

list(APPEND ASP3_OFFSET_TRB_FILES
    ${ARCHDIR}/common/core_offset.trb
)

list(APPEND ASP3_INCLUDE_DIRS
    ${ARCHDIR}/stm32h5xx_stm32cube
    ${ARCHDIR}/common
    ${PROJECT_SOURCE_DIR}/arch/gcc
)

list(APPEND ASP3_COMPILE_DEFS
    TOPPERS_CORTEX_M33
    __TARGET_ARCH_THUMB=5
    __TARGET_FPU_FPV4_SP
    TOPPERS_ENABLE_TRUSTZONE
)

list(APPEND ASP3_ARCH_C_FILES
    ${ARCHDIR}/common/core_kernel_impl.c
    ${ARCHDIR}/common/core_support.S
)

set(ARCH_SERIAL ${ARCHDIR}/stm32h5xx_stm32cube/chip_serial.c)
