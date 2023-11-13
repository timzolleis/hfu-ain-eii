#include <cstdio>

int euclid(int a, int b){
if(a == 0){
return b;
}
return euclid(b % a, a);
}


int main(){
int numberA;
int numberB;
printf("Please enter a number A \n");
scanf("%i", &numberA);
printf("Please enter a number B \n");
scanf("%i", &numberB);

int res = euclid(numberA, numberB);
printf("Result: %i \n", res);
return 0;
}