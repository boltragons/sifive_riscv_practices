#include "uart.h"

void UART_Init(uint32_t baudrate, bool rx_int, bool tx_int) {
  GPIO_REG(GPIO_IOF_SEL) &= ~IOF0_UART0_MASK;
  GPIO_REG(GPIO_IOF_EN) |= IOF0_UART0_MASK;

  UART0_REG(UART_REG_DIV) = CPU_DEF_CLOCK_FREQ / (baudrate - 1);
  
  UART0_REG(UART_REG_RXCTRL) |= UART_RXEN;
  
  UART0_REG(UART_REG_TXCTRL) |= UART_TXEN;

  if(rx_int) {
    UART0_REG(UART_REG_RXCTRL) |= UART_RXCNT(1);
    UART0_REG(UART_REG_IE) |= UART_IE_RXWM;
  }
  if(tx_int) {
    UART0_REG(UART_REG_TXCTRL) |= UART_TXCNT(1);
    UART0_REG(UART_REG_IE) |= UART_IE_TXWM;
  }
}

void UART_SendByte(uint8_t data) {
  UART0_REG(UART_REG_TXFIFO) = data;
}

uint8_t UART_ReceiveByte(void) {
  return UART0_REG(UART_REG_RXFIFO) & UART_RXDATA_MASK;
}

bool UART_CheckTxFull(void) {
  return (UART0_REG(UART_REG_TXFIFO) & UART_TXDATA_FULL) != 0;
}

bool UART_CheckRxEmpty(void) {
  return (UART0_REG(UART_REG_RXFIFO) & UART_RXDATA_EMPTY) != 0;
}

void UART_WaitTx(void) {
  while(UART0_REG(UART_REG_TXFIFO) & UART_TXDATA_FULL);
}

void UART_WaitRx(void) {
  while(UART0_REG(UART_REG_RXFIFO) & UART_RXDATA_EMPTY);
}
