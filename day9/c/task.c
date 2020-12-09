#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int preamble[25];
int *inputList;
int lineCounter=0;

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

void insertIntoArray(int element, int size){
    int *temp;
    temp = (int *)malloc(sizeof(int)*(size-1));
    for(int i=0;i<size-1;i++){
        temp[i] = inputList[i];
    }
    free(inputList);
    inputList = (int *)malloc(sizeof(int)*size);
    for(int i=0;i<size-1;i++){
        inputList[i] = temp[i];
    }
    inputList[size-1]=element;
    free(temp);
    temp= NULL;
}

void freeInputList(){
    free(inputList);
    inputList=NULL;
}

int task1(){
    inputList = (int *)malloc(sizeof(int)*1);
    FILE * fp;
    char * line = NULL;
    size_t len = 0;
    ssize_t read;

    fp = fopen("../input.txt", "r");
    if (fp == NULL)
        exit(EXIT_FAILURE);

    while ((read = getline(&line, &len, fp)) != -1) {
        int number;
        sscanf(line, "%d", &number);
        insertIntoArray(number,lineCounter+1);
        if(lineCounter >24){
            if(checkNextValue(number)){
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

int task2(int t1sol){
    int firstIndex=0;
    int secondIndex=0;
    for (int i=0;i <= lineCounter; i++){
        for (int j=i+1; j<=lineCounter; j++){
            int sum=0;
            for(int k=i;k<=j;k++){
                sum+=inputList[k];
            }
            if(sum == t1sol){
                firstIndex=i;
                secondIndex=j;
                break;
            }
        }
    }
    int min=999999999;
    int max=0;
    for (int i=firstIndex; i<=secondIndex; i++){
        if(inputList[i]<min){
            min=inputList[i];
        }
        if(inputList[i]>max){
            max=inputList[i];
        }
    }
    return max+min;
}


int main(void)
{
    int task1Solution = task1();
    printf("Task1 solution: %d \n",task1Solution);
    int task2Solution = task2(task1Solution);
    printf("Task2 solution: %d \n",task2Solution);
    freeInputList();

}
