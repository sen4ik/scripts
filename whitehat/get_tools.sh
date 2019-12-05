#!/bin/bash
cd ~/tools
if [ $? -ne 0 ]
then
    echo "~/tools directory doesn't exists. You might want to create it. Exiting."
    exit 1
fi

git clone https://github.com/tomnomnom/hacks.git
git clone https://github.com/aboul3la/Sublist3r.git
git clone https://github.com/s0md3v/Striker.git
git clone https://github.com/maurosoria/dirsearch.git
git clone https://github.com/jordanpotti/AWSBucketDump.git

# recon-ng needs python >= 3.6
git clone https://github.com/lanmaster53/recon-ng.git

# mysql is needed for patator
# python patator.py <module> -h
# https://en.kali.tools/?p=147
git clone https://github.com/lanjelot/patator.git

# make sure to install nodejs and npm - debian/nodejs_install.sh
# You might need to do following to install specific version packages for w3af to work
# pip install --upgrade futures==3.2.0
# pip install --upgrade lxml==3.4.4
# pip install --upgrade Jinja2==2.10
# pip install --upgrade Flask==0.10.1
# pip install --upgrade PyYAML==3.12
git clone https://github.com/andresriancho/w3af.git

# wfuzz needs some packages to work
sudo apt install -y libcurl4-openssl-dev libssl-dev
pip install wfuzz

pip install droopescan
