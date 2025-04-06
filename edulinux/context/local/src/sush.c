#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

int main(int argc, char *argv[]){
  struct stat file_stat;
  if(stat(argv[2], &file_stat)){
    perror("stat");
    exit(EXIT_FAILURE);
  }
  if(file_stat.st_mode & 04000)
    setuid(file_stat.st_uid);
  return execvp(argv[1], &argv[1]);
}
