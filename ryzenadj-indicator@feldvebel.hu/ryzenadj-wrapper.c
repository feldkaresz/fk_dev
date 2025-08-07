// File: ryzenadj-wrapper.c

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <watts>\n", argv[0]);
        return 1;
    }

    char command[128];
    snprintf(command, sizeof(command), "/usr/local/bin/ryzenadj --stapm-limit=%s", argv[1]);
    

    return system(command);
}
