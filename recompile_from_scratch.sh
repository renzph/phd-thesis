#!/bin/bash

# Define the main LaTeX file name (without the .tex extension)
MAIN_TEX_FILE="main"

# List of auxiliary file extensions to delete
AUX_EXTENSIONS=("aux" "log" "out" "toc" "lof" "lot" "fls" "fdb_latexmk" "synctex.gz" "bbl" "blg" "nav" "snm" "vrb" "log" "run.xml" "bcf")

# Parse command line options
DELETE_ONLY=false
while getopts "d" opt; do
    case ${opt} in
        d )
            DELETE_ONLY=true
            ;;
        \? )
            echo "Usage: cmd [-d]"
            exit 1
            ;;
    esac
done

# Delete auxiliary files
for ext in "${AUX_EXTENSIONS[@]}"; do
    if [ -f "$MAIN_TEX_FILE.$ext" ]; then
        rm "$MAIN_TEX_FILE.$ext"
        echo "Deleted $MAIN_TEX_FILE.$ext"
    fi
done

# If the -d option is not provided, recompile the LaTeX document
if [ "$DELETE_ONLY" = false ]; then
    pdflatex "$MAIN_TEX_FILE.tex"
    biber "$MAIN_TEX_FILE" # Only if you are using BibTeX for bibliography
    pdflatex "$MAIN_TEX_FILE.tex"
    pdflatex "$MAIN_TEX_FILE.tex"

    echo "Recompilation completed."
else
    echo "Auxiliary files deleted. No recompilation performed."
fi
