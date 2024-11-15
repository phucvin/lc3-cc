cd ..

mkdir tmp01 && cd tmp01

sudo apt-get install build-essential

wget http://www.cs.colostate.edu/~fsieker/TestSemester/assignments/LC3CSU/lc3CSU.linux.tar

tar xvf lc3CSU.linux.tar

cd lc3CSU

make

cd /workspaces/lc3-cc/

virtualenv .

source bin/activate

pip3 install pycparser

export PATH="$(pwd)/tmp01/lc3CSU/:$PATH"

./compiler test/t01.c > test/t01.asm

cat test/t01.asm | ./lc3run