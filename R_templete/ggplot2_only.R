# This is the template of ggplot functions
# The source page address is written down below
# https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf

### One variable

# One continuous varaible

a = ggplot(mpg, aes(hwy))

a + geom_area(stat="bin", binwidth =1) # x,y,alpha,color,fill,linetype,size
a + geom_density(kernel="gaussian") # x,y,alpha,color,fill,linetype,size,weight
a + geom_dotplot(binwidth=1) # x,y,alpha,color,fill
a + geom_freqpoly(binwidth=1) # x,y,alpha,color,linetype,size
a + geom_histogram(binwidth=5) # x,y,alpha,color,fill,linetype,size,weight
a + stat_bin(binwidth = 1, origin = 10) # x, y | ..count.., ..ncount.., ..density.., ..ndensity..
a + stat_bindot(binwidth = 1, binaxis = "x") # x, y, | ..count.., ..ncount..
a + stat_density(adjust = 1, kernel = "gaussian") # x, y, | ..count.., ..density.., ..scaled..

o <- a + geom_dotplot(aes(fill = ..x..))
o + scale_fill_gradient(low = "red",high = "yellow")
# not working: o + scale_fill_gradient2(low = "red", hight = "blue",mid = "white", midpoint = 25)
o + scale_fill_gradientn(colours = terrain.colors(6))
# Also: rainbow(), heat.colors(),
# topo.colors(), cm.colors(),
# RColorBrewer::brewer.pal()


# One discrete varaible

b = ggplot(mpg, aes(fl))
b + geom_bar()
n <- b + geom_bar(aes(fill = fl)) 
n + scale_fill_manual(
  values = c("skyblue", "royalblue", "blue", "navy"),
  limits = c("d", "e", "p", "r"), breaks =c("d", "e", "p", "r"),
  name = "fuel", labels = c("D", "E", "P", "R"))

n <- b + geom_bar(aes(fill = fl))
n + scale_fill_brewer(palette = "Blues")
#For palette choices:library(RColorBrewer)
display.brewer.all()
n + scale_fill_grey(start = 0.2, end = 0.8,na.value = "red") 


r <- b + geom_bar()
r + coord_cartesian(xlim = c(0, 5))
# xlim, ylim
# The default cartesian coordinate system
r + coord_fixed(ratio = 1/2)
# ratio, xlim, ylim
#Cartesian coordinates with fixed aspect
#ratio between x and y units
r + coord_flip()
#xlim, ylim
#Flipped Cartesian coordinates
r + coord_polar(theta = "x", direction=1 )
#theta, start, direction
#Polar coordinates
r + coord_trans(ytrans = "sqrt")
#xtrans, ytrans, limx, limy
#Transformed cartesian coordinates. Set
#extras and strains to the name
#of a window function

r + theme_bw() # White backgroundn with gridlines
r + theme_grey() #  Grey background _ defaults
r + theme_classic() # White background no gridlines
r + theme_minimal() # Minimal theme

z + coord_map(projection = "ortho",
              orientation=c(41, -74, 0))
#projection, orientation, xlim, ylim
#Map projections from the mapproj package
#(mercator (default), azequalarea, lagrange, etc.)
### Graphical Primitives

c = ggplot(map,aes(long,lat))

d = ggplot(economics, aes(date, unemploy))
d + geom_path(lineend="butt", linejoin = "round", linemitre = 1, color = "blue") # x,y,alpha,color,linetype,size
d + geom_ribbon(aes(ymin=unemploy-900,ymax=unemploy+900)) # x,ymin,ymax,alpha,color,fill,linetype,size

e = ggplot(seals,aes(x=long,y=lat))
e + geom_segment(aes(xend = long + delta_long,yend = lat + delta_lat)) # x, xend, y, yend, alpha, color, linetype, size 
e + geom_rect(aes(xmin = long, ymin = lat,
                  xmax= long + delta_long,
                  ymax = lat + delta_lat)) # xmax, xmin, ymax, ymin, alpha, color, fill,linetype, size

### Two variables

# Continuous X, Continuous Y
f <- ggplot(mpg, aes(cty, hwy))
f + geom_blank()
f + geom_jitter() # x, y, alpha, color, fill, shape, size
f + geom_point() # x, y, alpha, color, fill, shape, size
f + geom_point(position = "jitter")
# For geom_quantile(), install.packages("quantreg")
f + geom_quantile() # x, y, alpha, color, linetype, size, weight
f + geom_rug(sides = "bl") # alpha, color, linetype, size
f + geom_smooth(method = "lm") # x, y, alpha, color, fill, linetype, size, weight
f + geom_smooth(method = "glm", formula = y~x, family = gaussian(link = 'log'))
f + geom_text(aes(label = cty)) # x, y, label, alpha, angle, color, family, fontface,hjust, lineheight, size, vjust
f + stat_bin2d(bins = 30, drop = TRUE) # x, y, fill | ..count.., ..density..
f + stat_binhex(bins = 30) # x, y, fill | ..count.., ..density..
f + stat_density2d(contour = TRUE, n = 100) # x, y, color, size | ..level..
f + stat_ecdf(n = 40) # x, y | ..x.., ..y..
f + stat_quantile(quantiles = c(0.25, 0.5, 0.75), formula = y ~ log(x),
                  method = "rq") # x, y | ..quantile.., ..x.., ..y..
