#!/bin/sh
# usage: ./run_step.sh 01_import [jenner-binary]
cd "$(dirname "$0")"
export PUMPKIN_ROOT="$(pwd)" JENNER_UNLIMITED=1
J="${2:-${JENNER:-jenner}}"
printf '%%include "%s/config/settings.sas";\n%%include "%s/sas/%s.sas";\n' "$PUMPKIN_ROOT" "$PUMPKIN_ROOT" "$1" > "logs/_$1.sas"
"$J" "logs/_$1.sas" -log "logs/$1.log" -print "output/tables/$1.lst"
echo "exit=$?"
