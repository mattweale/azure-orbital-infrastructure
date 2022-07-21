from bitstring import BitArray, Bits
import sys

f = open(sys.argv[1],'rb')
p = Bits(f)
pattern = BitArray('0x1ACFFC1D')
locations = p.findall(pattern)
try:
    for i in range(10):
        next(locations)
    print('Found at least 10 ASMs')
except:
    print('Did not find signficant amount of ASMs')

#comment out if it takes to long to count
print(len(tuple(locations))+10)