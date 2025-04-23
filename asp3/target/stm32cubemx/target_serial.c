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
    uint8_t rx_buf[256];               /* 受信バッファ */
    uint32_t rx_wpos;              /* 受信バッファ書き込み位置 */
    uint32_t rx_rpos;              /* 受信バッファ読み込み位置 */
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
    for (uint_t i = 0; i < TNUM_PORT; i++)
    {
        siopcb_table[i].exinf = exinf;
        siopcb_table[i].handle = NULL;
    }
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
    result->rx_wpos = 0;
    result->rx_rpos = 0;

    HAL_NVIC_SetPriority(USART3_IRQn, 1, 0);
    HAL_NVIC_EnableIRQ(USART3_IRQn);

    HAL_UART_Receive_IT(result->handle, &result->rx_buf[result->rx_wpos], 1); // 受信割込み開始

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
    if (p_siopcb->rx_wpos != p_siopcb->rx_rpos) // 受信バッファにデータがある場合
    {
        ch = p_siopcb->rx_buf[p_siopcb->rx_rpos];
        p_siopcb->rx_rpos = (p_siopcb->rx_rpos + 1) % sizeof(p_siopcb->rx_buf); // 読み込み位置を更新
        return ch;
    }
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

void HAL_UART_TxCpltCallback(UART_HandleTypeDef *huart)
{
    SIOPCB *result = NULL;
    for (uint_t i = 0; i < TNUM_PORT; i++)
    {
        if (siopcb_table[i].handle == huart)
        {
            result = &siopcb_table[i];
            break;
        }
    }
    if (result == NULL)
    {
        return; // 該当するポートが見つからない場合は何もしない
    }
    // 送信完了時の処理をここに追加することができます。
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
    SIOPCB *result = NULL;
    for (uint_t i = 0; i < TNUM_PORT; i++)
    {
        if (siopcb_table[i].handle == huart)
        {
            result = &siopcb_table[i];
            break;
        }
    }
    if (result == NULL)
    {
        return; // 該当するポートが見つからない場合は何もしない
    }
    result->rx_wpos = (result->rx_wpos + 1) % sizeof(result->rx_buf); // 書き込み位置を更新
    HAL_UART_Receive_IT(result->handle, &result->rx_buf[result->rx_wpos], 1); // 受信割込み開始
}

void HAL_UART_ErrorCallback(UART_HandleTypeDef *huart)
{
    SIOPCB *result = NULL;
    for (uint_t i = 0; i < TNUM_PORT; i++)
    {
        if (siopcb_table[i].handle == huart)
        {
            result = &siopcb_table[i];
            break;
        }
    }
    if (result == NULL)
    {
        return; // 該当するポートが見つからない場合は何もしない
    }
    // エラー処理をここに追加することができます。
}

void sio_handler(void)
{
    HAL_UART_IRQHandler(siopcb_table[0].handle);   // UARTの割込みハンドラを初期化
}