# nhentai-dl
Download images from Nhentai using a simple, fast, non-bloated `fish` script.

# Dependencies
[Fish](https://fishshell.com/), grep, wget, curl, and sed are needed. Fish is probably all you need to obtain as most distros already include the latter three.

# Usage  
Mark script as executable (ex: `chmod +x nhdl`)  
To run, type `./nhdl [number]` and let it run all the way through

# Notes
The script will download the images to a folder within the directory of the script, naming that directory the number of the downloaded gallery. This is a big change from the original as it would download to a `temp` folder, meaning you couldn't run multiple instances of it. Of course, this change allows for a (theoretically) infinite number of simultaneous downloads.

# To-do
- Allow for multiple arguments (codes) for simultaneous downloads on text-only systems
- Allow user to specify download directory so it can be called from any directory and output to the same one every time
- Allow for random download of user-specified tag or complete random download
- Remove fish dependency and make it completely POSIX sh
