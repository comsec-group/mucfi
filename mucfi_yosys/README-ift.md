Dependencies for ubuntu:
sudo apt-get install clang tcl-dev libreadline-dev

To build:
make -j16 PREFIX=$HOME/prefix-cellift && make PREFIX=$HOME/prefix-cellift install
