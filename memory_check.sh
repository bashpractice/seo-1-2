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
