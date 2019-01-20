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

# For each student
for (( c=1; c<=$nusers; c++ ))
do
    # Create a random string for the homework
    string=`echo ""$RANDOM" "16" o p " | dc`

    # move to the folder
    cd Week$dno

    # Get the file name
    fname=`ls *.Rnw | cut -d'.' -f1`

    # Make a copy for the student
    cp $fname.Rnw $fname\_$string.Rnw

    # Replace the UNIQUEKEY with the random string
    sed -i -e 's/UNIQUEKEY/'$string'/g' $fname\_$string.Rnw

    # Run the R code to generate the tex files
    R CMD Sweave $fname\_$string.Rnw

    # Make the PDF
    pdflatex -interaction nonstopmode $fname\_$string.tex
    pdflatex -interaction nonstopmode $fname\_$string.tex

    # Make a copy for the anser key
    cp $fname\_$string.tex $fname\_$string\_key.tex

    # Modify script to show answers
    sed -i -e 's/noprintanswers/printanswers/g' $fname\_$string\_key.tex

    # Make the PDF
    pdflatex -interaction nonstopmode $fname\_$string\_key.tex
    pdflatex -interaction nonstopmode $fname\_$string\_key.tex
    
    # Clean up the file folder
    [ -d HWs ] || mkdir HWs
    [ -d Keys ] || mkdir Keys
    mv $fname\_$string.pdf HWs
    mv $fname\_$string\_key.pdf Keys
    rm $fname\_$string*.*
    cd ..
done