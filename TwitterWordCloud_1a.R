
#zaladowanie  zapisanych obiektow 
load("D:/tweetsBI")
tweets<-tweetsBI
tweets[[2]]




#zaladowanie niezbednych pakietow 
library(tm) 

# przeksztalcenie listy w obiekt data frame 

tweets_df = twListToDF(tweets)

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
corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, stemCompletion, dictionary=corpus.copy)
#inspect (corpus)

# create document term matrix applying some transformations
tdm = TermDocumentMatrix(corpus)
dtm=DocumentTermMatrix(corpus)

dtm
# define tdm as matrix
m = as.matrix(tdm)
dtm.matrix<-as.matrix(dtm)
summary(dtm.matrix)

# get word counts in decreasing order

word_freqs = sort(colSums(dtm.matrix), decreasing=TRUE) 

names(word_freqs[1:100])

names(dtm.matrix[1,])

dtm.matrix.subs<-dtm.matrix[,c(names(word_freqs[1:100]))]






library(wordcloud)
library(RColorBrewer)

# create a data frame with words and their frequencies
dm = data.frame(word=names(word_freqs[1:100]), freq=word_freqs[1:100])

# plot wordcloud
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

pca<-princomp(dtm.matrix.subs)
summary(pca)
screeplot(pca)
twit.pca<-pca$score[1:100,1:2]

attach(pca$score[,1:2])
plot(sr~dpi, xlim = c(0, 3500), xlab = 'Real Per-Capita Disposable Income', ylab = 'Aggregate Personal Savings', main = 'Intercountry Life-Cycle Savings Data', data = LifeCycleSavings[1:9,])
plot(pca$score[1:100,1:2],labels=rownames(pca$score[1:100,1:2]))
#dodanie nazw do kolumn 

rownames(twit.pca)<-as.character(seq(1:100))
colnames(twit.pca)<-c("x","y")
df<-data.frame(twit.pca)
df[, "idx"] <-paste("d",as.character(seq(1:100)),sep="")
df

scatterplot(x ~ y, data=df, reg.line=FLASE,smoother=FALSE, labels=idx)

dim(df)

plot(x ~ y, df)
with(df, showLabels(x, y,  labels = idx))
