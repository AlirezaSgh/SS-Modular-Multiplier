# Bitwise operation in python:
def integer_to_bits(n, min_bit_count: int):
    # Convert to binary and strip the '0b' prefix
    binary_representation = bin(n)[2:]
    # Convert the binary string to a list of integers
    bits = [int(bit) for bit in binary_representation]
    bits.reverse()
    if len(bits) < min_bit_count:
        for i in range(min_bit_count - len(bits)):
            bits.append(0)
    return bits

def SSMMul(a: int, b: int, N: int):
    p = 0
    c = a
    b_bits = integer_to_bits(b, max(N.bit_length(), a.bit_length()))
    for b_i in b_bits:
        if b_i == 1:
            p += c
        print(p)
        if p >= N:
            p -= N
        c = c << 1
        if c >= N:
            c -= N
    return p

# Sample code:
N = 239
a = 217
b = 189

z = SSMMul(a, b, N)
print(z)
print((a * b) % N)
