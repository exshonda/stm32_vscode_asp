
target_sources(${CMAKE_PROJECT_NAME} PUBLIC
    ${ASP3_ROOT_DIR}/syssvc/syslog.c
    ${ASP3_ROOT_DIR}/syssvc/banner.c
    ${ASP3_ROOT_DIR}/syssvc/serial.c
    ${ASP3_ROOT_DIR}/syssvc/serial_cfg.c
    ${ASP3_ROOT_DIR}/syssvc/logtask.c
    ${ARCH_SERIAL}
)