f + stat_smooth(method = "auto", formula = y ~ x, se = TRUE, n = 80,
                fullrange = FALSE, level = 0.95) # x, y | ..se.., ..x.., ..y.., ..ymin.., ..ymax..


p <- f + geom_point(aes(shape = fl))
p + scale_shape(solid = FALSE)
p + scale_shape_manual(values = c(3:7))
q <- f + geom_point(aes(size = cyl))
# not working: q + scale_size_area(max = 6)

# Discrete X, Continuous Y
g <- ggplot(mpg, aes(class, hwy))
g + geom_bar(stat = "identity") # x, y, alpha, color, fill, linetype, size, weight
g + geom_boxplot() # lower, middle, upper, x, ymax, ymin, alpha, color, fill, linetype, shape, size, weight
g + geom_dotplot(binaxis = "y", stackdir = "center")
g + stat_boxplot(coef = 1.5) # x, y | ..lower.., ..middle.., ..upper.., ..outliers..
g + stat_ydensity(adjust = 1, kernel = "gaussian", scale = "area") # x, y | ..density.., ..scaled.., ..count.., ..n.., ..violinwidth.., ..width..

# Discrete X, Discrete Y

h <- ggplot(diamonds, aes(cut, color))
h + geom_jitter() # x, y, alpha, color, fill, shape, size

# Continuous Bivariate Distribution
i <- ggplot(movies, aes(year, rating))
i + geom_bin2d(binwidth = c(5, 0.5)) # xmax, xmin, ymax, ymin, alpha, color, fill,linetype, size, weight
i + geom_density2d() # x, y, alpha, colour, linetype, size
# for geom_hex function, install.packages("hexbin")
i + geom_hex() # x, y, alpha, colour, fill size
i + stat_density2d(aes(fill = ..level..),
                   geom = "polygon", n = 100)

# Continuous Function
j <- ggplot(economics, aes(date, unemploy))
j + geom_area() # x, y, alpha, color, fill, linetype, size
j + geom_line() # x, y, alpha, color, linetype, size
j + geom_step(direction = "hv") # x, y, alpha, color, linetype, size


# Visualizing error
df <- data.frame(grp = c("A", "B"), fit = 4:5, se = 1:2)
k <- ggplot(df, aes(grp, fit, ymin = fit-se, ymax = fit+se))
k + geom_crossbar(fatten = 2) # x, y, ymax, ymin, alpha, color, fill, linetype,size
k + geom_errorbar() # x, ymax, ymin, alpha, color, linetype, size, width (also geom_errorbarh())
k + geom_linerange() # x, ymin, ymax, alpha, color, linetype, size
k + geom_pointrange() # x, y, ymin, ymax, alpha, color, fill, linetype, shape, size

# Three Variables
seals$z <- with(seals, sqrt(delta_long^2 + delta_lat^2))
m <- ggplot(seals, aes(long, lat))
m + geom_contour(aes(z = z)) # x, y, z, alpha, colour, linetype, size, weight
m + geom_raster(aes(fill = z), hjust=0.5,
                vjust=0.5, interpolate=FALSE) # x, y, alpha, fill
m + geom_tile(aes(fill = z)) # x, y, alpha, color, fill, linetype, size
m + stat_contour(aes(z = z)) # x, y, z, order | ..level..
m + stat_spoke(aes(radius= z, angle = z)) # angle, radius, x, xend, y, yend | ..x.., ..xend.., ..y.., ..yend..
m + stat_summary_hex(aes(z = z), bins = 30, fun = mean) # x, y, z, fill | ..value..
m + stat_summary2d(aes(z = z), bins = 30, fun = mean) # x, y, z, fill | ..value..

# Position Adjustment

s <- ggplot(mpg, aes(fl, fill = drv))
s + geom_bar(position = "dodge") # Arrange elements side by side
s + geom_bar(position = "fill") # Stack elements on top of one another,normalize height
s + geom_bar(position = "stack") # Stack elements on top of one another
s + geom_bar(position = position_dodge(width = 1)) # width and height can be recast

# Faceting

t <- ggplot(mpg, aes(cty, hwy)) + geom_point()
t + facet_grid(. ~ fl) # facet into columns based on fl
t + facet_grid(year ~ .) # facet into rows based on year
t + facet_grid(year ~ fl) # facet into both rows and columns
t + facet_wrap(~ fl) # wrap facets into a rectangular layout

# Titles
t + ggtitle("New Plot Title") # Add a main title above the plot
t + xlab("New X label") # Change the label on the X axis
t + ylab("New Y label") # Change the label on the Y axis
t + labs(title =" New title", x = "New x", y = "New y") # All of the above

# Legends
t + theme(legend.position = "bottom") # Place legend at "bottom", "top", "left", or "right"
t + guides(color = "none") # Set legend type for each aesthetic: colorbar, legend, or none (no legend)
t + scale_fill_discrete(name = "Title", labels = c("A", "B", "C")) # Set legend title and labels with a scale function.

# How to save the plot
ggsave("plot.png", width = 5, height = 5)
# Saves last plot as 5’ x 5’ file named "plot.png" in
# working directory. Matches file type to file extension.
