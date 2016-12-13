#!/bin/sh

if [ $# -ne 3 ]
  then
    echo "Usage is $0 <page_numbers.pdf> <original.pdf> <merged.pdf>"
    exit 1
fi

PAGENUMBERSFILE=$1
PDFFILE=$2
OUTPUT=$3
# put work on temporary folder
mkdir -p tmp
cp $PAGENUMBERSFILE tmp/.
cp $PDFFILE tmp/.
cd tmp/

# burst PDFFILE into its component pages and get total number of pages
pdftk $PDFFILE burst output in_%04d.pdf 
cat doc_data.txt | grep NumberOfPages > page_count.txt
count=`mawk '{print $2}' page_count.txt`
echo "HAS "$count" pages"

# burst the page number file into its component pages
pdftk $PAGENUMBERSFILE burst output pager_%04d.pdf 

# no page number on the first page
#cp in_0001.pdf out_0001.pdf

# initialize start page x
x=1 

# place the page numbers on each page of the original pdf as background
while [ "$x" -le "$count" ]; do
    #get prefix for numbers
    PREFIX=""
    if [ "$x" -lt 10 ]; then
        PREFIX="000"
    elif [ "$x" -lt 100 ]; then
        PREFIX="00"
    elif [ "$x" -lt 1000 ]; then
        PREFIX="0"
    fi
    pdftk in_"$PREFIX""$x".pdf background pager_"$PREFIX""$x".pdf output out_"$PREFIX""$x".pdf
    echo "Page $x/$count [DONE]"
    x=$(($x+1)) #next page
done


# create the new PDF file and move it to the original directory
pdftk  out_*.pdf cat output $OUTPUT
mv $OUTPUT ../.

# delete tmp directory
cd ..
rm -r tmp
exit