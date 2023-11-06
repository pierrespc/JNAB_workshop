# Load program modules (may be different for midway and gardner)

base1=$1 # sampleid_E1_L1_P1
base1=patagonia1_E1_L1_P1
indir=${HOME}/JNAB/dia1/sesion2/fastq


# extract info from filename for readgroups
RGID=$1\_S1
RGLB=`echo $base1 | awk -F "/" '{print $NF}' | cut -d"_" -f3`
RGPU="HiSeq2500"
RGSM=`echo $base1 | awk -F "/" '{print $NF}' | cut -d"_" -f1`

#Otros parametros y nombre de archivos
mapQfilter=30

suf0=.bwa
suf1=$suf0.mapped
suf2=$suf0.Q${mapQfilter}F4
suf3=$suf2.srt
suf4=$suf3.rmdup
suf5=$suf4.realn
suf6=$suf5.md

trimsuf=".truncated.gz"
collapse=""
trim3p=""
trim5p=""


refdir="${HOME}/JNAB/dia1/sesion2/reference"
REF=${refdir}/rCRS.fa  #human reference

mkdir ${base1}.preQC
fastqc -o ${base1}.preQC --extract ${indir}/${base1}.fq.gz

AdapterRemoval \
    --file1 ${indir}/${base1}.fq.gz \
    --basename ${base1} \
    --gzip \
    --minlength 30 \
    --mm 3 \
    --trimns \
    --trimqualities \
    --minquality 2 \
    --qualitybase 33 \
    --settings ${base1}.fq.primerstats \
    $collapse $trim3p $trim5p

mkdir ${base1}.postQC
fastqc -o ${base1}.postQC --extract ${base1}$trimsuf

bwa aln \
  -l 1000 \
  $REF \
  ${base1}${trimsuf}  > ${base1}${trimsuf}.sai

bwa samse \
  -r "@RG\tID:$RGID\tSM:$RGSM\tLB:$RGLB\tPL:ILLUMINA" \
  $REF \
  ${base1}${trimsuf}.sai \
  ${base1}${trimsuf} > ${base1}${trimsuf}.sam

samtools sort \
  -o ${base1}$suf1.bam \
  -O bam \
  ${base1}${trimsuf}.sam

samtools view \
  -bh \
  -F 4 \
  -q $mapQfilter \
  -o ${base1}$suf2.bam \
  ${base1}$suf1.bam

samtools sort \
  -o ${base1}$suf3.bam \
  -T ${base1}$suf3 \
  ${base1}$suf2.bam

picard MarkDuplicates \
  INPUT=${base1}$suf3.bam \
  OUTPUT=${base1}$suf4.bam \
  ASSUME_SORTED=TRUE \
  REMOVE_DUPLICATES=true \
  METRICS_FILE=${base1}$suf4.metrics \
  VALIDATION_STRINGENCY=SILENT

samtools index ${base1}$suf4.bam

GenomeAnalysisTK \
  -T RealignerTargetCreator \
  -I ${base1}$suf4.bam \
  -R $REF \
  -o ${base1}.intervals

GenomeAnalysisTK \
  -T IndelRealigner \
  -I ${base1}$suf4.bam \
  -R $REF \
  -targetIntervals ${base1}.intervals \
  -o ${base1}$suf5.bam

samtools calmd \
  -Erb \
  ${base1}$suf5.bam $REF > ${base1}$suf6.bam

samtools index ${base1}$suf6.bam

