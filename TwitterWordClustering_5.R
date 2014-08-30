
library(RCurl) 
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

cred=getTwitterOAuth("consumer key", "consumer secret"))
save(cred,"TwitterCred1")

library (twitteR)
load("D:/TwitterCred1") 
registerTwitterOAuth(cred)


#przyklad rozbudowanej skladni 
tweets = searchTwitter("analytics", since="2012-10-01", until="2013-10-26",  lang="en", n=1000)

tweetsDS = searchTwitter("\"Data Science\"",  lang="en", n=1000)
tweetsBI = searchTwitter("\"Business intelligence\"",  lang="en",  n=1000)
tweetsDM= searchTwitter("\"Data Mining\"",  lang="en",  n=1000)
tweetsBD = searchTwitter("\"Big Data\"", lang="en", n=1000)

#zapisanie wszystkich tweetow 
save(tweetsDS, file="D:/tweetsDS")
save(tweetsBI, file="D:/tweetsBI")
save(tweetsDM, file="D:/tweetsDM")
save(tweetsBD, file="D:/tweetsBD")



# usuniecie pustych pozycji listy 
tweets<-tweets[1:length(tweets)]

#zaladowanie  zapisanych obiektow 

load("D:/tweetsDS")
load("D:/tweetsBI")
load("D:/tweetsDM")
load("D:/tweetsBD")


tweets<-tweetsBI
tweets[[1]]

#zaladowanie niezbednych pakietow 
library(tm) 

#wygenerowanie sampli  
tweetsBI_sample<-sample(tweetsBI,200)
tweetsDS_sample<-sample(tweetsDS,200)
tweetsDM_sample<-sample(tweetsDM,200)
tweetsBD_sample<-sample(tweetsBD,200)

# get text
BI_txt = sapply(tweetsBI_sample, function(x) x$getText())
DS_txt = sapply(tweetsDS_sample, function(x) x$getText())
DM_txt = sapply(tweetsDM_sample, function(x) x$getText())
BD_txt = sapply(tweetsBD_sample, function(x) x$getText())

#zdefiniowanie funkcji do czyszczenia danych 

clean.text = function(x)
{
  # tolower
  x = tolower(x)
  # remove links http
  x = gsub( "(http|https)://(.+$)|(//B)", " ",x)
  # remove rt
  x = gsub("rt", " ", x)
  # remove at
  x = gsub("@\\w+", " ", x)
  # remove punctuation
  x = gsub("[[:punct:]]", " ", x)
  # remove numbers
  x = gsub("[[:digit:]]", " ", x)    
  # remove tabs
  x = gsub("[ |\t]{2,}", " ", x)
  # remove blank spaces at the beginning
  x = gsub("^ ", "", x)
  # remove blank spaces at the end
  x = gsub(" $", "", x)
  return(x)
}

# get text
BI_txt = sapply(tweetsBI_sample, function(x) x$getText())
DS_txt = sapply(tweetsDS_sample, function(x) x$getText())
DM_txt = sapply(tweetsDM_sample, function(x) x$getText())
BD_txt = sapply(tweetsBD_sample, function(x) x$getText())


# clean texts
BI_clean = clean.text(BI_txt)
DS_clean = clean.text(DS_txt)
DM_clean = clean.text(DM_txt)
BD_clean = clean.text(BD_txt)

BI_clean<-sub( "(http|https)://(.+$)|(//B)", "", BI_clean,fixed=FALSE, ignore.case=TRUE)



# create corpus
corpus = Corpus(VectorSource(BI_clean))
inspect(corpus)

# remove stopwords
skipwords = c(stopwords("english"), 
              "business", "intelligence", "businessintelligence")
corpus = tm_map(corpus, removeWords, skipwords)


BI_clean[c(50,52,95, 170)]
BI_clean[52]
BI_clean[95]
BI_clean[170]

tweetsBI_sample[95]
tweetsBI_sample[50]
tweetsBI_sample[52]
BI_clean[c(50,52,95, 170)]

# term-document matrix
tdm = TermDocumentMatrix(corpus)
# convert tdm to matrix
m = as.matrix(tdm)


m['agile',]

# word counts
wc = rowSums(m)
lim = quantile(wc, probs=0.9)
good = m[wc > lim,]

# remove columns (docs) with zeroes
good = good[,colSums(good)!=0]    
good[good>1] = 1 

library(igraph)


# distance matrix with binary distance
m1dist = dist(good, method="binary")

# cluster with ward method
clus1 = hclust(m1dist, method="ward")

# plot dendrogram
plot(clus1, cex=0.7)
library(FactoMineR)

# correspondance analysis
rei_ca = CA(good, graph=TRUE)
good
rei_ca

# default plot of words
plot(rei_ca$row$coord, type="n", xaxt="n", yaxt="n", xlab="", ylab="")
text(rei_ca$row$coord[,1], rei_ca$row$coord[,2], labels=rownames(good),
     col=hsv(0,0,0.6,0.5))
title(main="Correspondence Analysis of tweet words", cex.main=1)

