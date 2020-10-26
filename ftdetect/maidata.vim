au BufRead,BufNewFile maidata.txt set filetype=maidata
au BufRead,BufNewFile *.maidata.txt set filetype=maidata

au BufNewFile,BufRead *.txt
    \     if getline(1) =~ "&title="  ||
    \        getline(2) =~ "&title="  ||
    \        getline(1) =~ "&artist=" ||
    \        getline(2) =~ "&artist=" |
    \     set filetype=maidata        |
    \     endif
