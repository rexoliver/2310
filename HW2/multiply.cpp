/*
 * Rex Oliver
 * CPSC 2310 Programming Assignment 2
 * HW2.cpp
 * Illustrates the steps required for multiplication
 * of two 8 bit numbers. 
 */
#include <cstdio>
#include <iostream>
#include <string>
#include <cmath>
using namespace std;

// given function that prints an int in binary for a given length
void prt_bin( int value, int length ){
    int i;
    for( i=(length-1); i>=0; i--){
        if((value>>i)&1) 
            putchar('1'); 
        else 
            putchar('0');                  
    }
}
// prints all steps and returns the result
int mul_steps(int mq, int mdr, int c, int acc, int num_steps){
    cout << "-----------------------------------------------\n";       
    // loop through the eight steps
    for(int i = 1; i <= num_steps; i++)
    {
        // first line, prints current values
        cout << "step " << i << ":     ";
        prt_bin(c, 1);
        cout << " ";
        prt_bin(acc, num_steps);
        cout << " ";
        prt_bin(mq, num_steps);
        cout << "\n";

        // second line 
        cout << "        +     ";
        // if 1 is at right of mq, then add mdr to acc
        if(mq%2 == 1){
            prt_bin(mdr, num_steps);
            cout << "        ^ add based on lsb=1\n";
            acc+=mdr;
            if(acc >= pow(2, num_steps))
                c = 1;
        }
        // otherwise, just print
        else {
            prt_bin(0, num_steps);  
            cout << "        ^ no add based on lsb = 0\n";            
        }
        
        // third line
        cout << "          --";
        for(int j = 0; j < num_steps; j++)
            cout << "-";
        
        // fourth line
        // prints the result of addition in line 2
        cout << "\n";
        cout << "            " << c << " ";
        prt_bin(acc, num_steps);
        cout <<  " ";
        prt_bin(mq, num_steps);
        cout << "\n";

        // fifth line
        // shift mq and acc right 1
        cout << "          >>                   shift right\n";
        mq = mq >> 1;
        if(acc%2 == 1)
            mq += pow(2, num_steps-1);
        acc = acc >> 1;
        c = 0;

        //sixth line, result that goes into the next loop
        // prints result that was found in shift in fifth line
        cout <<  "            " << c << " ";
        prt_bin(acc, num_steps);
        cout << " ";
        prt_bin(mq, num_steps);
        cout << "\n";
        cout << "-----------------------------------------------\n";        
    
    }
    // tacks acc onto the left of mq, making the full 16 bit number
    return (acc << num_steps) + mq;
    
}

int main(int argc, char *argv[]){
    int num_steps = 8;
    int multiplicand;
    int multiplier;
    int c = 0;
    int acc = 0;
    cin >> multiplicand >> multiplier;
    // says if multiplicand and multiplier are not valid.
    if(multiplicand > 255 || multiplicand < 0)
    {
        cout << "Multiplicand not valid\n";
        return 1;
    }
    if(multiplier > 255 || multiplier < 0)
    {
        cout << "Multiplier not valid\n";
        return 1;
    }
    // prints formatted input
    cout << "multiplicand: " << multiplicand << "\n";
    cout << "multiplier: " << multiplier << "\n\n";
    cout << "c and acc set to 0\n";
    cout << "mq set to multiplier    =  " << multiplier << " decimal and ";
    prt_bin(multiplier, num_steps);
    cout << " binary\n";
    cout << "mdr set to multiplicand =  " << multiplicand << " decimal and ";
    prt_bin(multiplicand, num_steps);
    cout << " binary\n";
    
    // prints multiplication steps and calculates multiplication value
    int result = mul_steps(multiplier, multiplicand, c, acc, num_steps);
    
    // prints the total results    
    cout << "check:                 binary    decimal\n";
    cout << "                     ";
    prt_bin(multiplicand, num_steps);
    cout << "        " << multiplicand << "\n";
    cout << "          x          ";
    prt_bin(multiplier, num_steps);
    cout << "  x     " << multiplier << "\n";
    cout << "           ------------------   --------\n";
    cout << "             ";
    prt_bin(result, num_steps*2);
    cout << "      " << result << "\n";     
    
    return 0;
} 
