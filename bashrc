files=`find ~/.dotfiles/bash -type f -o -type l -name '*'`
for f in $files; do 
  source $f
done

# added by travis gem
[ -f /Users/matt/.travis/travis.sh ] && source /Users/matt/.travis/travis.sh
