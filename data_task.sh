#/bin/bash

 if [ ! -d "./site_downloads/pages" ] && [ ! -d "./site_downloads/text" ] && [ ! -d "./site_downloads/output" ] 
 then
    	mkdir -p "./site_downloads/pages"
	mkdir -p "./site_downloads/text"
	mkdir -p "./site_downloads/output"
 fi
touch "./site_downloads/output/master.txt"
touch "./site_downloads/output/occurrences.txt"


chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

# Array is used to store all wikipedia pages
pages=()


for ((i=65; $i<=90; i=$i+1)); do
    for ((j=65; $j<=90; j=$j+1)); do
        pages+=("$(chr $i)$(chr $j)")
    done
done


for ((i=0; $i<${#pages[*]}; i=$i+1)); do
    wget "https://en.wikipedia.org/wiki/${pages[$i]}" -O "./site_downloads/pages/${pages[$i]}.html"
    lynx -dump -nolist "./site_downloads/pages/${pages[$i]}.html" > "./site_downloads/text/${pages[$i]}.txt"
    
    echo $(cat "./site_downloads/text/${pages[$i]}.txt" | grep -wo -E '[a-zA-Z][a-zA-Z_]*') | tr " " "\n" >> "./site_downloads/output/master.txt" 
done


echo $(cat "./site_downloads/output/master.txt" | sort -f | uniq -ic | sort -nr | head -15) | xargs -n2 > "./site_downloads/output/occurrences.txt"
