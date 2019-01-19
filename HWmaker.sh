#!/bin/bash

if [ $# -lt 2 ];
    then
    scriptname=`basename $0`
    echo "usage: $scriptname <weeknumber> <N>"
    echo "<weeknumber> is the week number (in the folder name)"
    echo "<N> is number of homeworks / exams to generate"
    echo ""
    echo "author: winter mason <m@winteram.com>"
    exit 1
else
    dno=$1
    nusers=$2
fi

for (( c=1; c<=$nusers; c++ ))
do
    string=`echo ""$RANDOM" "16" o p " | dc`
    cd Week$dno
    fname=`ls *.Rnw | cut -d'.' -f1`
    cp $fname.Rnw $fname\_$string.Rnw
    sed -i -e 's/UNIQUEKEY/'$string'/g' $fname\_$string.Rnw
    R CMD Sweave $fname\_$string.Rnw
    pdflatex -interaction nonstopmode $fname\_$string.tex
    pdflatex -interaction nonstopmode $fname\_$string.tex
    cp $fname\_$string.tex $fname\_$string\_key.tex
    sed -i -e 's/noprintanswers/printanswers/g' $fname\_$string\_key.tex
    pdflatex -interaction nonstopmode $fname\_$string\_key.tex
    pdflatex -interaction nonstopmode $fname\_$string\_key.tex
    [ -d HWs ] || mkdir HWs
    [ -d Keys ] || mkdir Keys
    mv $fname\_$string.pdf HWs
    mv $fname\_$string\_key.pdf Keys
    rm $fname\_$string*.*
    cd ..
done