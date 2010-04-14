#! /bin/sh

# $Id: generate_ada.sh 5253 2007-06-07 15:04:01Z hugues $

# Wrapper script to exploit and AADL scenario to
# - generate Ada code and build utils (makefiles, project files...),
# - compile the generated code,
# - perform several checks on it
# - run the application (if the user did not request the opposite by
#   mean of the --no-run option)

# This script takes a scenario file which contains the list of the
# AADL files to be handled.

# Syntax of a scenario file :
# - The first line of the scenario file contains the system
#   implementation name.
# - The second line of the scenario contains the target, either native
#   or leon or erc32.
# - The third line of the scenario file contains the list of the
#   application nodes in the order in which they should be launched.
# - Other lines are the user AADL (*.aadl) files used
# - The scenario file has to be in the same directory of the AADL models
#   and the Ada source files.

###############################################################################
# Recall usage of this script

usage () {
   echo "Usage: $0 [options] <scenario_file>";
   echo "  NO_OPTION | --all-stages: Perform all steps and run the"
   echo "    application"
   echo "  --no-run: Perform all steps except the running of the"
   echo "    application"
   echo "  --sched-only: Only perform schedulability analysis"
   echo "  --parse-only: Only parse the AADL model"
   echo "  --help: displays this help message"
   exit 1;
}

###############################################################################
# Scan the command line

scan_command_line () {
    option_set=false
    
    while test $# -gt 0; do
	case "$1" in
	    --all-stages)
		all_stages=true
		option_set=true
		;;
	    --no-run)
		no_run=true
		option_set=true
		;;
	    --sched-only)
		sched_only=true
		option_set=true
		;;
	    --parse-only)
		parse_only=true
		option_set=true
		;;
	    --help | -*)
		usage
		;;
	    *)
		if test x${scenario_file} = x""; then
		    scenario_file=$1;
		else
		    echo "Scenario file already given"
		    usage;
		fi
		;;
	esac
	shift
    done

    if test x${scenario_file} = x""; then
	echo "Scenario file not given"
	usage;
    fi

    if test x${option_set} = x"false"; then
	all_stages=true
    fi
}

###############################################################################
# Parse the scenario

parse_aadl () {
    log_file=parse_$scenario_file.out

    echo
    echo "*** Parsing the AADL description ***"
    echo

    ocarina -e \
	$aadl_files $POLYORB_HI_PATH/share/cheddar/Cheddar_Properties.aadl \
	$POLYORB_HI_PATH/share/ocarina/arao.aadl \
	$target_characteristics > $log_dir/$log_file 2>&1

    a=$?
    if [ $a != 0 ]; then
	echo "error" log in $log_dir/$log_file
	exit $a
    else
	echo [OK] log in $log_dir/$log_file
    fi
}

###############################################################################
# Generate Ada code from the scenario

generate_ada () {
    log_file=aadl_ada_$scenario_file.out

    echo
    echo "*** Generating source code from the AADL description ***"
    echo

    ocarina -g PolyORB-HI-Ada \
	$aadl_files $POLYORB_HI_PATH/share/cheddar/Cheddar_Properties.aadl \
	$target_characteristics > $log_dir/$log_file 2>&1

    a=$?
    if [ $a != 0 ]; then
	echo "error" log in $log_dir/$log_file
	exit $a
    else
	echo [OK] log in $log_dir/$log_file
    fi
}

###############################################################################
# Generate DIA figure from the scenario

generate_dia () {
    log_file=aadl_dia_$scenario_file.out

    echo
    echo "*** Generating EPS figure from the AADL description ***"
    echo

    mkdir $result_dir/fig

    ocarina -p dia \
	$aadl_files $POLYORB_HI_PATH/share/cheddar/Cheddar_Properties.aadl \
	$POLYORB_HI_PATH/share/ocarina/arao.aadl \
	$target_characteristics -o $result_dir/fig/$scenario_file.dia \
	> $log_dir/$log_file 2>&1

    a=$?
    if [ $a != 0 ]; then
	echo "error (ignored)" log in $log_dir/$log_file
    fi

    dia --nosplash -e $result_dir/fig/$scenario_file.eps \
	$result_dir/fig/$scenario_file.dia 2> /dev/null
    a=$?
    if [ $a != 0 ]; then
	echo "error (ignored)" log in $log_dir/$log_file
    else
	echo [OK] log in $log_dir/$log_file
    fi
}


###############################################################################
# Generate Petri nets from the scenario

