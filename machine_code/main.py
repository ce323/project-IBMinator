import re

# // opcodes
# // add
# 110000 --> Done, Tested
# // sub
# 110001 --> Done, Tested
# // mul
# 110010 --> Done, Tested
# // div
# 110011 --> Done, Tested
# // cmp
# 110100 --> Done, Tested
# // rev
# 110101 --> Done, Tested
# // rnd
# 110110 --> Done, Tested
# // lws
# 110111 --> Done
# // sws
# 111000 --> Don
# all_coeffs = (re.findall(r'([-+]*[\d]+)(x*\^([\d]+))*', func))
assembly = open("assemble.txt", "r")
file = open("float.mem", "w")
generated_mem = ''
for line in assembly:
    line = line.strip()
    t = ''
    if line.startswith('lui'):
        # 001111
        aa = re.findall(r'lui \$([\d]+),(0x[0-9ABCDEF]+)', line)
        print('lui', aa)
        t = f'0b00111100000{bin(int(aa[0][0]))[2:].zfill(5)}{bin(int(aa[0][1], 16))[2:].zfill(16)}'
    elif line.startswith('addiu'):
        aa = re.findall(r'addiu \$([\d]+),\$zero,(0x[0-9ABCDEF]+)', line)
        print('addiu', aa)
        t = f'0b00100100000{bin(int(aa[0][0]))[2:].zfill(5)}{bin(int(aa[0][1], 16))[2:].zfill(16)}'
    elif line.startswith('sws'):
        aa = re.findall(r'sws \$ts([\d]+),([\d]+)\(\$([\d]+)\)', line)
        print('sws', aa)
        t = f'0b001011{bin(int(aa[0][2]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(int(aa[0][1]))[2:].zfill(16)}'
    elif line.startswith('nop'):
        t = f'0b{bin(0)[2:].zfill(32)}'
        print('nop', t)
    elif line.startswith('lws'):
        aa = re.findall(r'lws \$ts([\d]+),([\d]+)\(\$([\d]+)\)', line)
        print('lws', aa)
        t = f'0b110111{bin(int(aa[0][2]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(int(aa[0][1]))[2:].zfill(16)}'
    elif line.startswith('lw'):
        aa = re.findall(r'lw \$([\d]+),([\d]+)\(\$([\d]+)\)', line)
        print('lw', aa)
        t = f'0b100011{bin(int(aa[0][2]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(int(aa[0][1]))[2:].zfill(16)}'
    elif line.startswith('sw'):
        aa = re.findall(r'sw \$([\d]+),([\d]+)\(\$([\d]+)\)', line)
        print('sw', aa)
        t = f'0b101011{bin(int(aa[0][2]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(int(aa[0][1]))[2:].zfill(16)}'
    elif line.startswith('adds'):
        aa = re.findall(r'adds \$ts([\d]+),\$ts([\d]+),\$ts([\d]+)', line)
        print('adds', aa)
        t = f'0b110000{bin(int(aa[0][1]))[2:].zfill(5)}{bin(int(aa[0][2]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(0)[2:].zfill(11)}'
    elif line.startswith('subs'):
        aa = re.findall(r'subs \$ts([\d]+),\$ts([\d]+),\$ts([\d]+)', line)
        print('subs', aa)
        t = f'0b110001{bin(int(aa[0][1]))[2:].zfill(5)}{bin(int(aa[0][2]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(0)[2:].zfill(11)}'
    elif line.startswith('divs'):
        aa = re.findall(r'divs \$ts([\d]+),\$ts([\d]+),\$ts([\d]+)', line)
        print('divs', aa)
        t = f'0b110011{bin(int(aa[0][1]))[2:].zfill(5)}{bin(int(aa[0][2]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(0)[2:].zfill(11)}'
    elif line.startswith('muls'):
        aa = re.findall(r'muls \$ts([\d]+),\$ts([\d]+),\$ts([\d]+)', line)
        print('muls', aa)
        t = f'0b110010{bin(int(aa[0][1]))[2:].zfill(5)}{bin(int(aa[0][2]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(0)[2:].zfill(11)}'
    elif line.startswith('cmp'):
        aa = re.findall(r'cmp \$ts([\d]+),\$ts([\d]+)', line)
        print('cmp', aa)
        t = f'0b110100{bin(int(aa[0][0]))[2:].zfill(5)}{bin(int(aa[0][1]))[2:].zfill(5)}00000{bin(0)[2:].zfill(11)}'
    elif line.startswith('revs'):
        aa = re.findall(r'revs \$ts([\d]+),\$ts([\d]+)', line)
        print('revs', aa)
        t = f'0b11010100000{bin(int(aa[0][1]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(0)[2:].zfill(11)}'
    elif line.startswith('rnds'):
        aa = re.findall(r'rnds \$ts([\d]+),\$ts([\d]+)', line)
        print('rnds', aa)
        t = f'0b11011000000{bin(int(aa[0][1]))[2:].zfill(5)}{bin(int(aa[0][0]))[2:].zfill(5)}{bin(0)[2:].zfill(11)}'
    if line.startswith('syscall'):
        for i in range(0, 3):
            generated_mem += '00' + '\n'
        generated_mem += '0c' + '\n'
    else:
        if t != '':
            if t != bin(0)[2:0].zfill(32):
                t = hex(int(t, 2))[2:].zfill(8)
                for i in range(0, 4):
                    generated_mem += t[2 * i:2 * (i + 1)] + '\n'
            else:
                for i in range(0, 4):
                    generated_mem += '00' + '\n'

file.write(generated_mem)
