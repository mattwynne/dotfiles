files=`find ~/.dotfiles/bash -name '*' -type f`
for f in $files; do 
  source $f
done
