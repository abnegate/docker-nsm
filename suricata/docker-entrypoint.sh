#!/usr/bin/env sh

OPTIONS=""

for interface in ${INTERFACES}; do
  OPTIONS="${OPTIONS}-i ${interface} "
done

/usr/local/bin/suricata -vvv ${OPTIONS}