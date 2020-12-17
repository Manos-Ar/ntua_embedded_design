#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>


int main (int argc, char **argv){

    int fd;
    struct termios options;
    char input[64], output[64], *device;

    if (argc<2) {
        printf("Error. Invalid numder of arguments\n");
        return 1;
    }

    device = argv[1];

    printf("Please give a string to send to guest:\n");
    fgets(input, 64, stdin);

    //open device as non-blocking
    fd = open(device, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if(fd == -1) {
         printf("Failed to open port\n");
         return 1;
    }

    //get dafault options
    if(tcgetattr(fd, &options) < 0) {
        printf("Couldn't the information for the terminal associated with %s\n", device);
        return 1;
    }

    //set canonical mode
    options.c_lflag |= ICANON;

    //set baudrate
    if(cfsetispeed(&options, B9600) < 0 || cfsetospeed(&options, B9600) < 0) {
        printf("Couldn't set communication speed\n");
        return 1;
    }

    //apply option
    if(tcsetattr(fd, TCSANOW, &options) < 0) {
        printf("Couldn't apply communication settings\n");
        return 1;
    }

    //flush input
    tcflush(fd, TCIOFLUSH);

    //here we print the options so we can define the same in guest
    // printf("c_iflag: %x, c_oflag: %x, c_lflag: %x, c_cflag: %x\n", 
    //         options.c_iflag, options.c_oflag, options.c_lflag, options.c_cflag);

    //write user input
    write(fd, input, 64);

    //wait for guest answer
    while (read(fd, output, 64) <= 0);
    printf("The most frequent character is \"%c\" and it appeared %d times.\n", output[0], output[2]);
    
    close(fd);
    return 0;
}