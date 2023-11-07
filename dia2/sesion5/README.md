# Sesión 5: Analisis de datos

En esta sesión, vamos a analizar los datos de Patagonia:
- en un contexto global con Admixture ([Alexander et al. 2008](https://genome.cshlp.org/content/19/9/1655) y ACP ([Patterson et al. 2006](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.0020190).
- en un contexto mas local con los estadisticos F ([Patterson et al. 2012](https://academic.oup.com/genetics/article/192/3/1065/5935193).


Los datos estan en StartingData y son los datos que generamos en la sesion 3:
- `StartingData/ModernAncient_withOutgroups.MIND0.5.GENO0.3.{bed,bim,fam} `: datos de Modernos y Antiguos, filtrados por valores faltantes (pero no MAF ni LD). Se usaran en el ACP
- `StartingData/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.{bed,bim,fam}`: datos de Modernos y Antiguos, filtrados por valores faltantes, MAF y LD. Se usaran para Admixture

Ubicarse en `${HOME}/JNAB/dia2/sesion5/` y generar las carpetas `Logs` y `Outputs`
`cd ${HOME}/JNAB/dia2/sesion5/
./0_init.sh `

Generar las carpetas Logs y Outpus
# ACP en un contexto Global

Vamos a usar `smartpca` de EIGENSOFT (ver [https://github.com/argriffing/eigensoft/tree/master/POPGEN](https://github.com/argriffing/eigensoft/tree/master/POPGEN).
El comando es simple: se llama smartpca con un archivo de parametro (opcion  -p) que contiene infirmacion sobre los datos de entrada, donde se generan las salidas y algunas opciones para el algoritmo.
Se calcula el ACP con los datos modernos (opcion poplistname) y se proyectan los datos antiguos. Esto se debe a (se suele hacer con ADN antiguo). Para eso tenemos que generar un archivo lista de las poblaciones modernas.
Tambien, como tenemos muchos valores faltantes en la matriz de genotipos de modernos, vamos a usar la opcion [lsqproject](https://github.com/DReichLab/EIG/blob/master/POPGEN/lsqproject.pdf) que permite tomar mejor en cuanta este problema al momento de construir los Componentes prinpales.
`smartpca` permite sacar individuos outliers. No los vamos a usar (para desabilitarlo ponemos 0 al parametro `numoutlieriter`).

Correr `sbatch 1_PCA.sh` y verificar que se generaron bien los ficheros en `Outputs/PCA`
- ficheros de los eigen vectors (`.evec`): una linea un individuo y una columna su posicion en un COmponente Principal (1a y ultima columna son datos de anotacion del individuo)
- ficheros de los eigen value (`.eval`): Varianza explica por el componente)

Vamos a graficar estos resultados para los 10 primeros componentes con `Rscript 2_plotPCA.R`.
Descargar el pdf de salida en la computadora con `scp <user>@mulatona.ccad.unc.edu.ar:/home/<user>/JNAB/dia2/sesion5/Outputs/PCA/PCAwithProjection.pdf . `.
Que diversidad captura cada componente? Que conlusiones se pueden sacar del PC2 vs PC1? Del PC4? Del PC5?

# Admixture en un contexto Global

Vamos a usar Admixture (ver [https://dalexander.github.io/admixture/](https://dalexander.github.io/admixture/) con los datos filtrados para MAF y LD porque el modelo requiere de datos independientes.
Se fijan K poblaciones ancestrales a priori. Vamos a probar para K entre 3 y 10. Una manera de selecionar el modelo mas robusto segun los datos es seleccionando el modelo con el menor escore de [validacion cruzada](https://datascientest.com/es/cross-validation-definicion-e-importancia).\ 
Admixture se llama asi: `admixture <inputbed> K --seed <Num> --cv `. \
Seed es una semilla aleatoria (o estado de semilla, o semilla) es un número utilizado para inicializar un generador de números pseudoaleatorios. Fijando la seed nos aseguramos que el resultado sera igual a cada repeticion. Pero si cambiamos las seeds, el resultado puede cambiar (en general llevemente). Volveremos sobre eso despues. \
Con `--cv` decimos al programa que queremos estimar la validacion cruzada (cross-validation en ingles). Es una manera de selecionar el modelo mas robusto segun los datos es seleccionando el modelo con el menor escore de [validacion cruzada](https://datascientest.com/es/cross-validation-definicion-e-importancia).

Para que las diferentes corridas de Admixture (una corrida por cada K), vamos a evitar de hacer un script que corre todo secuencialmente, pero mejor que cada corrida sea un jpb indpendiente en el cluster.
Para eso correr `./3_Admixture.sh` (mirar como se manda cada job, es otra sintaxis alternativa a la que veniamos haciendo).

A mayor K (mas poblaciones ancestrales), mas complejo el modelo y mas tiempo de computacion. Entonces, vamos a ver como los jobs con K bajos acabaran antes que los jobs con K altos.

Podemos seguir el avance con los logs \
(p.ej `less Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.K<K>.log `

Los archivos de salidas tienen sufijos .Q y .P. Nos interesa el .Q: son las proporciones del genoma de cada individuo atribuidas a una ancestria genetica. (El .P es la contribucion de cada variante a cada componente). Los archivos `.Q` y `.P` solo contienen numeros pero cada linea representa un individuo o una variante, en el orden del `.fam` y el `.bim` asociados al `.bed` usado como input, respectivamente.

Cuando se acabaron todas las corridas de admixture, vamos a recuperar los CV scores de cada una yvolcarlas en un unico archivo llamado `Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.CV.tsv`. Para eso Correr `./4_getCV.sh` y mirar el archivo creado. Que K seleccionaria segun el CV score? Ojo: no es el modelo mas valido para explicar sus datos y los modelos con mas o menos K pueden ser muy informativos. Nos remitimos a Lawson et al. (2018) para un tutorial para no sobreinterpretar los resultados de admixture (ver  [https://www.nature.com/articles/s41467-018-05257-7](https://www.nature.com/articles/s41467-018-05257-7)].

Graficar las salidas de Admixture es siempre un desafio. Existe la herramienta PONG ([Behr et al. 2016](https://academic.oup.com/bioinformatics/article/32/18/2817/1744074) que permite, ademas de mostrar los compnentes con colores consistentes en los diferentes K de manera automatica, explorar la consistencia de las estimaciones por un K dado entre diferentes corridas (con diferentes seeds). Normalmente, se suele hacer para cada K 10 o 20 repiticiones. No lo vemos hoy, pero aconsejamos usar PONG. El limitante es que cuando un grupo poblacional es reducido (1 o 2 individuos), no se ve bien en los graficos de PONG. 

En este caso, usaremos un script casero en R que permite guardar los individuos en un orden mas simple de interpretar y con codigos colores consistentes entre diferentes K.\
 correr `Rscript 5_plotAdmixture.R`. En Outputs/Admixture/, Se generan 3 archivos para cada K:
- un `.pdf` con el grafico
- un `.AncestryComponentByIndividual.txt` con los resultados del .Q pero con anotaciones (id y poblacion).
- un `.MeanByGroup.txt` con los promedios de las proporciones de ancestria por poblacion.

Mirando los graficos para diferentes K
- Tratar de interpretar los diferentes componentes. A diferentes K, cada color se interpreta exactamente igual? Es decir cada componente representa exactamente la misma ancestria genetica?
- Que patrones podemos identificar para Patagonia a traves del tiempo?
- A que grupos de suamerica parecen estar mas cercanas las poblaciones de Patagonia?
- Podemos identificar una estructura en la region?

# F-statistics

Vamos ahora utlisar Admixtools ([https://github.com/DReichLab/AdmixTools](https://github.com/DReichLab/AdmixTools)) para calcular diferentes estadisticos F. 
Usaremos los archivos `StartingData/ModernAncient_ForFstats.{geno,snp,ind}.txt` donde los individuos modernos (salvo los Mbuti) estan atribuidos a la poblacion "Ignore" para no considerarlos en los calculos de F-stats. En Admixtools la unidad de analisis es la poblacion. Se comnparan las frecuencias alelicas entre 3 o 4 poblaciones (hablamos de F3 o F4). Los resultados son un indice F asociado a un Z score: Z =  (F-esp(F))/std(F). La esperanza y el error estandar se calculan calculando el F en diferentes partes del genoma usando un jackknife.
El Z es un truco estadistico muy usado que permite inferir si un F es significativamente > 0 (Z>3) o < 0 (Z<3). Los detalles teoricos acerca de los F y los Z estan descritos en [Patterson et al 2012](https://academic.oup.com/genetics/article/192/3/1065/5935193), [Lipson et al. 2020](https://onlinelibrary.wiley.com/doi/abs/10.1111/1755-0998.13230).

## F3-Outgroup
Usando el F de la forma F(Ind1,Ind2;Mbuti), Mbuti siendo el outgroup podemos inferir las similitudes entre pares de individuos. Usando despues 1-F3, tenemos una distancia genetica entre individuos. \
Vamos primero calcular los F3 usando la funcion `qp3Pop`. Pero tenemos que definir como entidad de analisis el individuo: hay que cambiar el archivo .ind.txt para atribuir como poblacion el ID del individuo (guardamos Mbuti como poblacion). Luego hay que guardar la lista de las comparaciones que queremos hacer en un archivo con 3 columnas Ind1 | Ind2 | Outgroup. Hay que generar un archivo de parametros donde se estipula los archivos de entrada, el archivo de lista de comparaciones y unas opciones. Y se lanza los calculos con `qp3Pop -p <paramfile>`. Los resultados se imprimen normalmente en plantala, por eso hay que redireccionar la salida al archivo deseado.\
El script `6_F3.sh ` hace todo eso... Correrlo con `sbatch 6_F3.sh`. Mientras corre, tratar de obtener el numero de combinaciones para cuales se van a calcular el F3.