generate_petri_net () {
    log_file=aadl_pn_$scenario_file.out

    echo
    echo "*** Generating Petriscript from the AADL description ***"
    echo

    ocarina -n \
	$aadl_files $POLYORB_HI_PATH/share/cheddar/Cheddar_Properties.aadl \
	$target_characteristics > $log_dir/$log_file 2>&1

    a=$?
    if [ $a != 0 ]; then
	echo "error" log in $log_dir/$log_file
	exit $a
    else
	echo [OK] log in $log_dir/$log_file
    fi

    # Add files for behavioural specifications

    cp "`ocarina -s`/user_defined.psc" "$result_dir"

    # Add behavioural specifications

    cd $source_dir
    for behave_file in `ls *.psc`; do
        tmp=`echo $behave_file | cut -f1 -d'.'` &&
        echo $work_dir/$result_dir
        cp $behave_file $work_dir/$result_dir/$tmp;
    done;

    mkdir -p $result_dir/pn
    mv partition.psc $result_dir/pn
    cd $result_dir/pn
    pn_include partition.psc &&

    # Calling the PetriScript-to-CAMI wrapper

    new_modular_services -s -fromscratch \
	-petriscript generated_final.psc \
	-store pn.cami >> ../log/$log_file

    rm -f New_modular_services.* tmp_change_storage.* \
	program_processed.petriscript FK_groups

    partition -m pn.cami 2> /dev/null >> ../log/$log_file
    mv model.def pn.def >> ../log/$log_file
    mv model.net pn.net >> ../log/$log_file

    echo
    echo "*** Building SRG of Petri nets ***"
    echo

    log_file=pn_srg_$scenario_file.out

    # Building Symbolic Reachability Graph from model

#    WNSRG pn >> ../log/$log_file
    cd ../..
    echo [OK] log in $log_dir/$log_file

}

###############################################################################
# For each call (#include primitive) to a user defined behavioural spec,
# will build a new instance of behavioural spec, and merge it with main
# generated script.

pn_include () {

    if [ $# -ne 1 ]; then
	echo "usage : $0 main_file"
	exit 1
    fi

    SRC_INC=$1
    TMP_INC=$SRC_INC.tmp

    touch $TMP_INC

    echo "-------------------------------------------------------" >> $TMP_INC
    echo "--                include part                       --" >> $TMP_INC
    echo "--  automatically generated by the 'include' script  --" >> $TMP_INC
    echo "-------------------------------------------------------" >> $TMP_INC

    while read cmd arg1 arg2 next;
      do
      if [ "$cmd" = "#include" ];
	  then
	  if [ -e $arg2 ];
	      then
	      pn_namespace $arg1 $arg2 &&
	      cat $arg1'_'$arg2 >> $TMP_INC
	  fi;
      fi;
    done < $SRC_INC &&

    echo "-------------------------------------------------------" >> $TMP_INC
    echo "--                generated part                     --" >> $TMP_INC
    echo "-------------------------------------------------------" >> $TMP_INC

    echo "" >> $TMP_INC

    cat $SRC_INC >> $TMP_INC

    echo "-------------------------------------------------------" >> $TMP_INC
    echo "--                merging part                       --" >> $TMP_INC
    echo "--  automatically generated by the 'include' script  --" >> $TMP_INC
    echo "-------------------------------------------------------" >> $TMP_INC

    echo "" >> $TMP_INC

    while read cmd arg1 arg2 next;
      do
      if [ "$cmd" = "#include" ];
	  then
	  if [ -e $arg2 ];
	      then
	      rm -f $TMP_INC.tmp &&
	      pn_merge $arg1 $SRC_INC $arg2 $TMP_INC.tmp &&
	      cat $TMP_INC.tmp >> $TMP_INC
	  fi;
      fi;
    done < $SRC_INC &&

    # comment all include calls

    cat $TMP_INC | sed s/"#include"/"-- include"/g > $TMP_INC.tmp
    cat $TMP_INC.tmp > $TMP_INC

    rm -f $TMP_INC.tmp;

    mv $TMP_INC generated_final.psc

}

###############################################################################
# For a given call to a user defined behavioural spec, merge all external
# nodes with corresponding nodes in the generated file.

pn_merge () {

    if [ $# -ne 4 ];
	then
	echo "usage : $0 namespace_str generated_file user_defined_file dest_file"
	exit 1
    fi

    NS_MERGE=$1'_'
    SRC_GEN=$2
    SRC_USR=$3
    TMP_MERGE=$4

    # for each node refered by the User defined file, we
    # put them into the corresponding list

    for var in `grep "append place *" $SRC_USR | cut -f2 -d'"' | cut -f1 -d' ' | sed 's/\("$NS_MERGE"\)\([a-z][a-z0-9_]*\)/\2/'`;
      do
      echo "merge place "'"'"$var"'"'" and place " '"'"$NS_MERGE$var"'";' >> $TMP_MERGE
    done &&

    echo -e "\n" >> $TMP_MERGE

    for var in `grep "append transition *" $SRC_USR | cut -f2 -d'"' | cut -f1 -d' ' | sed 's/\("$NS_MERGE"\)\([a-z][a-z0-9_]*\)/\2/'`;
      do
      echo "merge transition "'"'"$var"'"'" and transition " '"'"$NS_MERGE$var"'";' >> $TMP_MERGE
    done

}

###############################################################################
# Schedulability analysis of the scenario

schedulability_analysis () {
    log_file=scheduling_$scenario_file.out

    echo
    echo "*** Schedulability analysis using Cheddar ***"
    echo

    cheddar_analyzer $aadl_files \
	$POLYORB_HI_PATH/share/ocarina/arao.aadl \
	$POLYORB_HI_PATH/share/ocarina/aadl_project.aadl \
	$POLYORB_HI_PATH/share/ocarina/aadl_properties.aadl \
	$POLYORB_HI_PATH/share/cheddar/Cheddar_Properties.aadl \
	$target_characteristics  > $log_dir/$log_file 2>&1

    a=$?
    if [ $a != 0 ]; then
	echo "error" log in $log_dir/$log_file
    else
	echo [OK] log in $log_dir/$log_file
    fi
}

###############################################################################
# Compiling each node

compile_nodes () {
    echo
    echo "*** Compiling nodes ***"

    OLD_IFS=$IFS
    IFS=' '

    for node in $nodes; do
	log_file=compil_$node.out

	echo
	echo "* compiling node: $node"
	cd $result_dir/$node
	make > ../log/$log_file 2>&1
	a=$?
	if [ $a != 0 ]; then
	    echo "error" log in $log_dir/$log_file
	    exit $a
	else
	    echo [OK] log in $log_dir/$log_file
	fi
	cd ../..
    done
    IFS=$OLD_IFS
}

###############################################################################
# Checking each node

check_nodes () {
    echo
    echo "*** Checking nodes ***"

    OLD_IFS=$IFS
    IFS=' '

    for node in $nodes; do
	log_file=check_$node.out

	echo
	echo "* checking node: $node"
	cd $result_dir/$node
	make check > ../log/$log_file 2>&1
	echo [OK] log in $log_dir/$log_file
	cd ../..
    done
    IFS=$OLD_IFS
}

###############################################################################
# Metrics for each node

metrics_nodes () {
    echo
    echo "*** Computing metrics for each node ***"

    OLD_IFS=$IFS
    IFS=' '

    for node in $nodes; do
	log_file=metrics_$node.out

	echo
	echo "* computing metrics for node: $node"
	cd $result_dir/$node
	gnat metric  > ../log/$log_file 2>&1
	echo [OK] log in $log_dir/$log_file
	cd ../..
    done
    IFS=$OLD_IFS
}

###############################################################################
# Run each node

run_nodes () {
    echo
    echo "*** Running nodes ***"
    echo

    OLD_IFS=$IFS
    IFS=' '

    for node in $nodes; do
	echo "* running node: $node"
	case $target in
	    "native")
		xterm -e "$result_dir/$node/$node"&
		sleep 1;;
	    "leon")
		echo "go" | tsim-leon "$result_dir/$node/$node";;
	    "erc32")
		echo "go" | tsim-erc32 "$result_dir/$node/$node";;
	esac
    done
    IFS=$OLD_IFS
}

