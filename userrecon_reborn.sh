#!/usr/bin/env bash

#Version
version="v0.18"

#Coloring:
RST="\e[0;0m"
RED="\e[1;91m"
GRN="\e[1;92m" #1;32 or 1;92
BLU="\e[1;96m" #What's supposed to be blue looks purple so cyan (1;36 or 1;96) is used
YLW="\e[1;93m" #1;33 or 1;93
#If the user or the script exits (while not being ran in silent mode), this clears the colors
exitRST()
{
	if [ "${silent}" != true ]
	then
		printf "${RST}"
	fi
	printf ""
	exit
}
trap "exitRST" EXIT 


#Name and argument handling
name=""
silent=false
if [ "$1" == "-h" ] || [ "$1" == "--help" ] #Help dialogue
then
	echo "UserRecon Reborn ${version} - help dialogue:"
	echo "Usage: ./userrecon_reborn.sh [argument] <name>"
	echo ""
	echo "Arguments:"
	echo " -h, --help    Displays this help dialogue"
	echo " -s, --silent  Enables silent mode, which silently writes the output a local file"
	echo " -y, --yes     Enables writing the output to a local file"
	echo " -n, --no      Disables writing the output to a local file"
	echo ""
	echo "Local file naming:"
	echo " If enabled, a file named name-x.txt in the current directory will be created and written to, where 'name' is the name scanned for, and 'x' is an increasing int, to prevent overwriting of previous scans"
	echo ""
	echo "Homepage: <https://github.com/the-samminater/userrecon_reborn>"
	exit
elif [ "$1" == "-s" ] || [ "$1" == "--silent" ] #Silent mode
then
	silent=true
	if [ "$2" ]
	then
		name="$2"
		fCreate=true
	else
		#I figure that if this is being ran in silent mode, then it doesn't need color
		echo "[!] Error: while using silent mode, <arg2> can't be empty" #I can't have this printed to the file, because it (the file) hasn't been made yet
		exit
	fi
else
	if [ "$1" ] #If the script is ran with at least one argument
	then
		if [ "$1" == "-y" ] || [ "$1" == "--yes" ]
		then
			fCreate=true
		elif [ "$1" == "-n" ] || [ "$1" == "--no" ]
		then
			fCreate=false
		fi
		if [ "${fCreate}" ] #If fCreate exists, check for $2, and if that exists too, presume it ($2) is a name
		then
			if [ "$2" ]
			then
				name="$2"
			fi
		else #Presume that the first argument is a name
			name="$1"
			if [ "$2" ]
			then
				#if [[ "$2" == @("-y"|"--yes") ]] #Requires bash v4.2 or later
				if [ "$2" == "-y" ] || [ "$2" == "--yes" ]
				then
					fCreate=true
				elif [ "$2" == "-n" ] || [ "$2" == "--no" ]
				then
					fCreate=false
				fi
			fi
		fi
	fi
	width=$(tput cols)
	if [ "${width}" -ge 63 ] #If the width is greater than or equal to 63
	then
		#Title; sorry about the general messiness, I've tried to keep it relatively clean
		#printf "${RED}\n"
		printf "${RED}                                                   .-\"\"\"\"-.	\n"; #Trick to show four quotation marks
		printf "                                                  /        \	\n"
		printf "${GRN}  _   _               ____                      ${RED} /_        _\	\n"
		printf "${GRN} | | | |___  ___ _ __|  _ \ ___  ___ ___  _ __  ${RED}// \      / \\"; echo "\\	" #Cheap trick to show two back-slashes
		printf "${GRN} | | | / __|/ _ \ '__| |_) / _ \/ __/ _ \| '_ \ ${RED}|\__\    /__/|	\n"
		printf "${GRN} | |_| \__ \  __/ |  |  _ <  __/ (_| (_) | | | |${RED} \    ||    /	\n"
		printf "${GRN}  \___/|___/\___|_|  |_| \_\___|\___\___/|_| |_|${RED}  \        / 	\n"
		printf "${BLU} Reborn ${RED}---------------------------------- ${BLU}${version}${RED}   \  __  /	\n"
		printf "                                                    '.__.'	\n"
	elif [ "${width}" -ge 48 ] #If the width is less than 63, but greater than or equal to 47
	then
		printf "${GRN}"
		printf "  _   _               ____\n"
		printf " | | | |___  ___ _ __|  _ \ ___  ___ ___  _ __  \n"
		printf " | | | / __|/ _ \ '__| |_) / _ \/ __/ _ \| '_ \ \n"
		printf " | |_| \__ \  __/ |  |  _ <  __/ (_| (_) | | | |\n"
		printf "  \___/|___/\___|_|  |_| \_\___|\___\___/|_| |_|\n"
		printf "${BLU} Reborn ${RED}---------------------------------- ${BLU}${version}${RED}\n"
	elif [ "${width}" -ge 14 ] #If the width is less than 48, but greater than or equal to 14
	then
		printf "${RED}"
		printf "   .-\"\"\"\"-.   \n" #Trick to show four quotation marks
		printf "  /        \  \n"
		printf " /_        _\ \n"
		printf "// \      / \\"; echo "\\" #Cheap trick to show two back-slashes
		printf "|\__\    /__/|\n"
		printf " \    ||    / \n"
		printf "  \        /  \n"
		printf "   \  __  /   \n"
		printf "    '.__.'    \n"
		printf "${GRN}U.R.R __ ${version}\n"
	else #If the width is less than 14
		printf "${RED}UserRecon Reborn - ${version}"
	fi
	if [ "${name}" == "" ]
	then
		while [ "${name}" == "" ]
		do
			printf "${BLU}[?] Name: "
			#read -p "" name
			IFS="" read -rp "" name
			#Change suggested by ShellCheck - SC2162
			#To-do: add similar name(s) option
		done
	else
		printf "${BLU}[?] Name: ${name}\n"
	fi
