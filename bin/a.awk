 { for (i=1;i<=NF;i++) {
    l=length($i) ;
    if ( l > linesize[i] ) linesize[i]=l ;
  }
}
END {
    for (l in linesize) printf "Columen%d: %d\n",l,linesize[l] ;
}
