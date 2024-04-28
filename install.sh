#!/bin/bash

PROGRAMNAME=""
DEVELOPERNAME=""
SHORTPROGRAMNAME=""

install_python_mac () {
  if ! command -v brew > /dev/null; then
    echo "[x] Brew package manager not installed."
    exit 1
  fi

  brew list | grep "python@3.*" > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "[*] Installing the python interpreter on the system..."
    if ! brew install -y "python3" > /dev/null 2>&1; then
      echo "[x] Cannot install the python interpreter via brew."
      exit 1
    fi
  else
    echo "[*] The python interpreter is already installed."
  fi
}

install_python_linux () {
  if [ "$EUID" -ne 0 ]
    then echo "[x] Root privileges required!"
    exit 1
  fi

  if command -v apt-get > /dev/null; then
    install_python_apt
  elif command -v yum > /dev/null; then
    install_python_yum
  else
    echo "[x] Neither apt nor yum found as package manager."
    exit 1
  fi
}

install_python_apt () {
  if [ $(dpkg-query -W -f='${Status}' python3 > /dev/null 2>&1 | grep -c "ok installed") -eq 0 ]; then
    echo "[*] Installing the python interpreter on the system..."
    apt update > /dev/null 2>&1;
    apt install python3 > /dev/null 2>&1;
  fi
}

install_python_yum () {
  if ! yum list installed python3 &>/dev/null; then
    echo "[*] Installing the python interpreter on the system..."
    yum install -y python3 > /dev/null 2>&1;
  fi
}

check_init_variables () {
  if [ -z "$PROGRAMNAME" ]; then
    echo "[x] The PROGRAMNAME variable is empty. Please configure the script before running it."
    exit 2
  fi

  if [ -z "$DEVELOPERNAME" ]; then
    echo "[x] The DEVELOPERNAME variable is empty. Please configure the script before running it."
    exit 2
  fi

  if [ -z "$SHORTPROGRAMNAME" ]; then
    echo "[x] The SHORTPROGRAMNAME variable is empty. Please configure the script before running it."
    exit 2
  fi
}

create_directory () {
  if [ -w /opt ]; then
    mkdir /opt/$SHORTPROGRAMNAME > /dev/null 2>&1;
  else
    sudo mkdir /opt/$SHORTPROGRAMNAME > /dev/null 2>&1;
  fi
}

copy_script () {
  if [ -w /opt/$SHORTPROGRAMNAME ]; then
    cp src/$SHORTPROGRAMNAME.py /opt/$SHORTPROGRAMNAME/$SHORTPROGRAMNAME.py > /dev/null 2>&1;
  else
    sudo cp src/$SHORTPROGRAMNAME.py /opt/$SHORTPROGRAMNAME/$SHORTPROGRAMNAME.py > /dev/null 2>&1;
    sudo chmod 005 /opt/$SHORTPROGRAMNAME/$SHORTPROGRAMNAME.py
  fi
}

link_executable () {
  if [ $(id -u) != 0 ]; then
    sudo ln -s /opt/$SHORTPROGRAMNAME/$SHORTPROGRAMNAME.py /usr/bin/$SHORTPROGRAMNAME > /dev/null 2>&1;
  else
    ln -s /opt/$SHORTPROGRAMNAME/$SHORTPROGRAMNAME.py /usr/bin/$SHORTPROGRAMNAME > /dev/null 2>&1;
  fi
}

### MAIN #################################################################################

check_init_variables

echo "Welcome to the $PROGRAMNAME installer

By using this software you must agree all below terms:
    1) By using this software, it's the end user's responsibility to obey all applicable local, state and federal laws.
    2) The software is provided \"as is\", without warranty of any kind, express or implied.
    3) $DEVELOPERNAME isn't responsible for any damage caused by this software.

[?] If you agree, press [Enter] to procede..."
read junk

if [ "$(uname)" == "Darwin" ]; then
  install_python_mac
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  install_python_linux
else
  echo "[x] Only MacOS and Linux operating system are supported."
  exit 1
fi

echo "[*] Installing python requirements..."
pip3 install -r requirements.txt > /dev/null 2>&1;

if [ -d /opt/$SHORTPROGRAMNAME ]; then
  echo "[*] The software seems already installed."
  exit 0
fi

echo "[*] Installing the software..."
create_directory
copy_script

echo "[*] Linking the executable..."
link_executable

echo ""
echo "[v] Successfully installed $PROGRAMNAME in your system!";
