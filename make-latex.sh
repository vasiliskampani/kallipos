#!/bin/sh
#assemble and preprocess all the sources files

pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/pre.tex
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/intro.tex

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=vyew.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=footnote.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --wrap=none --to latex > latex/"$(basename "$filename" .txt).tex"
done

pandoc text/epi.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/epi.tex

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --citeproc --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"
done


#sed -i '' 's+Figure+Εικόνα+g' ./latex/ch0*
pandoc -s latex/*.tex -o book.tex
pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="Noto Sans Regular" --variable sansfont="Noto Sans Regular" --variable monofont="Noto Sans Regular" --variable fontsize=12pt --variable version=2.0 book.tex  --pdf-engine=xelatex --toc -o book.pdf
