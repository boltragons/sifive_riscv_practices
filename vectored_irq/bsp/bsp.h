#ifndef BSP_H
#define BSP_h

#include "encoding.h"
#include "platform.h"

#define CPU_DEF_CLOCK_FREQ      (16000000)
#define CLINT_TIMER_FREQ        (RTC_FREQ)

#define USER_SOFTWARE_IRQ		(0)
#define MACHINE_SOFTWARE_IRQ	(3)
#define MACHINE_TIMER_IRQ		(7)
#define MACHINE_EXTERNAL_IRQ	(11)

#endif
