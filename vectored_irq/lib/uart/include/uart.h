#ifndef _HAL_UART_H
#define _HAL_UART_H

#include <stdbool.h>

#include "bsp.h"

#define UART_CHECK_RX_PENDING()     (UART0_REG(UART_REG_IP) & UART_IP_RXWM)
#define UART_CHECK_TX_PENDING()     (UART0_REG(UART_REG_IP) & UART_IP_TXWM)

void UART_Init(uint32_t baudrate, bool rx_int, bool tx_int);

void UART_SendByte(uint8_t data);

uint8_t UART_ReceiveByte(void);

bool UART_CheckTxFull(void);

bool UART_CheckRxEmpty(void);

void UART_WaitTx(void);

void UART_WaitRx(void);

#endif