fi


#Name changing (to uppercase and lowercase)
nameLower=$(echo "${name}" | tr '[:upper:]' '[:lower:]')
nameUpper=$(echo "${name}" | tr '[:lower:]' '[:upper:]')


#File handling
if [ "${fCreate}" ] #If fCreate exists, meaning it's already been set
then
	: #This just does nothing
else
	fCreate=false
	fCreateRaw=""
	printf "${BLU}[?] Do you want to save the output to a file: "
	read -rp "" fCreateRaw
	#-r suggested by ShellCheck - SC2162
	fCreateRaw=$(echo "${fCreateRaw}" | tr '[:upper:]' '[:lower:]')
	if [ "${fCreateRaw}" == "y" ] || [ "${fCreateRaw}" == "yes" ]
	then
		fCreate=true
	fi
fi
if [ "${fCreate}" == true ]
then
	#fCount (and fName) are in place to prevent overwriting or adding on to a pre-existing file
	fCount=1
	fName="${name}-${fCount}.txt" #Need to add replacement for / in 'name' with _ or some other character
	while [ -f "./${fName}" ]
	do
		let "fCount++"
		fName="${name}-${fCount}.txt"
	done
	touch "${fName}"
	if [ ${silent} == false ]
	then
		printf "${BLU}[?] Saving output to ${fName}\n"
	fi
fi


