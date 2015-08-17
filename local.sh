#!/bin/bash
unlzs=./unlzs;

if [ $# -lt 1 ]; then
    echo -ne "\e[1;31m[-] Usage : $0 rom-0 \e0\n";
    exit 1;
fi
echo -ne "\e[0;32m[+] Decompressing rom-0...\e[0m\n";
rm -f /tmp/spt.dat;
dd if=$1 of=/tmp/spt.dat bs=1 skip=8552 count=39600 2>/dev/null;
rm -f /tmp/data;
dd if=/tmp/spt.dat of=/tmp/data bs=1 count=220 skip=16 2>/dev/null;
pass=`$unlzs /tmp/data | strings | head -n 1`;

echo -ne "\e[0;32m[+] Key Found: \e[1;32m${pass}\e[0m\n";
echo -ne "\e[0;32m[+] Finish :)\e[0m\n";

