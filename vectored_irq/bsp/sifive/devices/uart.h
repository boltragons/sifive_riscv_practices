// See LICENSE for license details.

#ifndef _SIFIVE_UART_H
#define _SIFIVE_UART_H

/* Register offsets */
#define UART_REG_TXFIFO         0x00
#define UART_REG_RXFIFO         0x04
#define UART_REG_TXCTRL         0x08
#define UART_REG_RXCTRL         0x0c
#define UART_REG_IE             0x10
#define UART_REG_IP             0x14
#define UART_REG_DIV            0x18

/* TXDATA register */
#define UART_TXDATA_FULL        (1U << 31)

/* RXDATA register */
#define UART_RXDATA_MASK        (0xFF)
#define UART_RXDATA(data)       (data & UART_RXDATA_MASK)
#define UART_RXDATA_EMPTY       (1U << 31)

/* TXCTRL register */
#define UART_TXEN               0x1
#define UART_TXCNT(x)            (((x) & 0xffff) << 16)

/* RXCTRL register */
#define UART_RXEN               0x1
#define UART_RXCNT(x)            (((x) & 0xffff) << 16)

/* IP register */
#define UART_IP_TXWM            0x1
#define UART_IP_RXWM            0x2

/* IE register */
#define UART_IE_TXWM            0x1
#define UART_IE_RXWM            0x2

#endif /* _SIFIVE_UART_H */
