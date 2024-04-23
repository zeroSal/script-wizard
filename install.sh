#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "[x] Root privileges required!"
  exit
fi

PROGRAMNAME=""
DEVELOPERNAME=""
SHORTPROGRAMNAME=""

echo "Welcome to the $PROGRAMNAME installer

By using this software you must agree all below terms:
    1) Usage of this tools for attacking targets without prior mutual consent is illegal.
    2) By using this software, it's the end user’s responsibility to obey all applicable local, state and federal laws.
    3) $DEVELOPERNAME isn't responsible for any damage caused by this software.

[?] If you agree, press [Enter] to procede:"
read junk

# TODO: Implement non-APT environment installation
if [ $(dpkg-query -W -f='${Status}' python3 > /dev/null 2>&1 | grep -c "ok installed") -eq 0 ]; then
	# Python3 not installed on the system, just install it!
    echo "[*] Installing python interpreter on the system..."
	apt update > /dev/null 2>&1;
	apt install python3 > /dev/null 2>&1;
fi

# Install python requirements
echo "[*] Installing python requirements..."
pip3 install -r requirements.txt > /dev/null 2>&1;

# Install the script in the opt directory
echo "[*] Installing the software..."
mkdir /opt/$SHORTPROGRAMNAME > /dev/null 2>&1;
cp src/$SHORTPROGRAMNAME.py /opt/$SHORTPROGRAMNAME > /dev/null 2>&1;
chmod +x /opt/$SHORTPROGRAMNAME/$SHORTPROGRAMNAME.py > /dev/null 2>&1;

# Create the command for the shell
echo "[*] Setting up the environment..."
ln -s /opt/$SHORTPROGRAMNAME/$SHORTPROGRAMNAME.py /usr/bin/$SHORTPROGRAMNAME > /dev/null 2>&1;

echo ""
echo "[v] Successfully installed $PROGRAMNAME in your system!";
