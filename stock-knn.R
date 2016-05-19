knn����ѵ�������������ݵ����Է��࣬knn���������κ�ģ�ͣ�ֻ�����ڼ��䡣�����µ��������ҵ�������Χk������������ĳ��������������ô��Щ���������Ĺ����������������𡣲������£�
1.ȷ��kֵ
2.����������������ѵ�������ľ���
3.���������ľ���
4.�ռ�ǰk����С��������ǵ����
5.�ж������������






library(class)
library(dplyr)
library(lubridate)
set.seed(100)

stocks <- read.csv(file.choose())



stocks$Date <- ymd(stocks$Date)
stocksTrain <- year(stocks$Date) < 2014

plot(stocks[,-1]) 
points(5,6,pch=8,cex=3) 

predictors <- cbind(lag(stocks$Apple, default = 210.73), 
                    lag(stocks$Google, default = 619.98),
                    lag(stocks$MSFT, default = 30.48))
colnames(predictors)=c("Apple","Google","MSFT")
plot(stocks[,c(-1,-5)], pch = 20)





train <- predictors[stocksTrain, ] #2014����ǰ������Ϊѵ������
test <- predictors[!stocksTrain, ] #2014���Ժ������Ϊ��������
cl <- stocks$Increase[stocksTrain] #��֪���
colors <- 3-cl

par(mfrow=c(2,2))
plot(lag(stocks$Apple, default = 210.73), stocks$Apple, pch = ".")
plot(lag(stocks$Google, default = 619.98),stocks$Google, pch = ".",col=20)
plot(lag(stocks$MSFT, default = 30.48),stocks$MSFT, pch = ".",col=21)

par(mfrow=c(3,2))
acf(stocks$Apple)#�鿴�����ͼ
pacf(stocks$Apple)#�鿴ƫ���ͼ
acf(stocks$Google)
pacf(stocks$Google)
acf(stocks$MSFT)
pacf(stocks$MSFT)

scatterplot3d(train,col=colors,pch= ".",cex=1,
     xlim=c(0,max(predictors )),ylim=c(0,max(predictors ))) 
points(test,pch= ".") 

cl <- stocks$Increase #��֪�ǵ�
colors <- 3-cl
scatterplot3d(predictors,color=colors, col.axis=5,
      col.grid="lightblue", main="scatterplot3d - 1", pch=20)
 
 

prediction <- knn(train, test, cl, k = 1)  #����KNN�㷨����  
   
table(prediction, stocks$Increase[!stocksTrain])
mean(prediction == stocks$Increase[!stocksTrain])

#ͨ�����ؿ���ģ��ѡ����õ�kֵ
accuracy <- rep(0, 10)
k <- 1:10
for(x in k){
  prediction <- knn(predictors[stocksTrain, ], predictors[!stocksTrain, ],
                    stocks$Increase[stocksTrain], k = x)
  accuracy[x] <- mean(prediction == stocks$Increase[!stocksTrain])
}

plot(k, accuracy, type = 'b')

