#include <stdio.h>
#include <stdlib.h>
#include <pwd.h>
#include <unistd.h>
#include <libgen.h>
#include <sys/stat.h>
#include <sys/types.h>

#define PROBLEMS_LOC "/home/mlekande/CPC"
#define MAX_FILESIZE 2560

void safe_chdir(char *dir) {
    struct stat s;
    if (stat(dir, &s) == -1 || !S_ISDIR(s.st_mode)) {
        printf("Error: Could not find directory %s\n", dir);
        exit(-1);
    }
    
    chdir(dir);
}

int main(int argc, char *argv[]) {
    char *user = getpwuid(getuid())->pw_name;
    char *competition, *problem, *file;
    FILE *f;
    int i, c;
    
    if (argc != 4) {
        puts("Error: Not enough arguments");
        exit(-1);
    }
    
    competition = basename(argv[1]);
    problem = basename(argv[2]);
    file = basename(argv[3]);
    
    chdir(PROBLEMS_LOC);
    safe_chdir(competition);
    safe_chdir(problem);
    chdir("submissions/queued");
    mkdir(user, S_IRWXU|S_IRGRP|S_IXGRP);
    safe_chdir(user);
    
    f = fopen(file, "w+");
    for (i = 0; i < MAX_FILESIZE && (c = getchar()) != EOF; i++)
        fputc(c, f);
    fclose(f);
}
