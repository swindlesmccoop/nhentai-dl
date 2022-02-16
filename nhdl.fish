#!/usr/bin/fish

#check if page exists
if test ( echo $argv[1] | sed 's/[0-9]*//') = ""; and test (count $argv) = "1"
    set check_if_page_exists (curl -sfL "https://www.nhentai.net/g/$argv[1]")
    if test $status != 0
        printf "%s\n" \
               "Manga doesn't exist, aborting."
        exit
    end

	set title ( curl -s https://nhentai.net/g/$argv[1]/ | grep -o -P '(?<=<meta itemprop="name" content=").*(?=" /><meta itemprop="image")' )
	echo Downloading \"$title\"

    #make directory for manga to go to
    if not test -d "$title"
        mkdir "$title"
    end

    #delete files in directory in case the dir already exists
    cd "$title"
    if test -f 1.jpg; or test -f 1.png #if there are images from previous downloads...
        rm *
    end

    #parse index.html
    wget "https://www.nhentai.net/g/$argv[1]/" -q -O tempindex
    set gallery_number (cat tempindex | 
                        grep "window._gallery" | 
                        sed 's/\\u0022//g' | 
                        sed 's/\\\//g' | 
                        grep -E -o 'media_id:[[:digit:]]+' | 
                        sed 's/media_id://')

    #getting the pages
    set current_page_number 1
    while test -z (wget "https://i.nhentai.net/galleries/$gallery_number/$current_page_number.jpg" -nv 2>&1 | grep "404: Not Found");
          or test -z (wget "https://i.nhentai.net/galleries/$gallery_number/$current_page_number.png" -nv 2>&1 | grep "404: Not Found")
        printf "%s\n" "Downloading page $current_page_number"
        set current_page_number (expr $current_page_number + 1)
    end

    #delete tempindex
    printf "%s" "Erasing temp files... "
    if test -f "tempindex"    
        rm tempindex
    end

    #done
    echo "Manga successfully downloaded!"
end
