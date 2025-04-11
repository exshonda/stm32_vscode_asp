/*
 * シリアルインタフェースドライバのターゲット依存部（非TECS版専用）
 *
 * $Id: target_serial.h 289 2021-08-05 14:44:10Z ertl-komori $
 */

#include <stdint.h>
#include <stdio.h>
#include "t_stddef.h"
#include "target_serial.h"
#include "target_syssvc.h"
#include "stm32h5xx_nucleo.h"

struct sio_port_control_block
{
    intptr_t exinf;
    UART_HandleTypeDef *handle; /* UARTハンドル */
};

/*
 *  SIOポート管理ブロックのエリア
 */
static SIOPCB siopcb_table[TNUM_PORT];

/*
 *  SIOポートIDから管理ブロックを取り出すためのマクロ
 */
#define INDEX_SIOP(siopid)	((uint_t)((siopid) - 1))
#define get_siopcb(siopid)	(&(siopcb_table[INDEX_SIOP(siopid)]))

/*
 * SIOドライバの初期化
 */
void sio_initialize(intptr_t exinf)
{
}

/*
 * SIOドライバの終了処理
 */
void sio_terminate(intptr_t exinf)
{
}

/*
 * SIOポートのオープン
 */
SIOPCB *sio_opn_por(ID siopid, intptr_t exinf)
{
    SIOPCB *result = NULL;
    if (siopid > TNUM_PORT)
    {
        return result;
    }
    result = get_siopcb(siopid);
    result->exinf = exinf;
    result->handle = &hcom_uart[siopid - 1];
    return result;
}

/*
 * SIOポートのクローズ
 */
void sio_cls_por(SIOPCB *p_siopcb)
{
    p_siopcb->handle = NULL;
}

/*
 * SIOポートへの文字送信
 */
bool_t sio_snd_chr(SIOPCB *p_siopcb, char ch)
{
    return HAL_UART_Transmit(p_siopcb->handle, (uint8_t *) &ch, 1, COM_POLL_TIMEOUT) == HAL_OK;
}

/*
 * SIOポートからの文字受信
 */
int_t sio_rcv_chr(SIOPCB *p_siopcb)
{
    uint8_t ch;
    if(HAL_UART_Receive(p_siopcb->handle, &ch, 1, COM_POLL_TIMEOUT) == HAL_OK)
        return ch;
    return -1; // 受信失敗
}

/*
 * SIOポートからのコールバックの許可
 */
void sio_ena_cbr(SIOPCB *p_siopcb, uint_t cbrtn)
{
    switch (cbrtn)
    {
    case SIO_RDY_SND:
        /* code */
        break;
    case SIO_RDY_RCV:
        /* code */
        break;
    default:
        break;
    }
}

/*
 * SIOポートからのコールバックの禁止
 */
void sio_dis_cbr(SIOPCB *p_siopcb, uint_t cbrtn)
{
    switch (cbrtn)
    {
    case SIO_RDY_SND:
        /* code */
        break;
    case SIO_RDY_RCV:
        /* code */
        break;
    default:
        break;
    }
}

/*
 * SIOポートへの文字出力
 */
void target_fput_log(char c)
{
    if (c == '\n')
    {
        putc('\r', stdout);
    }
    putc(c, stdout);
}
