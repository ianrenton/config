#!/bin/zsh

# Script for updating the theme on all my Octopress sites at once.

sites=( blog fiction frbtn guides raspberrytank recipes rpgs )

cd ~/code/octopress
for site in "${sites[@]}"
do
  echo $site
  git checkout $site
  git submodule update
  cd .themes/ianrenton-octo-theme
  git pull origin master
  git checkout master
  cd ../..
  echo 'y' | rake install\['ianrenton-octo-theme'\]
  rake generate
  git add -A
  git commit -m "Theme updates"
  git push origin $site && git push heroku-$site $site:master
done
