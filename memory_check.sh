#!/bin/bash
usage() { echo "Usage: $0 [-c critical threshold(percentage)] [-w warning threshold(percentage)] [-e email]" 1>&2; exit 1; }

while getopts ":c:w:e:" o; do
    case "${o}" in
        c)
            c=${OPTARG}
            ;;
        w)
            w=${OPTARG}
            ;;
        e)
            e=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done

if [ -z "${c}" ] || [ -z "${w}" ] || [ -z "${e}" ]; then
    usage
elif ! [[ "$c" =~ ^[0-9]+$ ]]; then
    usage
elif ! [[ "$w" =~ ^[0-9]+$ ]]; then
    usage
elif [ $c -lt $w ]; then
    usage
fi

USED_MEMORY=$( free | grep Mem: | awk '{ print $3 }' )
TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }' )
a=`expr $USED_MEMORY \* $c`
CRITICAL_THRESHOLD=`expr $a / 100`
b=`expr $USED_MEMORY \* $w`
WARNING_THRESHOLD=`expr $b / 100`


if [ $USED_MEMORY -ge $CRITICAL_THRESHOLD ]; then
    echo "2"; exit
elif [ $USED_MEMORY -ge $WARNING_THRESHOLD ] && [ $USED_MEMORY -lt $CRITICAL_THRESHOLD ]; then
    echo "1"; exit
elif [ $USED_MEMORY -lt $WARNING_THRESHOLD ]; then
    echo "0"; exit
fi
