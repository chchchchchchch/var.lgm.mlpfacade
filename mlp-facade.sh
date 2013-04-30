#!/bin/bash

CANVAS=canvas.html
SLOGANS=slogans.txt

ADDBROWSERS="moz ms o"


CSSMOVE=move_bubbles.css
STEPPX=220


# FUNCTIONS ----------------------------------------------------- #

e ()          { echo $1 >> $OUT ;  }


# --------------------------------------------------------------- #
# START MAIN HTML
# --------------------------------------------------------------- #

  rm $CANVAS $CSSMOVE

# --------------------------------------------------------------- #
  OUT=$CANVAS

  e "<html>"
  e "<head>"
  e "<style>"
  e "@import 'static.css';"
  e "@import 'move_bubbles.css';"
  e "@import 'move_head.css';"
  e "@import 'move_legs.css';"
  e "@import 'move_upperbody.css';"
   for BROWSER in $ADDBROWSERS
    do
       e "@import '"${BROWSER}".css'"
   done
  e "</style>"
  e "</head>"
  e "<body>"


  e "<div class='bubblecontainer'"
  e "     style='width: 120000px;
    '>"
# --------------------------------------------------------------- #

# --------------------------------------------------------------- #
# WRITE BUBBLE LOOP
# --------------------------------------------------------------- #

  SLOGANNUM=`cat $SLOGANS | wc -l`
  TRANSITIONFRAMES=10
  STAYFRAMES=`expr 10000 - $TRANSITIONFRAMES \* $SLOGANNUM`
  STAYFRAMES=`expr $STAYFRAMES \/ $SLOGANNUM`

  POSPX=0
  ANIMATIONFRAME=0

  OUT=$CSSMOVE

  e "@-webkit-keyframes move_bubbles { "

# --------------------------------------------------------------- #

CNT=1
for SLOGAN in `cat $SLOGANS | sed 's/ /FGDTR/g'`;
 do
  # ------------------------------------------------------------- #
    OUT=$CANVAS
    e "<div class='bubble'>"
    e "`echo $SLOGAN | sed 's/FGDTR/ /g'`"
    e "</div>"
  # ------------------------------------------------------------- #
    OUT=$CSSMOVE
    FRAMEPAD=`echo 00000$ANIMATIONFRAME | rev | cut -c 1-5 | rev `
    AFFLOAT=`echo $FRAMEPAD | cut -c 1-3 |\
             sed 's/^[0]*//g'`.`echo $FRAMEPAD | cut -c 4-5`
    e  "${AFFLOAT}% {-webkit-transform: translate(${POSPX}px,0px);}"
    ANIMATIONFRAME=`expr $ANIMATIONFRAME + $TRANSITIONFRAMES`
    if [ $CNT -gt 1 ];then
    POSPX=`expr $POSPX - $STEPPX`
    FRAMEPAD=`echo 00000$ANIMATIONFRAME | rev | cut -c 1-5 | rev `
    AFFLOAT=`echo $FRAMEPAD | cut -c 1-3 |\
             sed 's/^[0]*//g'`.`echo $FRAMEPAD | cut -c 4-5`
    e  "${AFFLOAT}% {-webkit-transform: translate(${POSPX}px,0px);}"
    fi
    ANIMATIONFRAME=`expr $ANIMATIONFRAME + $STAYFRAMES`
    CNT=`expr $CNT + 1`
done

OUT=$CSSMOVE
e  "100% {-webkit-transform: translate(${POSPX}px,0px);}"
e " }"
OUT=$CANVAS
e "</div>"





ILLUSTRATIONPARTS=illustration_parts
STEPPX=192

# --------------------------------------------------------------- #
# WRITE ILLUSTRATION PART LOOPS
# --------------------------------------------------------------- #

for TYPE in head legs upperbody
 do

#TYPE=head

CSSMOVE=move_${TYPE}.css

# RESET
  POSPX=0
  ANIMATIONFRAME=0
  rm $CSSMOVE


PARTNUM=`ls $ILLUSTRATIONPARTS/*.svg | grep ${TYPE}- | wc -l`

TRANSITIONFRAMES=`expr 10000 \/ $PARTNUM \/ $((RANDOM%10 + 10))`;
#TRANSITIONFRAMES=1
STAYFRAMES=`expr 10000 - $TRANSITIONFRAMES \* $PARTNUM`
STAYFRAMES=`expr $STAYFRAMES \/ $PARTNUM`

DURATION=`expr $PARTNUM \* 10`

OUT=$CANVAS
e "<div class='illucontainer' "
e "     style='width: 4000px;"
e "   -webkit-animation: move_$TYPE ${DURATION}s infinite ease-in-out;"
e "   -webkit-animation-direction:alternate;"

   for BROWSER in $ADDBROWSERS
    do
e "   -${BROWSER}-animation: move_$TYPE ${DURATION}s infinite ease-in-out;"
e "   -${BROWSER}-animation-direction:alternate;"
   done

e "'>"


OUT=$CSSMOVE
e "@-webkit-keyframes move_$TYPE { "


CNT=1
for PART in `ls $ILLUSTRATIONPARTS/*.svg | \
             grep ${TYPE}-`
 do
  # ------------------------------------------------------------- #
    OUT=$CANVAS
    e "<div class='illu' "
    e "style='background: url($PART);'>"
    e "</div>"
  # ------------------------------------------------------------- #
    OUT=$CSSMOVE
    FRAMEPAD=`echo 00000$ANIMATIONFRAME | rev | cut -c 1-5 | rev `
    AFFLOAT=`echo $FRAMEPAD | cut -c 1-3 |\
             sed 's/^[0]*//g'`.`echo $FRAMEPAD | cut -c 4-5`
    e  "${AFFLOAT}% {-webkit-transform: translate(${POSPX}px,0px);}"
    ANIMATIONFRAME=`expr $ANIMATIONFRAME + $TRANSITIONFRAMES`
    if [ $CNT -gt 1 ];then
    POSPX=`expr $POSPX - $STEPPX`
    FRAMEPAD=`echo 00000$ANIMATIONFRAME | rev | cut -c 1-5 | rev `
    AFFLOAT=`echo $FRAMEPAD | cut -c 1-3 |\
             sed 's/^[0]*//g'`.`echo $FRAMEPAD | cut -c 4-5`
    e  "${AFFLOAT}% {-webkit-transform: translate(${POSPX}px,0px);}"
    fi
    ANIMATIONFRAME=`expr $ANIMATIONFRAME + $STAYFRAMES`
    CNT=`expr $CNT + 1`
done

OUT=$CSSMOVE
e  "100% {-webkit-transform: translate(${POSPX}px,0px);}"
e " }"

OUT=$CANVAS
e "</div>"

done


OUT=$CANVAS
e "<div class='canvas'></div>"
e "</body>"
e "</html>"


for BROWSER in $ADDBROWSERS
 do
    rm ${BROWSER}.css
    sed "s/webkit/$BROWSER/g" `ls *.css | grep -v static.css` >> ${BROWSER}.css
done




exit 0;



