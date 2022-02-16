#!/bin/sh

#check if page exists
if $(echo $1 | sed 's/[0-9]*//') = "" && test $(count $1) = "1"
    CHECKIFPAGE=$(curl -sfL "https://www.nhentai.net/g/$1")
    if test $status != 0; then
        printf "%s\n" \ "Manga doesn't exist, aborting."
	fi

	TITLE=$(curl -s https://nhentai.net/g/$1/ | grep -o -P '(?<=<meta itemprop="name" content=").*(?=" /><meta itemprop="image")')
	echo Downloading \"$title\"

    #make directory for manga to go to
    if not test -d "$title"; then
        mkdir "$title"
	fi

    #delete files in directory in case the dir already exists
    cd "$title"
    if test -f 1.jpg; or test -f 1.png; then #if there are images from previous downloads...
        rm *
	fi

    #parse index.html
    wget "https://www.nhentai.net/g/$1/" -q -O tempindex
    gallery_number=$(cat tempindex | grep "window._gallery" | sed 's/\\u0022//g' | sed 's/\\\//g' | grep -E -o 'media_id:[[:digit:]]+' | sed 's/media_id://')

    #getting the pages
    current_page_number=1
    while test -z $(wget "https://i.nhentai.net/galleries/$gallery_number/$current_page_number.jpg" -nv 2>&1 | grep "404: Not Found");
          or test -z $(wget "https://i.nhentai.net/galleries/$gallery_number/$current_page_number.png" -nv 2>&1 | grep "404: Not Found");
		  do
			  printf "%s\n" "Downloading page $current_page_number"
        current_page_number=$(expr $current_page_number + 1)
	done

    #delete tempindex
    printf "%s" "Erasing temp files... "
    if test -f "tempindex"; then
        rm tempindex
	fi

    #done
    echo "Manga successfully downloaded!"
then echo "Done" && exit
fi
