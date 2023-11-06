# Sesión 2: Manejo de datos antiguos

En esta sesión revisaremos el flujo de trabajo básico para:
- Evaluar datos de NGS antiguos (formato fastq)
- Alinear lecturas a genoma de referencia (formato bam)
- Filtrar lecturas y evaluar estadísticos básicos (ADN endógeno, profundidad, cobertura y patrones de daño)

## 1. Evaluar calidad de los datos
Partiremos evaluando datos de secuenciación NGS de individuos antiguos.

### Antes de empezar:

En el fichero `/home/shared/cursojnab/dia1/sesion2` encontrarán:
- Archivos fastq: `/home/shared/cursojnab/dia1/sesion2/fastq/<prefix>.fq.gz`
- Scripts a utilizar en la sesión:
  - `1_fastqc.sbatch`
  - `2_AdapterRemoval.sbatch`
  - `3_mapping.sbatch` y `3_mapping.sh`
- Genoma de referencia: `/home/shared/cursojnab/dia1/sesion2/reference`

Crear carpeta `JNAB/dia1/sesion2/` y copiar los archivos necesarios (comandos `mkdir` y `cp`)

Contar número de líneas en cada archivo usando el siguiente comando:
  `zcat <prefix>.fq.gz | wc -l`

¿Cuántas lecturas tiene cada archivo?

### fastqc
Correr el programa fastqc para evaluar la calidad de los datos y visualizar resultados. El programa se puede correr directamente así:
  `mkdir preQC`
  `fastqc -o preQC --extract <prefix>.fq.gz`

o enviándolo a un nodo de computación:

  `sbatch -J <prefix> 1_fastqc.sbatch`

## 2. AdapterRemoval
En aDNA, uno de los programas más populares para filtrar archivos fastq es AdapterRemoval (https://adapterremoval.readthedocs.io/en/stable/manpage.html#options). Este programa permite entre otras cosas: remover adaptadores, cortar Ns, remover lecturas de mala calidad y por tamaño (usualmente menores a 30pb).

El programa se puede correr directamente así:

`AdapterRemoval --file1 <prefix>.fq.gz --basename <prefix> --gzip --minlength 30 --mm 3 --trimns --trimqualities --minquality 2 --qualitybase 33 --settings <prefix>.fq.primerstats`

o enviándolo a un nodo de computación utilizando el script 2_AdapterRemoval.sbatch:

  `sbatch -J <prefix> 2_AdapterRemoval.sbatch`

- ¿Qué significa cada uno de los parámetros?
- Explorar los archivos `<prefix>.fq.primerstats`. ¿Cuántas lecturas fueron descartadas? ¿Cuantas lecturas pasaron los filtros?
- Correr fastqc con el archivo de lecturas filtradas y visualizar.

## 3. Alineamiento de datos a genoma de referencia

Mirar el script `3_mapping.sh`.

- ¿Qué programas se utilizan?
- ¿Para qué se utiliza cada programa?
- ¿Cuáles son los archivos de input y output de cada etapa?

Ejecutar el script de la siguiente manera
  `sbatch -J <prefix> 3_mapping.sbatch`

Archivos bam
- ¿Cuántos archivos bam hay por fastq?
- Los archivos bam son la versión binaria de sam. Explorar las características de estos archivos, secciones y pasos en el header utilizando:
  `samtools view -h <prefix>.bam | less`
- ¿Qué numero de lecturas fueron alineadas al genoma de referencia? (ejemplo: `samtools view -c <prefix>.bam`)
- ¿Qué número de lecturas únicas fueron alineadas al genoma de referencia?
- ¿Cuál es el porcentaje de ADN endógeno?
- Utiliza el siguiente comando para evaluar la cobertura y profundidad del genoma analizado:

`samtools coverage -o <prefix>_coverage.txt <prefix>.rmdup.uniq.rg.realn.md.bam`


## 4. Patrones de daño
Los patrones de daño pueden ser evaluados con el programa mapDamage. Ejecutar este programa de la siguiente manera:

`mapdamage  --folder=<prefix>_mapDamage -i <prefix>.rmdup.uniq.rg.realn.md.bam -r <referencia.fa>`


## 5. Archivo de variantes (VCF): mtDNA
Por cuestiones de tiempo y espacio los archivos fastq y alineamiento estuvieron limitados a mtDNA. Esto facilitará la obtención de un archivo de variantes (VCF), el cual se puede generar de la siguiente manera:  

`bcftools mpileup \
-f rCRS.fa \
-d 2000 \
-m 3 \
-EQ 20 \
-q 30 <prefix>.rmdup.uniq.rg.realn.md.bam | bcftools call -m --ploidy 1 -Ov > <prefix>.MT.vcf`

- Crear un archivo sbatch para ejecutar comando

- ¿Qué filtros fueron utilizados para el llamado de variantes? Revisar manual de bcftools en https://samtools.github.io/bcftools/bcftools.html

- El archivo de variantes mitocondriales puede ser cargado en la versión online de haplogrep (https://haplogrep.i-med.ac.at/) para asignar linaje. ¿Cuales son los linajes mitocondriales de los individuos analizados?

- ¿Cómo extraer información sólo de mtDNA de un alineamiento genómico? (tip: samtools)
