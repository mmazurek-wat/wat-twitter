
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

BI_txt[1:3]
BI_clean[1:3]

#Join texts in a vector for each company
BI = paste(BI_clean, collapse=" ")
DS = paste(DS_clean, collapse=" ")
DM = paste(DM_clean, collapse=" ")
BD = paste(BD_clean, collapse=" ")




# put everything in a single vector
all = c(BI, DS, DM, BD)


# remove stop-words
all = removeWords(all,
                  c(stopwords("english"), "business", "intelligence", "data", "mining", "science", "businessintelligence"))



# create corpus
corpus = Corpus(VectorSource(all))

# create term-document matrix
tdm = TermDocumentMatrix(corpus)

# convert as matrix
tdm = as.matrix(tdm)

# add column names
colnames(tdm) = c("Business Intelligence", "Data Science", "Data Mining", "Big Data")

# comparison cloud
comparison.cloud(tdm, random.order=FALSE, 
                 colors = c("#00B2FF", "red", "#FF0099", "#6600CC"),
                 title.size=1.5, max.words=500)

