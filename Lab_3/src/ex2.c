#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>


int main (int argc, char **argv){

    int fd, i;
    char input[64], output[64];
    if (argc<2)
        printf("Error. Invalid numder of arguments");

    char *device;

    device = (char*) malloc(sizeof(argv[1]));
    device = argv[1];

    printf("device: %s\n", device);

    fd = open(device, O_RDWR | O_NOCTTY | O_NONBLOCK);

    if(fd == -1) {
         printf( "failed to open port\n" ); 
    }

    printf("fd : %d\n", fd);
    char c;

    for(i=0; i<64 ; i++){
        c = getchar();
        input[i]=c;
        if (c == '\n')
            break;
    }

    printf("input: %ssize: %d\n", input, i);

    int wr = write(fd, input, i);
    printf("wd : %d\n" , wr);

    // if(wr < 0)
    //     {
    //         printf("error write\n");
    //         exit(-1);
    //     }

    // close(fd);
    
    
    int rd = -1;    
    while( rd < 0)
        rd=read(fd, output, 12);

    printf("output: %s\n", output);


    close(fd);
}