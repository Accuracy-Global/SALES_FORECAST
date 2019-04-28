
# Map 1-based optional input ports to variables
M1<- maml.mapInputPort(1) # class: data.frame
library(forecast)
library(dplyr)
#x <- strptime(head(M1$Time_Measure[1]), format="%Y-%M")
#d5<-format(x, "%Y")
#d6<-format(x, "%M")
#y <- strptime(tail(M1$Time_Measure,1), format="%Y-%M")
#d51<-format(y, "%Y")
#d61<-format(y, "%m")

g<-rs %>%
  group_by(Country,City,State,Region,Category,SubCategory,ProductName,ProductID,OrderDate) %>%
  summarise(Sales= sum(Sales))
M1<-data.frame(g)
sp1<-split(M1,M1$ProductID)
s2=list()
j2=list()
g2=list()
ra=list()
hj=list()
e=length(unique(M1$ProductID))
for(i in 1:e)
{
  s2[[i]]=ts(sp1[[i]][10],frequency=12)#,start=c(as.numeric(d5),as.numeric(d6)),end=c(as.numeric(d51),as.numeric(d61)))
  j2[[i]]=auto.arima(s2[[i]])
  g2[[i]]=forecast(j2[[i]],h=18)
  ra[[i]]=accuracy(g2[[i]])
  hj[[i]]=ra[[i]][3] 
  
}
data<-data.frame(g2[1:e])
#fghj<-data.frame(hj[1:e])

my=NULL
for(i in seq(from=1, to=(dim(data)[2]),by=5))
{
  my=c(my,i)
}
jr<-data.frame(data[c(my)],2)
jr$X2<-NULL
rt<-t(jr)
#MAE<-t(fghj)
sdf<-data.frame(rt)
names(sdf)[1:ncol(sdf)] <- paste0("M", 1:ncol(sdf))
re<-round(abs(sdf)) 
etu1<-data.frame(re)
er5<-unique(M1[c("Country","City","State","Region","Category","SubCategory","ProductName","ProductID")])
er12 <-er5[order(er5$ProductID),]
#er12<-data.frame(er12[-nrow(er12),])
ALGORITHM<-c("AUTOARIMA")
df<-data.frame(ALGORITHM)
#ert<-cbind(er12,etu1,MAE,df)
ert<-cbind(er12,etu1,df)
iu<-data.frame(ert)
View(iu)
# Select data.frame to be sent to the output Dataset port
#maml.mapOutputPort("iu");