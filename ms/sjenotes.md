# To compile

For unicode/math bits, we currently need

     \setromanfont{TeX Gyre Pagella}'

so we need to load the font using [this link](https://groups.google.com/forum/?fromgroups#!topic/pandoc-discuss/urzu6dQU_R4)

these fonts can be installed using:

    tlmgr install tex-gyre

I have moved the org-preamble-xelatex.sty into the same directory as
the .tex for convenience.

    make intro.pdf  ## remake the paper as PDF
    make intro.docx ## what does the word file look like?

Update: I don't think the above is currently working...