#scan() scans URLs based on info passed to it, determines if the profile exists or not, and then passes that on to print()
scan()
{
	#$1: name (of site)
	#$2: URL
	#$3: string to grep for (as an indication of success)
	#$4: if set to -i (as in inverse), turns $3 into an indication of failure - only use if necessary
	#$5: Header (if necessary) - if curl has an issue with a header (if it has a colon), then put it here
	#$6: Other headers (if necessary) - the -H and " need to be included for each
	#
	#Credit to https://stackoverflow.com/a/57120937 for 2>&1 for capturing curl's error
	#Also in use is a custom user agent, as curl/* doesn't work for some sites
	if [ "$5" ] #In the case that a header is necessary - should modify to accept as many headers as is needed
	then
		if [ "$6" ] #In the case that more headers are necessary
		then
			resultRaw=$(curl -s -S --show-error -A "UserRecon Reborn/${version}" "$2" -H "$5" $6 2>&1) #Only had limited testing, should work though
		else
			resultRaw=$(curl -s -S --show-error -A "UserRecon Reborn/${version}" "$2" -H "$5" 2>&1)
		fi
	else
		resultRaw=$(curl -s -S --show-error -A "UserRecon Reborn/${version}" "$2" 2>&1)
	fi
	if [[ $(echo "${resultRaw}" 2> /dev/null | head -c 5) == "curl:" ]] #The '2> /dev/null' eliminates the occasional echo broken pipe error
	then
		#print "error" "${resultRaw}"
		#Prints only the first line of the error message:
		#print "error" "$(printf "${resultRaw}" | head -n 1)" "$1" 
		print "error" "$(printf "%s" "${resultRaw}" | head -n 1)" "$1" 
		#Change suggested by ShellCheck - SC2059
		#Although it's unlikely to cause a problem, I might as well use their suggestion
	else
		result=$(echo "${resultRaw}" | grep "$3")
		if [ "$4" == "-i" ]
		then
			if [ -n "${result}" ]
			then
				status="failure"
			else
				status="success"
			fi
		else 
			if [ -n "${result}" ] 
			then
				status="success"
			else
				status="failure"
			fi
		fi
		if [ "${fCreate}" == true ] && [ "${status}" == "success" ]
		then
			#Custom manual link-passing for certain sites; not necessary, but nice
			if [ "$1" == "GitHub" ]
			then
				print "${status}" "$1" "https://github.com/${name}"
			elif [ "$1" == "Imgur" ]
			then
				print "${status}" "$1" "https://imgur.com/user/${name}"
			elif [ "$1" == "Instagram" ]
			then
				print "${status}" "$1" "https://instagram.com/${name}"
			elif [ "$1" == "Reddit" ]
			then
				print "${status}" "$1" "https://reddit.com/u/${name}"
			elif [ "$1" == "Twitter" ]
			then
				print "${status}" "$1" "https://twitter.com/${name}"
			else
				print "${status}" "$1" "$2"
			fi
		else
			print "${status}" "$1"
		fi
		unset resultRaw
		unset result
		unset status
	fi
}


#print() prints and writes (to fName) information passed to it by scan()
print()
{
	#$1: status message
	#$2: site name/error message
	#$3: URL (for printing to file)
	#
	#Printing out the results (to the console) if the script isn't being ran in silent mode
	if [ "${silent}" == false ]
	then
		if [ "$1" == "success" ]
		then
			printf "${BLU}[${GRN}\xE2\x9C\x94${BLU}] ${GRN}$2 found\n"
		elif [ "$1" == "failure" ]
		then
			printf "${BLU}[${RED}X${BLU}] ${RED}$2 not found\n"
		elif [ "$1" == "error" ]
		then
			printf "${BLU}[${YLW}!${BLU}] ${YLW}$3 error: $2\n"
		fi
	fi
	#Printing out the results (to fName) if the user wants a file created
	if [ "${fCreate}" == true ]
	then
		if [ "$1" == "success" ]
		then
			#printf "[\xE2\x9C\x94] $2 found: $3\n" >> "${fName}"
			printf "[\xE2\x9C\x94] $2 found: %s\n" "$3" >> "${fName}"
			#Change suggested by ShellCheck - SC2059
		elif [ "$1" == "failure" ]
		then
			printf "[X] $2 not found\n" >> "${fName}"
		elif [ "$1" == "error" ]
		then
			printf "[!] $3 error: $2\n" >> "${fName}"
		fi
	fi
}


#URL checking:
#Arguments are explained in scan()

