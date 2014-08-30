
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
dm
# plot wordcloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))


#wartosc 
lim = quantile(word_freqs, probs=0.8)
lim


wc=rowSums(m)
#only frequent words
m_subset = m[wc > lim,]
word_freqs_subset=word_freqs[wc > lim]


dm1 = data.frame(word=names(word_freqs_subset), freq=word_freqs_subset)
dm1

wordcloud(dm1$word, dm1$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

# save the image in png format
png("MachineLearningCloud.png", width=12, height=8, units="in", res=300)
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
dev.off()



# word counts
wc = rowSums(m)
wc


# remove columns (docs) with zeroes
good = good[,colSums(good)!=0]














# extract the text content of the first tweet
tweets[[1]]$getText()
# getScreenName: extract the user name of a single element
tweets[[1]]$getScreenName()
# getId: extract the tweet Id number
tweets[[1]]$getId()
# getCreated: extract date and time of publication of a single element
tweets[[1]]$getCreated()
#getStatusSource: extract source user agent of a single element
tweets[[1]]$getStatusSource()


# extract the text content of the all the tweets
sapply(tweets, function(x) x$getText())

# extract the user name of the all the tweets
sapply(tweets, function(x) x$getScreenName())

# extract the Id number of the all the tweets
sapply(tweets, function(x) x$getId())

# extract the date and time of publication of the all the tweets
dates=sapply(tweets, function(x) x$getCreated())

# extract the source user agent of the all the tweets
sapply(tweets, function(x) x$getStatusSource())





#histogram dla dat (liczba tweetow)
ggplot(tweets_df, aes(x=Dates)) + geom_histogram(binwidth=30, colour="white") + scale_x_date(labels = date_format("%Y-%b"),  breaks = seq(min(tweets_df$dates)-5, max(tweets_df$dates)+5, 30),                     limits = c(as.Date("2008-05-01"), as.Date("2012-04-01"))) +               ylab("Frequency") + xlab("Year and Month") +                 theme_bw() + opts(axis.text.x = theme_text(angle=90))

