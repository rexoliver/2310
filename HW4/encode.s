// Rex Oliver
// CPSC 2310-001 HW4
// 4/26/2019
// encode.s

.file "encode.s"
.section .text
.global encode
.align 2
.type encode, %function

/*
function name: encode

description: 
This program takes in text and encodes or decodes it using private encoding 
algorithm
The algorithm basically has a message and a shared key, and for each letter
in the message, its corresponding letter( in number form)
in the shared key are added together to create a number. If this number
is greater than 26, 26 is subtracted from it, then the number is finally
converted into text form and stringed together into the resulting encoding
scheme. The decoding process does the same thing, but backwards. 

input parameters: 
r0 - base of string we need to convert
r1 - base of key string
r2 - base of return string
r3 - decides to encode or decode  

local register usage is discussed in the .req statements
*/

s_input  	.req r0 // base of string memory location, later changed
key_input 	.req r1 // key input
key_string 	.req r2 // key string
e_or_d  	.req r3	// says to encode or decode
ret_array_index .req r4 // string array location
key_array_index .req r5 // key array location
count 		.req  r6 // count for the normal string
key_count 	.req r7 // count for the key string
norm_char 	.req r8   // keeps track of current normal string character
key_char 	.req r9   // keeps track of current key string character
output_array 	.req r10  // output array
value 		.req r11 // value that is computed from


encode: 
    push {r4-r11, lr}
    mov key_count, #0 // initialization of counts
    mov count, #0

    // puts the temp values into the right areas
    mov ret_array_index, s_input 
    mov key_array_index, key_string 
    mov output_array, key_input
    
    // Encodes or decodes based on e_o_d, passed in via program
    cmp e_or_d, #1
    beq decode

e_loop: 
    ldrb norm_char, [ret_array_index, count]

    cmp norm_char, #0 // if the normal character array is finished, the 
    beq done	      // program is done

    cmp norm_char, #32 // if the normal character is a space, go to space 
    beq e_space	       // handling function

    ldrb key_char, [key_array_index, key_count] // get key character from array
						// store it in key_char

    cmp key_char, #0 // if gotten to end of key string, reset the key character
    beq e_reset

    cmp key_char, #32 // if key char is space, go to e_zero
    beq e_zero

    // This section relies on the key and message being lowercase, as it is
    // adding 96 when it should add lower numbers than this while uppercase
    sub norm_char, norm_char, #96 // subs the ascii value so that the  
    sub key_char, key_char, #96	  // value is from 1-26
    add value, norm_char, key_char // adds key and norm to get value
    
    cmp value, #26 // if value is over 26, subtract it by 26
    bgt e_decrease 
    
    add value, value, #96 	// convert it back to ascii
    strb value, [output_array, count]    // store it in the output array
    
    // increment both counts
    add count, count, #1
    add key_count, key_count, #1

    bal e_loop // always branch bakc to loop

// Decoding logic, each step is the exact same as the encoding
// logic except uses decoding functions instead
decode: 
    ldrb norm_char, [ret_array_index, count]

    cmp norm_char, #0 
    beq done
    
    cmp norm_char, #32
    beq d_space

    ldrb key_char, [key_array_index, key_count]

    cmp key_char, #0
    beq d_reset

    cmp key_char, #32
    beq d_zero

    sub norm_char, norm_char, #96
    sub key_char, key_char, #96
    sub value, norm_char, key_char
    cmp value, #0
    ble d_increase

    add value, value, #96
    strb value, [output_array, count]
    
    add count, count, #1
    add key_count, key_count, #1

    bal decode

// These are the encode and decode helper functions, I will just comment the
// encode ones, as the decode ones are basically the exact same 


// Resets key count, used to restart the key array at beginning to keep
// encoding
e_reset: 
    mov key_count, #0
    bal e_loop

d_reset: 
    mov key_count, #0
    bal decode
    

// deals with the space character
// puts space into the array
e_space:
    mov value, #32
    strb value, [output_array, count] // stores value in output_array at count
    // increments count
    add count, count, #1 
    add key_count, key_count, #1
    bal e_loop // goes back to main loop

d_space: 
    mov value, #32
    strb value, [output_array, count]
    add count, count, #1
    add key_count, key_count, #1
    bal decode


// handles zero, inserts it into the output array
e_zero: 
    strb norm_char, [output_array, count] // inserts 0 into output array
    // increments counters
    add count, count, #1 
    add key_count, key_count, #1
    bal e_loop

d_zero: 
    strb norm_char, [output_array, count]
    add count, count, #1
    add key_count, key_count, #1
    bal decode


// when value is over 26, subtracts it by 26, then encodes it and stores in 
// output array
e_decrease:
    sub value, value, #26 // subtract it by 26
    add value, value, #96 // encodes it to ascii value
    strb value, [output_array, count] // stores it in output array
    // increments counters
    add count, count, #1
    add key_count, key_count, #1
    bal e_loop

d_increase: 
    add value, value, #26
    add value, value, #96
    strb value, [output_array, count]
    add count, count, #1
    add key_count, key_count, #1
    bal decode

// when done encoding or decoding
done: 
    strb norm_char, [output_array, count] // store the string array to be 
					// printed as output 
    pop {r4-r11, pc} // pop back 
