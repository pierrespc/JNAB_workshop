# GREP

grep "linea_15" 100lineas.txt

grep -A 2 "linea_15" 100lineas.txt

grep -B 2 "linea_15" 100lineas.txt

grep -B 2 -A 2 "linea_15" 100lineas.txt

grep -C 2 "linea_15" 100lineas.txt


# AWK


awk '{print $1}'

awk '{FS=";"} {print $1}'

awk 'BEGIN {FS=";"} {print $1}'



# SED

sed 's_\t_;_g' tabulardata.txt > semicolon.txt

sed -n 10,15p 100lineas.txt


# FOR

for i in {1..100}; do

	echo "Linea_"$i

done


# IF 


for i in {1..100}; do

	if [[ $i -lt 15 ]]; then
	
		echo "linea"$i
	fi

done



## FOR creando archivos


for i in {1..5}; do


	touch file_${i}_R1.fa.gz file_${i}_R2.fa.gz
		
		
done
	 

## FOR con wildcards

for file in *R1*; do

	echo $file
done



## FOR con wildcards e IF

mkdir R1 R2
for file in *fa.gz*; do

	if [[ $file == *R1* ]]; then
	
		mv -v $file ./R1/
		 		
	elif [[ $file == *R2* ]]; then
	
		mv -v $file ./R2/
		
	fi
done









