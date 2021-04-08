#!/usr/bin/bash

if [ ! -f ${1} ]; then
    echo "the first argument must be a file"
    exit 1
fi
file=${1}

if [ -z "$2" ]; then
    echo "need outdir"
    exit 1
fi
outdir=${2}
mkdir -p $outdir
mkdir -p $outdir/log

nproc=1
if [ ! -z "$3" ]; then
    nproc=$3
fi
nproc=$(( nproc + 0 ))
ram=$(( nproc * 4 ))
disk=$(( nproc * 2 ))
if [ "$nproc" -le 0 ]; then
    echo "number of processes must be > 0"
    exit 1
fi

datalad="false"
if [ -n "$4" ]; then
    datalad=${4}
fi

CPUS=${nproc}
RAM="${ram}G"
DISK="${disk}G"
LOGS_DIR=$outdir/log

[ ! -d "${LOGS_DIR}" ] && mkdir -p "${LOGS_DIR}"
[ ! -d "${outdir}" ] && mkdir -p "${outdir}"

# print the .submit header
printf "# The environment
universe       = vanilla
getenv         = True
request_cpus   = ${CPUS}
request_memory = ${RAM}
request_disk   = ${DISK}

# Execution
initial_dir    = $(pwd)
executable     = $(pwd)/brainageR_juseless
\n"

printf "arguments = ${file} ${outdir} ${nproc} ${datalad}\n"
printf "log       = ${LOGS_DIR}/\$(Cluster).\$(Process).log\n"
printf "output    = ${LOGS_DIR}/\$(Cluster).\$(Process).out\n"
printf "error     = ${LOGS_DIR}/\$(Cluster).\$(Process).err\n"
printf "Queue\n\n"



