# Find all URLs matching a certain regex in a set of files, and dump those
# URLs to a file.

grep -Roh 'http:\/\/blog.[^\)]*' /home/ian/Code/octopress/source/_posts/* > ~/Desktop/urls.txt
