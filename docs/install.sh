#!/bin/env sh

curl -sL "wess.io/overlook/check.sh" | bash || exit 1;

DIR=".overlook-tmp"
BOLD="$(tput bold)"
NORMAL="$(tput sgr0)"

rm -rf "$DIR"
mkdir -p "$DIR"
cd $DIR || exit 1

echo "Downloading..."
git clone https://github.com/wess/overlook.git overlook > /dev/null 2>&1
cd overlook || (echo "Failed to download!" && exit 1)

echo "Compiling..."
make clean
make release

echo "Installing..."
make install

cd ../../
rm -rf "$DIR"

echo "Complete. Use: ${BOLD}overlook help${NORMAL} and ${BOLD}overlook <command> help{$NORMAL} for more info."


