#include <cmath>
#include <stdio.h> 

#define FP2BIN_STRING_MAX 1077


/***********************************************************/
/* fp2bin.c: Convert IEEE double to binary string          */
/*                                                         */
/* Rick Regan, http://www.exploringbinary.com              */
/*                                                         */
/***********************************************************/
#include <string.h>
#include <math.h>

void fp2bin_i(double fp_int, char* binString)
{
    int bitCount = 0;
    int i;
    char binString_temp[FP2BIN_STRING_MAX];

    do
    {
        binString_temp[bitCount++] = '0' + (int)fmod(fp_int,2);
        fp_int = floor(fp_int/2);
    } while (fp_int > 0);

    /* Reverse the binary string */
    for (i=0; i<bitCount; i++)
        binString[i] = binString_temp[bitCount-i-1];

    binString[bitCount] = 0; //Null terminator
}

void fp2bin_f(double fp_frac, char* binString)
{
    int bitCount = 0;
    double fp_int;

    while (fp_frac > 0)
    {
        fp_frac*=2;
        fp_frac = modf(fp_frac,&fp_int);
        binString[bitCount++] = '0' + (int)fp_int;
    }
    binString[bitCount] = 0; //Null terminator
}

void fp2bin(double fp, char* binString)
{
    double fp_int, fp_frac;

    /* Separate integer and fractional parts */
    fp_frac = modf(fp,&fp_int);

    /* Convert integer part, if any */
    if (fp_int != 0)
        fp2bin_i(fp_int,binString);
    else
        strcpy(binString,"0");

    strcat(binString,"."); // Radix point

    /* Convert fractional part, if any */
    if (fp_frac != 0)
        fp2bin_f(fp_frac,binString+strlen(binString)); //Append
    else
        strcpy(binString+strlen(binString),"0");
}


int main (int argc, char** argv) {

    double val1 = 0.1;
    double val2 = 0.11;

    int ex1, ex2; 
    double s1, s2;

    s1 = frexp(val1, &ex1); 
    s2 = frexp(val2, &ex2); 

    printf("%f * 2^%d\n", s1, ex1); 
    printf("%f * 2^%d\n", s2, ex2); 

    char binString[FP2BIN_STRING_MAX];

    fp2bin(s1,binString);
    printf("s1 is %s\n",binString);

    fp2bin(s2,binString);
    printf("s2 is %s\n",binString);

    fp2bin(13.0,binString);
    printf("13.0 is %s\n",binString);

    return 0; 
}
