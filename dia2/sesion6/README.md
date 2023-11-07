# Sesión 6: Práctico Diversidad y Estructura poblacional
# F-statistics

En esta sesión aprenderemos a estimar la afinidad genética y mestizaje entre poblaciones con los índices f3 y D implementados en ADMIXTOOLS.

Trabajaremos con los archivos generados en sesiones anteriores. En particular, necesitaremos:
- Archivos en formato eigenstrat: *.geno, *.ind, *.snp
- Archivo con parámetros del análisis
- Archivo `popfilename`: archivo *.txt con lista de tests


## Outgroup-f3: caso especial de f3

Para estimar el outgroup-f3 utilizaremos el módulo qp3pop de ADMIXTOOLS (https://github.com/DReichLab/AdmixTools/blob/master/README.3PopTest
). Los parámetros del análisis son especificados en un archivo de texto que debe tener, al menos, las siguientes líneas:

```
genotypename:   prefix.geno
snpname:   prefix.snp
indivname:   prefix.ind
popfilename:  example.txt
inbreed: NO
```

El archivo especificado en popfilename debe tener 3 poblaciones por línea, siendo la tercera posición ocupada por el outgroup. Por ejemplo: `popA popB Mbuti`. Este archivo puede tener tantas líneas como tests a evaluar.

El nombre de la "población" está determinado por la tercera columna del archivo *.ind.  

### Aplicación en Patagonia
Realizamos una seria de tests con el objetivo de evaluar las afinidades genéticas en la región de Patagonia. En primer lugar, evaluaremos de individuos tempranos (Holoceno Medio) y el resto de los grupos antiguos y modernos disponibles en el set de datos.

- Primero, usaremos R para reemplazar los ID de las poblaciones en el archivo *.ind:
Ejecutar R y realizar reemplazo de IDs de la siguiente forma:
```
d = read.table("prefix.ind")
r = read.table("metadata_curso_jnab2023_fn.csv", header = T, sep =",")
d$V3 = r$popID[match(d$V1, r$indivID)]
sum(is.na(d$V3))
```

Si el ouput del último comando (`sum`) es cero, continuar con
`write.table(d, "prefix_popID.ind", col.names = F, row.names = F, quote = F)`

- Segundo, elaboraremos una lista de los test a realizar:
  - Extraer lista única de poblaciones: `cut -d" " -f3 prefix_popID.ind | sort | uniq > unique.poplist`
  - Crear archivo de texto con los IDs de los individuos tempranos (3º columna archivo *.ind) usando `nano target.poplist`:

  Chile_PuntaSantaAna_7300BP
  Chile_WesternArchipelago_Ayayema_4700BP
  Argentina_NorthTierradelFuego_LaArcillosa2_5800BP

  - Generar lista de comparaciones:
  
```
for i in `cat target.poplist`;do for j in `cat unique.poplist`;do echo $i $j Mbuti;done;done | awk '$1 != $2' > PatagoniaMH.X.Mbuti.txt
```

- Tercero: correr qp3Pop usando sbatch (script `1_outgroupf3.sbatch`) y utilizando como `popfilename` el último archivo generado. En el archivo de parámetro, recuerda reemplazar el `indivname` por el archivo creado en R.


### Análisis opcional:
En caso de haber realizado el paso 4 de la sesión 4, evaluaremos la afinidad genética de este individuo con todas las poblaciones o grupos del archivo eigenstrat. Para ello:
- Crear archivo poplistname:
  - Crear archivo de 3 columnas: `awk '{print "genoma_antiguoX",$1,"Mbuti"}' unique.poplist`

- Modificar archivo `ejemplo.par` con los nombres correspondientes

- Correr qp3pop usando sbatch (modificar 1_outgroupf3.sbatch según corresponda)

### Figuras

Usar script `plots_outgf3.R` en Rstudio para realizar plots. 


## D-statistic
