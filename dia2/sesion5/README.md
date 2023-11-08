# Sesión 5: Analísis de datos

En esta sesión, vamos a analizar los datos de Patagonia:
- en un contexto global con Admixture ([Alexander et al. 2008](https://genome.cshlp.org/content/19/9/1655) y ACP ([Patterson et al. 2006](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.0020190).
- en un contexto más local con F3 ([Patterson et al. 2012](https://academic.oup.com/genetics/article/192/3/1065/5935193) (si da el tiempo pero se verá más en detalle en la sesión 6).


Los datos están en `StartingData` y son los que generamos durante la sesión 3:
- `StartingData/ModernAncient_withOutgroups.MIND0.5.GENO0.3.{bed,bim,fam} `: datos de Modernos y Antiguos, filtrados por valores faltantes, pero no por frecuencia del alelo Menor (MAF) ni desequilibrio de ligamiento (DL). Se usarán en el ACP.
- `StartingData/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.{bed,bim,fam}`: datos de Modernos y Antiguos, filtrados por valores faltantes, MAF y LD. Se usarán para Admixture

Ubicarse en `${HOME}/JNAB/dia2/sesion5/` y generar las carpetas `Logs` y `Outputs` con el script `0_init.sh`.
`cd ${HOME}/JNAB/dia2/sesion5/
./0_init.sh `

# ACP en un contexto Global

Vamos a usar `smartpca` de EIGENSOFT (ver [https://github.com/argriffing/eigensoft/tree/master/POPGEN](https://github.com/argriffing/eigensoft/tree/master/POPGEN).
El comando es simple: se llama `smartpca` con un archivo de parámetros (opcion  `-p`) que contiene información sobre:
-los datos de entrada
- donde se generan las salidas
-  algunas opciones para el algoritmo que detalleremos a continuación.
`smartpca` permite sacar individuos outliers. No lo vamos a usar (para desabilitarlo ponemos 0 al parametro `numoutlieriter`).\
Se calcula los Componentes Principales con los datos modernos (opción `poplistname`) y se proyectan los datos antiguos que contienen alta tasa de valores faltantes. Para eso tenemos que generar un archivo lista de las poblaciones modernas. Para evitar el problema de "shrinkage" (tendencia de los individuos proyectados a agruparse entre sí en el ACP), vamos a usar la opción [`lsqproject`](https://github.com/DReichLab/EIG/blob/master/POPGEN/lsqproject.pdf) que permite tomar mejor en cuenta este problema al momento de proyectar sobre los Componentes prinpales. En nuestro caso, `smartpca` no es la mejor opción: a contar con datos de modernos americanos con datos enmascarados, los Componentes Principales se estiman ya con individuos con alta tasa de valores faltantes. Sin embargo, al analizar la diversidad en un contexto global (con importante estructura genética), este problema no es tan grave. Una alternativa sería hacer un analísis de Multidimensional Scaling sobre una matriz de distancias genéticas entre individuos, con una estimación robusta de las distancias genéticas interindividuos (por ejemplo a partir de un F3-outgroup cómo detallado al final de esta sesión).

Correr `sbatch 1_PCA.ssbatch` y verificar que se generaron bien los ficheros en `Outputs/PCA`
- ficheros de los eigen vectors (`.evec`): una línea por individuo y una columna Componente Principal (La primera y ultíma columna corresponden a datos de anotación del individuo)
- ficheros de los eigen values (`.eval`): Varianza explicada por el componente)

Vamos a graficar estos resultados para los 10 primeros componentes con `Rscript 2_plotPCA.R`.
Descargar el pdf de salida en la computadora con `scp <user>@mulatona.ccad.unc.edu.ar:/home/<user>/JNAB/dia2/sesion5/Outputs/PCA/PCAwithProjection.pdf ./ `.
Que diversidad captura cada componente? Que conlusiones se pueden sacar de PC2 vs PC1? Del PC4? Del PC5?

# Admixture en un contexto Global

Vamos a usar Admixture (ver [https://dalexander.github.io/admixture/](https://dalexander.github.io/admixture/) con los datos filtrados para MAF y desequilibrio de ligamiento (DL). Es importante filtrar por DL porque el modelo requiere de datos independientes. También las variantes raras no están bien tomadas en cuenta en el modelo, por eso tenemos que filtrar por MAF.
En este modelo, se fijan K poblaciones ancestrales a priori. Vamos a estimar modelos para K entre 2 y 10. \ 
El comando para Admixture es: `admixture <inputbed> K --seed <Num> --cv `, con: 
- seed: semilla aleatoria (o estado de semilla, o semilla) es un número utilizado para inicializar un generador de números pseudo-aleatorios. Fijando la seed, nos aseguramos que el resultado sera igual a cada repetición. Pero si cambiamos las seeds, el resultado puede cambiar (en general llevemente). Volveremos sobre eso después. \
- Con `--cv` activamos la estimación del escore de validacion cruzada (cross-validation en inglés). Es una manera de selecionar el modelo más robusto según los datos analizados: el modelo con el menor escore de [validacion cruzada](https://datascientest.com/es/cross-validation-definicion-e-importancia), es el más consistente cuando analizamos diferentes partes del genoma

Para ganar tiempo, vamos a evitar usar un script que corre todo secuencialmente. Entonces, queremos que las diferentes corridas de Admixture (una corrida para cada K) corren en parallelo, atribuyendo un job independiente para cada corrida. Para eso correr `./3_Admixture.sh` (mirar como se manda cada job: es una síntaxis alternativa a la que veniamos haciendo con los ficheros `sbatch`).\
A mayor K (más poblaciones ancestrales), más complejo el modelo y, entonces, más tiempo de computación: vamos a ver como los jobs con K bajos acabarán antes que los jobs con K altos. Podemos seguir el avance consultando los logs: p.ej haciendo en la terminal: \
`less Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.K<K>.log `

Los archivos de salidas tienen sufijos `.Q` y `.P`. Nos interesa el archivo `.Q` que contiene las proporciones del genoma de cada individuo atribuídas a cada componente (ancestria genética derivada de una población ancestral). El archivo `.P` contiene la contribución de cada variante a cada componente, y no se suele consultar. Los archivos `.Q` y `.P` solo contienen números y son entonces dificiles de interpretar. Sin embargo,  cada linea de los archivos `.Q` y `.P` representa un individuo y una variante, respectivamente (en el mismo ordén respectivamente que en los archivos `.fam` y  `.bim` asociados al archivo `.bed` usado como input).

Cuando se acabaron todas las corridas de admixture, vamos a recuperar los CV scores de cada una y volcarlos en un único archivo llamado `Outputs/Admixture/ModernAncient_withOutgroups.MIND0.5.GENO0.3.MAF0.05.pruned.CV.tsv`. \
Para eso Correr `./4_getCV.sh` y mirar el archivo creado. Que K seleccionarías según el CV score? Ojo: no significa que con el modelo con este K sea el más valido para explicar los datos. Los modelos con más o menos K pueden ser muy informativos también. Nos remitimos a [Lawson et al. (2018)](https://www.nature.com/articles/s41467-018-05257-7) para no sobreinterpretar los resultados de admixture (ver  [https://www.nature.com/articles/s41467-018-05257-7]()].

Graficar las salidas de Admixture es siempre un desafio. Existe la herramienta PONG ([Behr et al. 2016](https://academic.oup.com/bioinformatics/article/32/18/2817/1744074) que permite, además de mostrar los compnentes con colores consistentes en los diferentes K de manera automática, explorar la consistencia de las estimaciones por un K dado entre diferentes corridas (con diferentes seeds). Normalmente, se suele hacer para cada K, 10 o 20 repiticiones. Luego para cada o bien se resumen los resultados de las diferentes corridas, o se selecciona la corrida con mayor verisimilitud. Aconsejamos usar PONG para la primera opción. El limitante de graficar con PONG es que cuando un grupo poblacional es reducido (1 o 2 individuos), no se ve bien en los grafícos. Hoy no lo necesitamos porque hacemos una sola repetición para cada K.\
En este caso, usaremos un script casero en R que permite guardar los individuos en un ordén más simple de interpretar y con los componentes representados con un codígo colores consistente entre diferentes K.\
Correr `Rscript 5_plotAdmixture.R`. En `Outputs/Admixture/`, Se generan 3 archivos para cada K:
- un `.pdf` con el grafíco
- un `.AncestryComponentByIndividual.txt` con los resultados guardados originalmente en el  `.Q` pero con anotaciones (id del individuo, población, etc.).
- un `.MeanByGroup.txt` con los promedios de las proporciones de ancestria por poblacion.

Mirando los grafícos para diferentes K
- Tratar de interpretar los diferentes componentes. A diferentes K, cada color se interpreta exactamente igual? Es decir cada componente representa exactamente la misma ancestria genética?
- Cuando vemos patrones muy distinctos para algunos individuos a K elevados, empezamos a sospechar que el modelo no explica bien los datos. Identificar hasta que K los resultados parecen robustos.
- Que patrones podemos identificar para Patagonia a través del tiempo?
- A qué grupos de sudamerica parecen estar más cercanas las poblaciones de Patagonia?
- Podemos identificar una estructura en la región?
- Parece haber una continuidad entre poblaciones pre y pos-contacto?

# F-statistics (si tenemos tiempo)

Vamos ahora utlisar Admixtools ([https://github.com/DReichLab/AdmixTools](https://github.com/DReichLab/AdmixTools)) para calcular diferentes estadísticos F. 
Usaremos los archivos `StartingData/ModernAncient_ForFstats.{geno,snp,ind}.txt` donde los individuos modernos (salvo los Mbuti) está atribuidos a la población "Ignore" para no considerarlos en los cálculos de F-stats. En Admixtools, la unidad de analísis es la población. Se comparán las frecuencias alélicas entre 3 o 4 poblaciones (hablamos de F3 o F4). Los resultados son un índice F asociado a un Z score: Z =  (F-esp(F))/std(F). La esperanza y el error estándar se calculan estimando el F en diferentes partes del genoma usando un procesamiento jackknife. El Z es un truco estadístico muy usado que permite inferir si un F es significativamente superior a 0 (Z>3) o inferior 0 (Z<3). Los detalles teóricos acerca de los F y los Z están descritos en [Patterson et al 2012](https://academic.oup.com/genetics/article/192/3/1065/5935193), [Lipson et al. 2020](https://onlinelibrary.wiley.com/doi/abs/10.1111/1755-0998.13230).

## F3-Outgroup
Usando el F de la forma F(Ind1,Ind2;Mbuti), Mbuti siendo el outgroup, podemos inferir las similitudes entre pares de individuos. Usando despues 1-F3, tenemos una distancia genética entre individuos, bastante robusta a la presencia de valores faltantes. \
Vamos a usar el script `6_F3.sbatch ` que permite preparar los archivos para calcular F3, estimar los F3, y formatear la salida.
Primero, vamos a estimar  los F3 usando la función `qp3Pop`. \
Pero tenemos que definir como entidad de analísis el individuo (y no la población): hay que cambiar el archivo `.ind.txt` para atribuir como "población" el ID del individuo (guardamos Mbuti como población ya que es nuestro outgroup). \
Luego, tenemos que guardar la lista de las comparaciones que queremos hacer en un archivo con 3 columnas (Ind1 | Ind2 | Outgroup).\
Tenemos también que generar un archivo de paramétros donde se estipula:
-los archivos de entrada
- el archivo de lista de comparaciones
- unas opciones.
Finalmente podemos lanzar los cálculos con `qp3Pop -p <paramfile>`. Pero, los resultados se imprimen normalmente en plantala (stdout), por eso es importante que redireccionar la salida hacía el archivo deseado. Ademas, queremos poner la salida de `qp3Pop` en limpio para ser leída facílmente con R después. \
Correr `sbatch 6_F3.sbatch`. Mientras corre, tratar de obtener el número de combinaciones para cúales se van a calcular el F3.
Generar un plot de Multidimensional Scaling a partir de las distancias genéticas estimadas con el F3-outgroup con `Rscript 7_plotMDS_F3.R`. Descargar en su computadora el pdf generado:
`scp <user>@mulatona.ccad.unc.edu.ar:/home/<user>/JNAB/dia2/sesion5/Output/F3/F3_BtwInds.Cleaned.pdf . `. 

- Que conclusiones podemos sacar del plot Dimension2 vs Dimension2? Del Dimension4 vs Dimension5? Y de Dimension6 vs Dimension5?







