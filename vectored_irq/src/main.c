#include "bsp.h"

#include <stdint.h>
#include <stdbool.h>

#include "uart.h"

/* Board Pins */

#define GREEN_BUTTON 	19
#define BLUE_BUTTON 	20
#define YELLOW_BUTTON 	1
#define RED_BUTTON 		2

#define GREEN_LED 		18
#define BLUE_LED 		21
#define YELLOW_LED 		0
#define RED_LED 		3

// Control variables:
bool timer_enable = false;

// Interrupt Vector
extern void INT_VectorEntry(void);

// Private Functions
void SYS_ReloadTimer(uint32_t ms);

void SYS_InitBoardLeds(void);

void SYS_SetupInterrupt(void);

void SYS_SetupClock(void);

void SYS_InitBoardButtons(void);

void SYS_GpioHandler(uint32_t gpio);

void SYS_UartHandler(void);

/* Interrupt Handlers */

void INT_MachineSoftwareHandler(void) {
	MACHINE_SWI(false);
	timer_enable = !timer_enable;
	if(timer_enable) {
		set_csr(mie, (1 << MACHINE_TIMER_IRQ));
	}
	else {
		clear_csr(mie, (1 << MACHINE_TIMER_IRQ));
	}
}

void INT_MachineTimerHandler(void) {
	GPIO_REG(GPIO_OUTPUT_VAL) ^= (1 << RED_LED);
	SYS_ReloadTimer(1000);
}

void INT_MachineExternalHandler(void) {
	uint32_t id = PLIC_REG(PLIC_CLAIM);
	if(id >= INT_GPIO_BASE && id <= INT_GPIO_END) {
		SYS_GpioHandler(INT_TO_GPIO(id));
	}
	else if(id == INT_UART0_BASE) {
		SYS_UartHandler();
	}
	PLIC_REG(PLIC_CLAIM) = id;
}

int main (void) {
	SYS_SetupClock();
	UART_Init(115200, true, false);
	SYS_InitBoardButtons();
	SYS_InitBoardLeds();
	SYS_SetupInterrupt();
	SYS_ReloadTimer(1000);

	while (1) {
		if(!(GPIO_REG(GPIO_INPUT_VAL) & (1 << RED_BUTTON))) {
			MACHINE_SWI(true);
			for(int i = 0; i < 1000; i++);
		}
	}
}

void SYS_GpioHandler(uint32_t gpio) {
	switch (gpio) {
	case GREEN_BUTTON:
		GPIO_REG(GPIO_OUTPUT_VAL) ^= (1 << GREEN_LED);
		break;
	case BLUE_BUTTON:
		GPIO_REG(GPIO_OUTPUT_VAL) ^= (1 << BLUE_LED);
		break;
	case YELLOW_BUTTON:
		GPIO_REG(GPIO_OUTPUT_VAL) ^= (1 << YELLOW_LED);
		break;
	}

	GPIO_REG(GPIO_FALL_IP) |= (1 << gpio);
}

void SYS_UartHandler(void) {
	uint8_t value = UART_ReceiveByte();

	switch(value) {
	case '1':
		GPIO_REG(GPIO_OUTPUT_VAL) ^= (1 << GREEN_LED);
		break;
	case '2':
		GPIO_REG(GPIO_OUTPUT_VAL) ^= (1 << BLUE_LED);
		break;
	case '3':
		GPIO_REG(GPIO_OUTPUT_VAL) ^= (1 << YELLOW_LED);
		break;
	}
}

void SYS_SetupInterrupt(void) {
	write_csr(mstatus, 0);

	PLIC_REG(4*INT_UART0_BASE) = 1;
	PLIC_REG(4*INT_GPIO(GREEN_BUTTON)) = 1;
	PLIC_REG(4*INT_GPIO(BLUE_BUTTON)) = 1;
	PLIC_REG(4*INT_GPIO(YELLOW_BUTTON)) = 1;

	PLIC_REG(PLIC_ENABLE) |= (1 << INT_UART0_BASE)
		| (1 << INT_GPIO(GREEN_BUTTON))
		| (1 << INT_GPIO(BLUE_BUTTON))
		| (1 << INT_GPIO(YELLOW_BUTTON));
	
	PLIC_REG(PLIC_THRESHOLD) = 0;

	write_csr(mie, 
		(1 << MACHINE_EXTERNAL_IRQ) | 
		(1 << MACHINE_SOFTWARE_IRQ)
	);

	write_csr(mtvec, ((uint32_t) &INT_VectorEntry) | 1);
	write_csr(mstatus, (1 << 3));
}

void SYS_SetupClock(void) {
	PRCI_REG(PRCI_PLLCFG) = PLL_REFSEL(1) | PLL_BYPASS(1);
	PRCI_REG(PRCI_PLLCFG) |= PLL_SEL(1);
}

void SYS_InitBoardButtons(void) {
	GPIO_REG(GPIO_IOF_EN) &= ~(1 << GREEN_BUTTON)
		& ~(1 << BLUE_BUTTON)
		& ~(1 << YELLOW_BUTTON)
		& ~(1 << RED_BUTTON);

	GPIO_REG(GPIO_INPUT_EN) |= (1 << GREEN_BUTTON)
		| (1 << BLUE_BUTTON)
		| (1 << YELLOW_BUTTON)
		| (1 << RED_BUTTON);

	GPIO_REG(GPIO_OUTPUT_EN) &= ~(1 << GREEN_BUTTON)
		& ~(1 << BLUE_BUTTON)
		& ~(1 << YELLOW_BUTTON)
		& ~(1 << RED_BUTTON);

	GPIO_REG(GPIO_PULLUP_EN) |= (1 << GREEN_BUTTON)
		| (1 << BLUE_BUTTON)
		| (1 << YELLOW_BUTTON)
		| (1 << RED_BUTTON);

	GPIO_REG(GPIO_FALL_IE) |= (1 << GREEN_BUTTON)
		| (1 << BLUE_BUTTON)
		| (1 << YELLOW_BUTTON);
}

void SYS_InitBoardLeds(void) {
	GPIO_REG(GPIO_IOF_EN) &= ~(1 << GREEN_LED)
		& ~(1 << BLUE_LED)
		& ~(1 << YELLOW_LED)
		& ~(1 << RED_LED);

	GPIO_REG(GPIO_OUTPUT_EN) |= (1 << GREEN_LED)
		| (1 << BLUE_LED)
		| (1 << YELLOW_LED)
		| (1 << RED_LED);

	GPIO_REG(GPIO_INPUT_EN) &= ~(1 << GREEN_LED)
		& ~(1 << BLUE_LED)
		& ~(1 << YELLOW_LED)
		& ~(1 << RED_LED);

	GPIO_REG(GPIO_OUTPUT_VAL) &= ~(1 << GREEN_LED)
		& ~(1 << BLUE_LED)
		& ~(1 << YELLOW_LED)
		& ~(1 << RED_LED);
}

void SYS_ReloadTimer(uint32_t ms) {
	CLINT_REG64(CLINT_MTIMECMP) = CLINT_REG64(CLINT_MTIME) + ms*(RTC_FREQ/1000.0);
}
