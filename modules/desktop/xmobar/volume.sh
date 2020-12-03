#!/bin/sh
volume=`pactl list sinks | grep '^[[:space:]]Volume:' | \
    head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
`
bars=`expr $volume / 10`

case $bars in
  0)  bar='[----------]' ;;
  1)  bar='[>---------]' ;;
  2)  bar='[>>--------]' ;;
  3)  bar='[>>>-------]' ;;
  4)  bar='[>>>>------]' ;;
  5)  bar='[>>>>>-----]' ;;
  6)  bar='[>>>>>>----]' ;;
  7)  bar='[>>>>>>>---]' ;;
  8)  bar='[>>>>>>>>--]' ;;
  9)  bar='[>>>>>>>>>-]' ;;
  10) bar='[>>>>>>>>>>]' ;;
  *)  bar='[----!!----]' ;;
esac

echo $bar

exit 0