#Bethesda
scan "Bethesda" "https://bethesda.net/community/user/${nameLower}" "${name}"
#Chess.com - not using api (if there is one)
scan "Chess.com" "https://www.chess.com/member/${name}" "(${name}) - Chess Profile - Chess.com"
#Facebook - not using api
scan "Facebook" "https://www.facebook.com/${name}" '"error":0,' "-i"
#GitHub
scan "GitHub" "https://api.github.com/users/${name}" "${name}" "" "Accept: application/vnd.github.v3+json"
#GOG - not using api (if there is one)
scan "GOG" "https://www.gog.com/u/${name}" "${name}"
#iFunny
scan "iFunny" "https://ifunny.co/user/${name}" "404 - page not found -" "-i"
#Imgur
scan "Imgur" "https://api.imgur.com/3/account/${name}" "${name}" "" "Authorization: Client-ID f7b3d452da6f049" #Imgur Client-ID for UserRecon Reborn
#Instagram - via bibliogram.art, not using api
scan "Instagram" "https://bibliogram.art/u/${name}" "${name}"
#PicsArt - not using api - couldn't find endpoints (api.picsart.com)
scan "PicsArt" "https://picsart.com/u/${name}" "${name}"
#Pintrest - not using api - also, $6 is being abused to add the argument -sSL (possibly to be built into the scan() curls)
#scan "Pintrest" "https://www.pintrest.ca/${name}" "(${name}) - Profile | Pinterest" "" "" "-sSL"
#The Pintrest scan is commented out because it doesn't seem to work for some reason
#Reddit                                                                                   
scan "Reddit" "https://api.reddit.com/user/${name}" "${name}"
#Roblox - not using api
scan "Roblox" "https://www.roblox.com/users/profile?username=${name}" "code=404" "-i"
#TikTok
scan "TikTok" "https://www.tiktok.com/@${name}" 'serverCode":404,' "-i"
#Tumblr - not using api
scan "Tumblr" "https://${name}.tumblr.com/" "${name}"
#Twitter - via nitter.net, not using api
scan "Twitter" "https://nitter.net/${name}" "(@${name})"
#YouTube - not using api
#scan "YouTube" "https://www.youtube.com/user/${name}" "${name}" - sometimes returns false-negatives
scan "YouTube" "https://www.youtube.com/c/${name}" "${name}"


#Planned sites/site ideas:
#Impossible ones will be removed, and remaining ones will be looked into further
#
#Pintrest - fix scan/figure out why it doesn't work
#Snapchat - must look into further
#Tinder
#Tinder alternatives
#VK - either requires api access, a headless browser, or converting a user's name to their id
#Torn - likely not possible (unless the user supplies their personal api key)
#Steam - need to look into, get api access, or a headless browser
#Rockstar Games - was unable to look into because of too many arkose labs captchas
#Twitch - requires api access or headless browser
#Vimeo - requires api access or name to id conversion (possibly using the search page?)
#Origin
#PSN
#PS+ (apparently different than PSN?)
#Epic Games
#Fortnite
#XBox Live
#Riot Games
#PornHub
#Archive.org
#Medium
#LinkedIn
#Warzone
#League of Legends
#Activision
#Amazon
#Ebay
#Craigslist
#AliExpress
#Apple Music
#Blizzard
#GitLab
#CodePen
#GameJolt
#Itch
#Change.org
#Fandom (community.fandom.com/wiki/User:${name})
#Hacker News
#iFixit
#Quora
#OneHack.Us
#Yahoo (answers)
#OnlyFans
#PayPal (public transfer pages?)
#Pastebin
#Pastebin alternatives
#Wikipedia
#Wikipedia alternatives (brittanica, etc?)
#Tapas.io
#Webtoon
#Radicle
#Shaw (forums maybe?)
#Ubisoft
#VirusTotal
#YouRepo
#GoFundMe
#GoFundMe alternatives
#
#Flickr
#SoundCloud
#Spotify
#Disqus
#DeviantArt
#About.me
#FlipBoard
#SlideShare
#Fotolog
#MixCloud
#Scribd
#Badoo
#Patreon
#BitBucket
#DailyMotion
#Etsy
#CashMe
#Behance
#GoodReads
#Instructables
#KeyBase
#Kongregate
#Livejournal
#AngelList
#Last.fm
#Dribble
#Codeacademy
#Gravatar
#Foursquare
#Gumroad
#Newgrounds
#Wattpad
#Canva
#CreativeMarket
#Trakt
#500px
#Buzzfeed
#TripAdvisor
#HubPages
#Contently
#Houzz
#blip.fm
#CodeMentor
#ReverbNation
#Designspiration 65
#Bandcamp
#ColourLovers
#IFTTT
#Slack
#OkCupid
#Trip
#Ello
#Tracky
#Tripit
#Basecamp
