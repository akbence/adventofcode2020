#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

int preamble[25];

void addToArray(int number, int lineCounter){
    
    if(lineCounter>24){
        for(int i=0; i<24; i++){
            preamble[i] = preamble[i+1]; 
        }
        preamble[24] =number;
    }
    else{
        preamble[lineCounter] = number; 
    }
}

int checkNextValue(int number){
    for(int i=0; i<25; i++){
        for(int j=i+1; j<25; j++){
            if(preamble[i]+preamble[j] == number){
                return 0;
            }
        }
    }
    return 1;
}


int task1(){
    FILE * fp;
    char * line = NULL;
    size_t len = 0;
    ssize_t read;

    fp = fopen("../input.txt", "r");
    if (fp == NULL)
        exit(EXIT_FAILURE);

    int lineCounter=0;
    while ((read = getline(&line, &len, fp)) != -1) {
        int number;
        sscanf(line, "%d", &number);
        if(lineCounter >24){
            if(checkNextValue(number)){
                printf("Task1 solution: %d",number);
                return number;
            }
        }
        addToArray(number,lineCounter);
        lineCounter++;
    }

    fclose(fp);
    if (line)
        free(line);
    exit(EXIT_SUCCESS);
    return 0;

}




int main(void)
{
    task1();
 
}
