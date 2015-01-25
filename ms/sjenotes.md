# To compile

For unicode/math bits, we currently need

     \setromanfont{TeX Gyre Pagella}'

so we need to load the font using [this link](https://groups.google.com/forum/?fromgroups#!topic/pandoc-discuss/urzu6dQU_R4)

these fonts can be installed using:

    tlmgr install tex-gyre
    tlmgr install tex-gyre-math ## might be needed too?

On mac, you may then need to open `Font book` and add the fonts before
they can be found by xelatex.

I have moved the org-preamble-xelatex.sty into the same directory as
the .tex for convenience.

    make intro.pdf  ## remake the paper as PDF
    make intro.docx ## what does the word file look like?

Update: I don't think the above is currently working...



## Pandoc issues


1. References can only come at end of document it seems
http://stackoverflow.com/questions/16427637/pandoc-insert-appendix-after-bibliography

2. titles in pandoc don't come across that easily.
