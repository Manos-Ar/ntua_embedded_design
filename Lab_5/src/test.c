#include <linux/kernel.h>
#include <sys/syscall.h>

#define SYSCALL_NR 386

int main() {
    syscall(SYSCALL_NR);
    return 0;
}