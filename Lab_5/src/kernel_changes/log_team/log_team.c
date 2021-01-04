#include <linux/kernel.h>

asmlinkage long sys_log_team(void)
{
	printk("Greeting from kernel and team 10\n");
	return 0;
}	