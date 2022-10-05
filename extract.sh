# TODO
#
# you need to install ripgrep

# find all lichess dump files and put them in a list
list=$(find . -type f -name "lichess*" | sed 's|./||g')


# TODO
onetable(){
	for x in $list; do
		printf "processing "
		printf '\e[0;31m%-6s\e[m\n' $x
		rg -o --no-line-number --multiline '(\[(\b(Result|Black|White)\s.*?)\])|\n\n([0-9A-Za-z\-#.+\s]*)' $x >> onetable.txt
		# stylish "done" stdout signal 
		printf '\e[0;32m%-6s\e[m\n' "done"
	done
}

# for loop in shell/bash/zshell is considerably slow -- BAD implementation
# TODO
twotables(){
	# extract users' names and IDs
	for x in $list; do
		rg -o --no-line-number --multiline '(\[(\b(Black|White)\s.*?)\])' $x |
		sed -E 's/White|Black//' | tr -d '"[] ' >> listusr.txt
	done
	sed -r ':a; s/\b([[:alnum:]]+)\b(.*)\b\1\b/\1\2/g; ta; s/(, )+/, /g; s/, *$//' listusr.txt |
	sort | uniq | sed = | sed 'N;s/\n/ /' >> IDs.txt
	rm listusr.txt

	# unique games table
	for file in $list; do
		[[ -f 'games.txt' ]] || lines=0
		[[ -f 'games.txt' ]] && lines=$(wc -l < games.txt)
		rg -o --no-line-number '([0-9]+.\s[0-9A-Za-z\-#.+]+\s[0-9A-Za-z\-#.+]+\s)' $file |
		tr '\n' ' ' | sed 's/ 1\. /\n1. /g' >> games.txt
		white=( $(rg -o --no-line-number '\[(\b(White)\s.*?)\]' $file | cut -d '"' -f2) )
		black=( $(rg -o --no-line-number '\[(\b(Black)\s.*?)\]' $file | cut -d '"' -f2) )
		result=( $(rg -o --no-line-number '\[(\b(Result)\s.*?)\]' $file | cut -d '"' -f2) )
		length=${#white[@]}
		len=$(echo $length | bc)
		x=0
		for (( i=$(( lines+1 )); i<=$(( len+lines )); i++ )); do
			sed -i "$i s|^|${white[$x]} ${black[$x]} ${result[$x]} |" games.txt
			x=$((x+1))
		done
	done
}

# TODO
alltables(){
	# extract users' names and IDs
	printf "creating IDs table from all .pgn files\n"	
	for x in $list; do
		printf "processing "
		printf '\e[0;31m%-6s\e[m\n' $x
		rg -o --no-line-number --multiline '(\[(\b(Black|White)\s.*?)\])' $x |
		sed -E 's/White|Black//' | tr -d '"[] ' >> listusr.txt
		printf '\e[0;32m%-6s\e[m\n' "done"
	done
	sed -r ':a; s/\b([[:alnum:]]+)\b(.*)\b\1\b/\1\2/g; ta; s/(, )+/, /g; s/, *$//' listusr.txt |
	sort | uniq | sed = | sed 'N;s/\n/ /' >> IDs.txt
	rm listusr.txt

	# unique games table -- moves, opponents (white & black) and results
	printf "creating tables for MOVES, WHITE, BLACK, RESULTS\n"
	for file in $list; do
		rg -o --no-line-number '([0-9]+.\s[0-9A-Za-z\-#.+]+\s[0-9A-Za-z\-#.+]+\s)' $file |
		tr '\n' ' ' | sed 's/ 1\. /\n1. /g' >> moves.txt
		printf '\e[0;32m%-6s\e[m\n' "done with MOVES"
		rg -o --no-line-number '\[(\b(Result)\s.*?)\]' $file | cut -d '"' -f2 >> results.txt
		printf '\e[0;32m%-6s\e[m\n' "done with RESULTS"
		rg -o --no-line-number '\[(\b(Black)\s.*?)\]' $file | cut -d '"' -f2 >> black.txt
		printf '\e[0;32m%-6s\e[m\n' "done with BLACK"
		rg -o --no-line-number '\[(\b(White)\s.*?)\]' $file | cut -d '"' -f2 >> white.txt
		printf '\e[0;32m%-6s\e[m\n' "done with WHITE"
		printf '\e[0;31m%-6s\e[m\n' "added $file to all tables"
	done	
}

alltables