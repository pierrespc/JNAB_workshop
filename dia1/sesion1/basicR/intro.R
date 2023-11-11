#### Directorio de trabajo ####

getwd()                             # mostrar directorio de trabajo
setwd("/home/user/myRscripts/")     # mostrar directorio de trabajo

#### Obtener ayuda ####

help(help)                # función help()
?help                     # equivalente al anterior
??help                    # busca la palabra en "todas" las ayudas
example("plot")           # ejemplos de uso de las funciones

#### Instalar y cargar paquetes ####

install.packages("paquetes")   # instalar uno o más paquetes (separar por comas)
library("paquete")             # cargar uno o más paquetes (separar por comas)

#### Objetos básicos ####
##### Integer, flotantes y strings #####

a <- 2                     
b = 3
a + b
c <- a * b
d <- pi
d
e <- 7.8e-14
e*10000
texto <- "Esta es una cadena de texto"
texto

##### Vectores #####

vect1 <- c(1,2,3,4,5,6)
vect1

vect1 * 2

vect2 <- c(10, 20, 30, 40, 50, 60)

vect1 + vect2
vect1 * vect2

vtex <- c("Bienvenides", "al", "emocionante", "mundo", "de", "R")
vtex

vect[1]     # Accediendo al 1er elemento del vector
vect[6]     # Accediendo al 6to elemento del vector

vtex[c(1,3,6)]   # Accediendo a un conjunto de elementos

##### Matrices #####

?matrix     # Ver documentación de la función matrix()
?seq        # Ver documentación de la función seq()

mx <- matrix(seq(1,9), nrow=3, ncol=3)
mx

mx[2,3]     # Accediendo a un elemento [fila, columna]
mx[3,2]

mx[c(1,2),c(1,2)]    # Subset de la matriz

##### Data Frames #####

?as.data.frame      # Ver documentación de la función as.data.frame()

df <- as.data.frame(mx)
df

colnames(df) <- c("A", "B", "C")    # Asignando nombres a las columnas
df

df$B            # Accediendo a la columna "B" (i.e. obtener el vector correspondiente)

df$D <- c(10,11,12)   # Creando una nueva columna en el DF
df

df[1:2]        # Accediendo a las primeras 2 columnas

df[,3]         # Accediendo a la 3ra columna [filas, columnas]

df[3,]         # Accediendo a la 3ra fila [filas, columnas]

df[df$A == 2,]  # Accediendo a partes del DF por condiciones


###### Importando y jugando con datos ######

iris <- read.delim("iris.csv", sep=",", dec=".", header=T)
summary(iris)    # Ver resumen de datos en el DF

iris$variety <- as.factor(iris$variety)   # Asignando una variable como "factor"
summary(iris)

head(iris)

iris[iris$variety == "Setosa",]   # Partiendo el DF por condiciones

mean(iris[iris$variety == "Setosa",]$sepal.width)  # Operando sobre una variable


#### Gráficos ####

plot(x=iris$variety, y=iris$petal.length)    # Largo de pétalo por Especie

plot(x=iris$petal.length, y=iris$petal.width,  # Ancho vs largo de pétalos
     col=iris$variety, pch=16)


# Bucle "for" para añadir etiquetas con la media de las variables
for (var in unique(iris$variety)) {
  
    mn_ln <- mean(iris[iris$variety == var,]$petal.length)
    mn_wd <- mean(iris[iris$variety == var,]$petal.width)
   
    legend(var, x=mn_ln, y=mn_wd, box.col = NA, bg="white",
           xjust=.5, yjust=.5, cex=.6, adj=0.2)
    
}

# Generando más de un gráfico por panel
par(mfrow=c(1,3))                     # Parte el panel en (filas, columnas)

for (var in unique(iris$variety)) {    # Bucle for para generar cada gráfico
  
  hist(iris[iris$variety == var,]$petal.length,
       main=var, xlab="Petal length")
}
