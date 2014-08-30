
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

library(igraph)

good
# adjacency matrix
M = good %*% t(good)


M[c('tom', 'agile', 'arent', 'conference', 'hans', 'dec', 'sprekers') , !=0]
ms<-M[c('tom', 'agile', 'arent', 'conference', 'hans', 'dec', 'sprekers') ,]
ms = ms[,colSums(ms)!=0]
ms
# set zeroes in diagonal
diag(M) = 0
M

#function for creating igraph graphs from adjacency matrices.
g = graph.adjacency(M, weighted=TRUE, mode="undirected",
                    add.rownames=TRUE)
g
# layout
#glay = layout.fruchterman.reingold(g)


glay =layout.auto(g)
#layout.random(graph, params, dim=2)
#glay =layout.circle(g)
#glay =layout.sphere(g)
#layout.fruchterman.reingold(graph, ..., dim=2, params)
#layout.kamada.kawai(graph, ..., dim=2, params)
#layout.spring(graph, ..., params)
#layout.reingold.tilford(graph, ..., params)
#layout.fruchterman.reingold.grid(graph, ..., params)
#layout.lgl(graph, ..., params)
#layout.graphopt(graph, ..., params=list())
#layout.svd(graph, d=shortest.paths(graph), ...)
#layout.norm(layout, xmin = NULL, xmax = NULL, ymin = NULL, ymax = NULL,
            zmin = NULL, zmax = NULL)



# let's superimpose a cluster structure with k-means clustering
# Perform k-means clustering on a data matrix.
kmg = kmeans(M, centers=4)
gk = kmg$cluster

# create nice colors for each cluster
gbrew = c("red", brewer.pal(8, "Dark2"))
gpal = rgb2hsv(col2rgb(gbrew))
gcols = rep("", length(gk))
for (k in 1:8) {
  gcols[gk == k] = hsv(gpal[1,k], gpal[2,k], gpal[3,k], alpha=0.5)
}

# prepare ingredients for plot
V(g)$size = 10
V(g)$label = V(g)$name
V(g)$degree = degree(g)
#V(g)$label.cex = 1.5 * log10(V(g)$degree)
V(g)$label.color = hsv(0, 0, 0.2, 0.55)
V(g)$frame.color = NA
V(g)$color = gcols
E(g)$color = hsv(0, 0, 0.7, 0.3)
E(g)$label=E(g)$weight

# plot
plot(g, layout=glay)
title("\nGraph",col.main="gray40", cex.main=1.5, family="serif")
