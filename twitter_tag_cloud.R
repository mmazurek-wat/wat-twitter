library(RCurl) 
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
#cred=getTwitterOAuth("3btKwL8i9u0uHro8xSL95Q", "dTiregisterTwitterOAuth(cred)ugfubpSCnMzE5HZV9lx8CwW247ljjJtC9iaCDSo
#save(cred,"TwitterCred1")

library (twitteR)
load("D:/TwitterCred1") 
registerTwitterOAuth(cred)

# collect tweets in english containing 'big data'
tweets = searchTwitter("analytics", lang="en", n=10000)
tweets<-tweets[1:2000]

tweets
save(tweets,file="analytics_tweets")



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




# convert tweets into a data frame
tweets_df = twListToDF(tweets)
names(tweets_df)

tweets_df
hist( tweets_df$"created", main="Histogram")


tweets_df = transform(tweets_df, Dates = as.Date(created))

ggplot(tweets_df, aes(x=Dates)) + geom_histogram(binwidth=30, colour="white") +
       scale_x_date(labels = date_format("%Y-%b"),
                    breaks = seq(min(tweets_df$dates)-5, max(tweets_df$dates)+5, 30),
                    limits = c(as.Date("2008-05-01"), as.Date("2012-04-01"))) +
       ylab("Frequency") + xlab("Year and Month") +
       theme_bw() + opts(axis.text.x = theme_text(angle=90))




library(tm) 
library(wordcloud)
library(wordcloud)
library(RColorBrewer)
bigdata_tweets = searchTwitter("big data", n=500, lang="en")
tweets<-bigdata_tweets
tweets_text = sapply(tweets, function(x) x$getText())

# create a corpus
corpus = Corpus(VectorSource(tweets_text))

# create document term matrix applying some transformations
tdm = TermDocumentMatrix(corpus,
   control = list(removePunctuation = TRUE,
   stopwords = c("big", "data", "bigdata" , stopwords("english")),
   removeNumbers = TRUE, tolower = TRUE))
tdm
# define tdm as matrix
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing=TRUE) 
# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs), freq=word_freqs)
dm
# plot wordcloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

# save the image in png format
png("MachineLearningCloud.png", width=12, height=8, units="in", res=300)
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
dev.off()

