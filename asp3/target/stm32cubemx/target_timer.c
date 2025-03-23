/*
 *  TOPPERS/ASP Kernel
 *      Toyohashi Open Platform for Embedded Real-Time Systems/
 *      Advanced Standard Profile Kernel
 * 
 *  Copyright (C) 2016-2020 by Embedded and Real-Time Systems Laboratory
 *              Graduate School of Information Science, Nagoya Univ., JAPAN
 * 
 *  上記著作権者は，以下の(1)〜(4)の条件を満たす場合に限り，本ソフトウェ
 *  ア（本ソフトウェアを改変したものを含む．以下同じ）を使用・複製・改
 *  変・再配布（以下，利用と呼ぶ）することを無償で許諾する．
 *  (1) 本ソフトウェアをソースコードの形で利用する場合には，上記の著作
 *      権表示，この利用条件および下記の無保証規定が，そのままの形でソー
 *      スコード中に含まれていること．
 *  (2) 本ソフトウェアを，ライブラリ形式など，他のソフトウェア開発に使
 *      用できる形で再配布する場合には，再配布に伴うドキュメント（利用
 *      者マニュアルなど）に，上記の著作権表示，この利用条件および下記
 *      の無保証規定を掲載すること．
 *  (3) 本ソフトウェアを，機器に組み込むなど，他のソフトウェア開発に使
 *      用できない形で再配布する場合には，次のいずれかの条件を満たすこ
 *      と．
 *    (a) 再配布に伴うドキュメント（利用者マニュアルなど）に，上記の著
 *        作権表示，この利用条件および下記の無保証規定を掲載すること．
 *    (b) 再配布の形態を，別に定める方法によって，TOPPERSプロジェクトに
 *        報告すること．
 *  (4) 本ソフトウェアの利用により直接的または間接的に生じるいかなる損
 *      害からも，上記著作権者およびTOPPERSプロジェクトを免責すること．
 *      また，本ソフトウェアのユーザまたはエンドユーザからのいかなる理
 *      由に基づく請求からも，上記著作権者およびTOPPERSプロジェクトを
 *      免責すること．
 * 
 *  本ソフトウェアは，無保証で提供されているものである．上記著作権者お
 *  よびTOPPERSプロジェクトは，本ソフトウェアに関して，特定の使用目的
 *  に対する適合性も含めて，いかなる保証も行わない．また，本ソフトウェ
 *  アの利用により直接的または間接的に生じたいかなる損害に関しても，そ
 *  の責任を負わない．
 * 
 *  $Id: target_timer.c 292 2021-10-11 12:27:17Z ertl-komori $
 */

/*
 *		タイマドライバ（TIM用）
 *		 TIM2をフリーランニング，TIM5を割込み通知用に使用する．
 */

#include "kernel_impl.h"
#include "time_event.h"
#include "target_timer.h"
#include <sil.h>
#include "stm32h5xx_ll_bus.h"

/*
 * タイマの起動処理
 */
void
target_hrt_initialize(intptr_t exinf)
{
	LL_TIM_InitTypeDef TIM_InitStruct = {0};

	/*
	 * フリーランニングタイマ
	 */
	/* クロック有効 */
	LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_TIM2);

	TIM_InitStruct.Prescaler = __LL_TIM_CALC_PSC(SystemCoreClock, 1000000);
	TIM_InitStruct.CounterMode = LL_TIM_COUNTERMODE_UP;
	TIM_InitStruct.Autoreload = 0xffffffff; /* 上限値 */
	TIM_InitStruct.ClockDivision = LL_TIM_CLOCKDIVISION_DIV1;

	LL_TIM_Init(TIM2, &TIM_InitStruct);

	LL_TIM_SetCounter(TIM2, 0);
	LL_TIM_EnableCounter(TIM2);

	/*
	 *  割込み通知用タイマ
	 */
	/* クロック有効 */
	LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_TIM5);

	LL_TIM_Init(TIM5, &TIM_InitStruct);

	/* OneShot */
	LL_TIM_SetOnePulseMode(TIM5, LL_TIM_ONEPULSEMODE_SINGLE);

	LL_TIM_ClearFlag_UPDATE(TIM5);
	LL_TIM_EnableIT_UPDATE(TIM5);
}

/*
 * タイマの停止処理
 */
void
target_hrt_terminate(intptr_t exinf)
{
	LL_TIM_DisableCounter(TIM2);
	LL_TIM_DisableCounter(TIM5);
}

/*
 *  タイマ割込みハンドラ
 */
void
target_hrt_handler(void)
{
	/* Clear Event */
	LL_TIM_ClearFlag_UPDATE(TIM5);

	/*
	 *  高分解能タイマ割込みを処理する．
	 */
    signal_time();
}
