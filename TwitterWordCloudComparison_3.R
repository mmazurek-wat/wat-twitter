
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
all = c(BI,  BD)


# remove stop-words
all = removeWords(all,
                  c(stopwords("english"), "business", "intelligence", "data", "big", "bigdata", "mining", "science", "businessintelligence"))



# create corpus
corpus = Corpus(VectorSource(all))

# create term-document matrix
tdm = TermDocumentMatrix(corpus)

# convert as matrix

inspect(tdm)




df = as.data.frame(inspect(tdm))
names(df) = c("BusinessIntelligence", "BigData")

# get rid of low frequency words
df = subset(df, BusinessIntelligence>2 & BigData>2)

# calculate frequency differences
df$freq.dif = df$BusinessIntelligence - df$BigData

# twitted more often by Business Intelligence
BI_df = subset(df, freq.dif > 0)

# twitted more often by Big Data 
BD_df = subset(df, freq.dif < 0)

# twitted equally
both_df = subset(df, freq.dif == 0)


# function
optimal.spacing <- function(spaces)
{
  if(spaces > 1) {
    spacing <- 1 / spaces
    if(spaces%%2 > 0) {
      lim = spacing * floor(spaces/2)
      return(seq(-lim, lim, spacing))
    }
    else {
      lim = spacing * (spaces-1)
      return(seq(-lim, lim, spacing*2))
    }
  }
  else {
    # add some jitter when 0
    return(jitter(0, amount=0.2))
  }
}


# Get spacing for each frequency type
BI_spacing = sapply(table(BI_df$freq.dif),
                       function(x) optimal.spacing(x))

BD_spacing = sapply(table(BD_df$freq.dif),
                        function(x) optimal.spacing(x))

both_spacing = sapply(table(both_df$freq.dif),
                      function(x) optimal.spacing(x))


# add spacings
BI_optim = rep(0, nrow(BI_df))
for(n in names(BI_spacing)) {
  BI_optim[BI_df$freq.dif == as.numeric(n)] <- BI_spacing[[n]]
}
BI_df = transform(BI_df, Spacing=BI_optim)

BD_optim = rep(0, nrow(BD_df))
for(n in names(BD_spacing)) {
  BD_optim[BD_df$freq.dif == as.numeric(n)] <- BD_spacing[[n]]
}
BD_df = transform(BD_df, Spacing=BD_optim)

both_df$Spacing = as.vector(both_spacing)

library(ggplot2)
# use ggplot
ggplot(BI_df, aes(x=freq.dif, y=Spacing)) +
  geom_text(aes(size=BusinessIntelligence, label=row.names(BI_df),
                colour=freq.dif), alpha=0.7) +
  geom_text(data=BD_df, aes(x=freq.dif, y=Spacing,
                                label=row.names(BD_df), size=BigData, color=freq.dif),
            alpha=0.7) +
  geom_text(data=both_df, aes(x=freq.dif, y=Spacing,
                              label=row.names(both_df), size=BusinessIntelligence, color=freq.dif),
            alpha=0.7) +
  scale_size(range=c(3,11)) +
  scale_colour_gradient(low="red3", high="blue3", guide="none") +
  scale_x_continuous(breaks=c(min(BD_df$freq.dif), 0, max(BI_df$freq.dif)),
                     labels=c("Twitted More BD","Twitted Equally","Twitted More by BI")) +
  scale_y_continuous(breaks=c(0), labels=c("")) +
  labs(x="", y="", size="Word Frequency") +
  ggtitle("...") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
       panel.grid.minor = element_blank(),
       
       plot.title = element_text( size=18))

warnings()

# save plot in pdf
ggsave("Cloud1.pdf", width=13, height=8, units="in")


BI_df
BD_df
both_df
