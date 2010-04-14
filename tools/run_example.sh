#! /bin/sh

# $Id: run_example.sh 5428 2008-10-05 17:44:02Z zalila $

# This script is a shortcut to run a given PolyORB-HI example

# Its argument is the root directory generated for the example

if [ $# -lt 1 ]; then
    echo "Usage $0 <generated_example_directory> [-r]"
    echo "  -r : run the node in reverse (alphabetical) order"
    exit 1;
fi

sample_dir=$1

if test x"$2" = x"-r"; then
    reverse=true;
else
    reverse=false;
fi

if test ! -d ${sample_dir}; then
    echo "${sample_dir} is not a directory";
    exit 2;
fi;

cd ${sample_dir}

# Get the executables

find . -name '*' -perm -u+x -type f \
    -a ! -name '*.o'  -a ! -name '*.ali' \
    -a ! -name '*.ad?' -a ! -name '*.c' -a ! -name '*.h' \
    -a ! -name '*.gpr'  -a ! -name 'Makefile*' > NODES.tmp

if test ${reverse} = "true"; then
    cat NODES.tmp | sort -r > NODES.tmp_2
else
    cat NODES.tmp > NODES.tmp_2
fi

nodes=`cat NODES.tmp_2`
rm NODES.tmp_2 

# Run the nodes

for node in ${nodes}; do
    # Fetch the platform of ${node}

    tmp=`nm ${node} | grep leonbare`;
    
    if test ! x"${tmp}" = x""; then
	target=leon
    else
	tmp=`nm ${node} | grep system__bb__`;

	if test ! x"${tmp}" = x""; then
	    target=erc32
	else
	    target=native
	fi
    fi

    echo "* TARGET = ${target}"
    echo "* running node: ${node}"

    case $target in
	"native")
	    xterm -e "${node}"&
	    sleep 1;;
	"leon")
	    echo "go" | tsim-leon "${node}";;
	"erc32")
	    echo "go" | tsim-erc32 "${node}";;
    esac
done
