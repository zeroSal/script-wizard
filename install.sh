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
    1) By using this software, it's the end user’s responsibility to obey all applicable local, state and federal laws.
    2) The software is provided \"as is\", without warranty of any kind, express or implied.
    3) $DEVELOPERNAME isn't responsible for any damage caused by this software.

[?] If you agree, press [Enter] to procede:"
read junk

if [ "$(uname)" == "Darwin" ]; then
  install_python_mac()
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  install_python_linux()
else
  echo "[x] Only MacOS and Linux operating system are supported."
fi

install_python_mac () {
  if ! command -v brew >/dev/null; then
    echo "[x] Brew package manager not installed."
  fi

  if ! brew list -1 | grep -q "python@3"; then
    echo "[*] Installing python interpreter on the system..."
    if ! brew install -y "python3" > /dev/null 2>&1; then
      echo "[x] Cannot install python via brew."
    fi
  fi
}

install_python_linux () {
  if command -v apt-get >/dev/null; then
    install_python_apt()
  elif command -v yum >/dev/null; then
    install_python_yum()
  else
    echo "[x] Neither apt not yum found as package manager."
    exit
  fi
}

install_python_apt () {
  if [ $(dpkg-query -W -f='${Status}' python3 > /dev/null 2>&1 | grep -c "ok installed") -eq 0 ]; then
    # Python3 not installed on the system, just install it!
    echo "[*] Installing python interpreter on the system..."
    apt update > /dev/null 2>&1;
    apt install python3 > /dev/null 2>&1;
  fi
}

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
