#! /bin/bash

# $Id: get_sources.sh 5237 2007-05-25 15:30:35Z zalila $

# Generates the ADA_SPECS_WITH_BODY, ADA_SPECS, ADA_BODIES and
# AADL_SOURCES variables. The AADL_SOURCES variable is generated only
# if there are actually AADL source files

# Has to be executed without parameter in a working directory.

# This script edits the Makefile.am located in the current directory
# and updates the values of the Ada and AADL sources names variables.

# Each Makefile that has to be edited must contain two marker line
# that encapsulate the part of the Makefile modified by this
# script. The first marker line must contain the string: "BEGIN: DO
# NOT DELETE THIS LINE" and the second "END: DO NOT DELETE THIS LINE".

work_dir=`pwd`;

# Find all Ada spec, Ada bodies and AADL source files

ada_specs_tmp=`find . -name "*.ads" | grep -v 'b~'`
ada_bodies_tmp=`find . -name "*.adb" | grep -v 'b~'`
aadl_sources_tmp=`find . -name "*.aadl"`

# Create temporary files

tmp_mk="./Makefile.am.$$"
ada_specs_with_body="./ada_specs_with_body.$$"
ada_specs_without_body="./ada_specs_without_body.$$"
ada_bodies_without_spec="./ada_bodies_without_spec.$$"
aadl_sources="./aadl_sources.$$"

ada_specs_with_body_f="./ada_specs_with_body_f.$$"
ada_specs_without_body_f="./ada_specs_without_body_f.$$"
ada_bodies_without_spec_f="./ada_bodies_without_spec_f.$$"
aadl_sources_f="./aadl_sources_f.$$"

cleanup () {
    rm -f ${tmp_mk}
    rm -f ${ada_specs_with_body}
    rm -f ${ada_specs_without_body}
    rm -f ${ada_bodies_without_spec}
    rm -f ${aadl_sources}
    rm -f ${ada_specs_with_body_f}
    rm -f ${ada_specs_without_body_f}
    rm -f ${ada_bodies_without_spec_f}
    rm -f ${aadl_sources_f}

    exit $1
}

rm -f ${tmp_mk};                    touch ${tmp_mk}

rm -f ${ada_specs_with_body};       touch ${ada_specs_with_body}
rm -f ${ada_specs_without_body};    touch ${ada_specs_without_body}
rm -f ${ada_bodies_without_spec};   touch ${ada_bodies_without_spec}
rm -f ${aadl_sources};              touch ${aadl_sources};

rm -f ${ada_specs_with_body_f};     touch ${ada_specs_with_body_f}
rm -f ${ada_specs_without_body_f};  touch ${ada_specs_without_body_f}
rm -f ${ada_bodies_without_spec_f}; touch ${ada_bodies_without_spec_f}
rm -f ${aadl_sources_f};            touch ${aadl_sources_f}; 


# Fill the different source cathegories

for i in ${ada_specs_tmp}; do
    body="`dirname ${i}`/`basename ${i} .ads`.adb"

    if [ -f ${body} ]; then
	echo "${i}" >> ${ada_specs_with_body}
    else
	echo "${i}" >> ${ada_specs_without_body}
    fi
done

for i in ${ada_bodies_tmp}; do
    spec="`dirname ${i}`/`basename ${i} .adb`.ads"

    if [ ! -f ${spec} ]; then
	echo "${i}" >> ${ada_bodies_without_spec}
    fi
done

for i in ${aadl_sources_tmp}; do
    echo "${i}" >> ${aadl_sources};
done

# Sort the sources alphabetically

ada_specs_with_body_sorted=`cat ${ada_specs_with_body} | sort`
ada_specs_without_body_sorted=`cat ${ada_specs_without_body} | sort`
ada_bodies_without_spec_sorted=`cat ${ada_bodies_without_spec} | sort`
aadl_sources_sorted=`cat ${aadl_sources} | sort`

# ADA_SPECS_WITH_BODY

echo -ne "ADA_SPECS_WITH_BODY =" > ${ada_specs_with_body_f}
for i in ${ada_specs_with_body_sorted} ; do
    echo -ne " \\\\\n	\$(srcdir)/${i}" | sed -e "s,\./,," >> ${ada_specs_with_body_f}
done
echo -e "\n" >> ${ada_specs_with_body_f}

# ADA_SPECS

echo -ne "ADA_SPECS = \$(ADA_SPECS_WITH_BODY)" > ${ada_specs_without_body_f}
for i in ${ada_specs_without_body_sorted} ; do
    echo -ne " \\\\\n	\$(srcdir)/${i}" | sed -e "s,\./,," >> ${ada_specs_without_body_f}
done
echo -e "\n" >> ${ada_specs_without_body_f}

# ADA_BODIES

echo -ne "ADA_BODIES = \$(ADA_SPECS_WITH_BODY:.ads=.adb)" > ${ada_bodies_without_spec_f}
for i in ${ada_bodies_without_spec_sorted} ; do
    echo -ne " \\\\\n	\$(srcdir)/${i}" | sed -e "s,\./,," >> ${ada_bodies_without_spec_f}
done
echo -e "\n" >> ${ada_bodies_without_spec_f}

# AADL_SOURCES

if test ! x"${aadl_sources_sorted}" = x""; then
    echo -ne "AADL_SOURCES =" > ${aadl_sources_f}
    for i in ${aadl_sources_sorted} ; do
	echo -ne " \\\\\n	\$(srcdir)/${i}" | sed -e "s,\./,," >> ${aadl_sources_f}
    done
    echo -e "\n" >> ${aadl_sources_f}
fi

# Edit the Makefile.am file

MAKEFILE="./Makefile.am"

if [ ! -f ${MAKEFILE} ]; then
    echo "${MAKEFILE}: file not found!";
    cleanup 1;
fi;

BEGIN_MSG="BEGIN: DO NOT DELETE THIS LINE"
END_MSG="END: DO NOT DELETE THIS LINE"

LINE_BEGIN=`cat ${MAKEFILE} | grep -n "${BEGIN_MSG}" | awk 'BEGIN{FS=":"}{print $1}'`;
LINE_END=`cat ${MAKEFILE} | grep -n "${END_MSG}" | awk 'BEGIN{FS=":"}{print $1}'`;

# Are all markers present?

if test x"${LINE_BEGIN}" = x"" -o x"${LINE_END}" = x""; then
    echo "${MAKEFILE}: file does not contain markers! => NOT EDITED";
    cleanup 0;
fi;

# Are markers consistent?

if test ${LINE_BEGIN} -gt ${LINE_END}; then
    echo "${MAKEFILE}: Unconsistent markers (END before BEGIN) => NOT EDITED";
    cleanup 1;
fi;

head -${LINE_BEGIN} ${MAKEFILE}  >> ${tmp_mk}
cat ${ada_specs_with_body_f}     >> ${tmp_mk}
cat ${ada_specs_without_body_f}  >> ${tmp_mk}
cat ${ada_bodies_without_spec_f} >> ${tmp_mk}
if test ! x"${aadl_sources_sorted}" = x""; then
    cat ${aadl_sources_f}            >> ${tmp_mk}
fi
tail -n +${LINE_END} ${MAKEFILE} >> ${tmp_mk}

cp -f ${tmp_mk} ${MAKEFILE}
echo "${MAKEFILE} Successfully edited!"

# Cleanup and quit

cleanup 0