###############################################################################
# Parse scenario file

parse_scenario () {
    result_dir="`head -1 $scenario_file`"

    # Remove former generated code

    rm -rf $result_dir
    mkdir $result_dir

    log_dir=$result_dir/log
    mkdir $log_dir

    # Get absolute paths of the source and work directories

    work_dir=`pwd`

    source_dir=`dirname $scenario_file`
    cd $source_dir
    source_dir=`pwd`

    cd $work_dir

    # Get the target

    target=`head -2 $scenario_file | tail -1`

    # Get the target property AADL file

    share_location=$POLYORB_HI_PATH/share/ocarina

    case "$target" in
	"native")
	    target_characteristics=$share_location/native_characteristics.aadl
	    ;;
	"leon"|"erc32")
	    target_characteristics=$share_location/leon_characteristics.aadl
	    ;;
	*)
	    echo "error : unknown traget $target in scenario file"
	    exit 2
	    ;;
    esac

    # Get the list of nodes

    nodes=`head -3 $scenario_file | tail -1`
    n_nodes=` echo $nodes | wc -w`

    # Get the files to be handled

    aadl_files=
    for i in `tail -n +4 $scenario_file | grep aadl$`; do
	aadl_files="$aadl_files $source_dir/$i"
    done
}

###############################################################################
# Main processing begins here

# Parse commande line

all_stages=false
no_run=false
sched_only=false
parse_only=false
scenario_file=""

scan_command_line $@

echo
echo "**********************************************************************"
echo "Ocarina AADL tool collection, (c) ENST"
echo "**********************************************************************"
echo
echo Processing file: $scenario_file

parse_scenario

if test x${all_stages} = x"true" -o x${no_run} = x"true" ; then
    parse_aadl
    #generate_dia
    schedulability_analysis
    #generate_petri_net
    generate_ada
    compile_nodes
    check_nodes
    metrics_nodes
    if test x${no_run} = x"false" ; then
	run_nodes
    fi
elif test x${sched_only} = x"true"; then
    schedulability_analysis
elif test x${parse_only} = x"true"; then
    parse_aadl
fi;

echo
echo "**********************************************************************"
