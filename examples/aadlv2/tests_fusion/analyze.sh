#!/bin/sh
# Launch boundt and size on the binaries

OCARINA=`which ocarina`
OCARINA_PATH=`dirname $OCARINA`
IN_FILE=$1

cp $OCARINA_PATH/../share/ocarina/assertions.txt .

ocarina -aadlv2 -g polyorb_hi_ada $IN_FILE.aadl

cd  ping_erc32/node_a/
make
cd ../..

ocarina -aadlv2 -g boundt $IN_FILE.aadl

pwd
ls ping_erc32/node_a/node_a
cp ping_erc32/node_a/node_a .

boundt_sparc -hrt -device=erc32 -assert assertions.txt node_a scenario.tpo 2> boundt_errors.log 1> boundt.log

tpo_gen -p $IN_FILE.aadl -o annotated_$IN_FILE.aadl

size node_a > memory_usage_$IN_FILE.txt
