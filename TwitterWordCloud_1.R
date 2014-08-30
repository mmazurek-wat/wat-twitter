
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
load("D:/tweetsBI")
tweets<-tweetsBI
tweets[[1]]

#zaladowanie niezbednych pakietow 
library(tm) 

# przeksztalcenie listy w obiekt data frame 
tweets_sample<-sample(tweets,100)
tweets_df = twListToDF(tweets_sample)
names(tweets_df)


#usuniecie linkow  zaczynajacych sie od http 
tweets_df$text<-sub( "(http|https)://(.+$)|(//B)", "", tweets_df$text,fixed=FALSE, ignore.case=TRUE)
tweets_df$text[1:3]


# create a corpus
corpus <- Corpus(VectorSource(tweets_df$text))
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords,  c(stopwords('english'), "business", "intelligence", "businessintelligence"))

corpus.copy<-corpus
#corpus <- tm_map(corpus, stemDocument)
#corpus <- tm_map(corpus, stemCompletion, dictionary=corpus.copy)
#inspect (corpus)

# create document term matrix applying some transformations
tdm = TermDocumentMatrix(corpus)


# define tdm as matrix
m = as.matrix(tdm)
# get word counts in decreasing order

word_freqs = sort(rowSums(m), decreasing=TRUE) 
word_freqs[1:10]


library(wordcloud)
library(RColorBrewer)

# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
# plot wordcloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
