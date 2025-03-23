/*
 * シリアルインタフェースドライバのターゲット依存部（非TECS版専用）
 *
 * $Id: target_serial.h 289 2021-08-05 14:44:10Z ertl-komori $
 */

#ifndef TOPPERS_TARGET_SERIAL_H
#define TOPPERS_TARGET_SERIAL_H

#include "stm32cubemx.h"

/*
 * USART関連の定義
 */
#define USART_INTNO  (0x10000U | (RP2040_UART0_IRQn + 16))
#define USART_INTPRI (TMAX_INTPRI - 1)
#define USART_ISRPRI 1

/*
 *  シリアルポート数の定義
 */
#define TNUM_PORT 1

/*
 *  コールバックルーチンの識別番号
 */
#define SIO_RDY_SND    1U        /* 送信可能コールバック */
#define SIO_RDY_RCV    2U        /* 受信通知コールバック */

#ifndef TOPPERS_MACRO_ONLY

/*
 *  シリアルI/Oポート管理ブロックの定義
 */
typedef struct sio_port_control_block    SIOPCB;

/*
 *  SIO初期化
 */
extern void sio_initialize(intptr_t exinf);

/*
 *  SIO初期化
 */
extern void sio_terminate(intptr_t exinf);

#endif /* TOPPERS_MACRO_ONLY */

/*
 * チップで共通な定義
 */
#include "stm32h5xx_hal.h"

#endif /* TOPPERS_TARGET_SERIAL_H */
