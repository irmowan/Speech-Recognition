j=1
l=10
word="close"
for i in `ls | grep 1`
do
    newWord=`echo $i | cut -d _ -f 2`
    if [[ "$word" != "$newWord" ]];then
        let j=1
    fi
    if [[ "$j" -lt "$l" ]]
    then
        k=0$j
    else
        k=$j
    fi
    newName=`echo $i | cut -d _ -f 1,2`_$k.wav
    #echo $newName $word $newWord
    echo "Renaming file from "$i" to "$newName 
    mv $i $newName
    ((j++))
    word=$newWord
done
