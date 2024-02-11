ghc_forks() {
gita super forks add .
gita super forks commit -m "`date`"
gita super forks push origin # leave out branch for git to pick current branch
}

ghc_main() {
gita super main add .
gita super main commit -m "`date`"
gita super main push origin # leave out branch for git to pick current branch
}

ghc_all() {
  ghc_forks
  ghc_main
  }


1=https://github.com/nvim-telescope/telescope.nvim
repouser=$(grep -Po '\w\K/\w+[^?]+' <<<$1 | cut -c 2-)
echo $repouser


echo $var1
