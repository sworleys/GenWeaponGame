library(cluster) 

dat = read.csv("gun_log.csv", header = TRUE)
speed_size = subset.data.frame(dat,select = c("speed", "size"))
c1 = kmeans(x = speed_size, centers = 2, iter.max = 10, nstart = 1)
#c1 = kmeans(x = speed_size, centers = 2)
clusplot(speed_size, c1$cluster, color=TRUE, shade=TRUE, 
         labels=2, lines=0)


size_burst = subset.data.frame(dat,select = c("size", "burst"))
c1 = kmeans(x = size_burst, centers = 2, iter.max = 10, nstart = 1)
#c1 = kmeans(x = speed_size, centers = 2)
clusplot(size_burst, c1$cluster, color=TRUE, shade=TRUE, 
         labels=2, lines=0)


#size_reproduce = subset.data.frame(dat,select = c("size", "reproduce"))
#c1 = kmeans(x = size_reproduce, centers = 2, iter.max = 10, nstart = 1)
#clusplot(size_reproduce, c1$cluster, color=TRUE, shade=TRUE, 
#         labels=2, lines=0)