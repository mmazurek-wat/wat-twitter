
R version 3.0.1 (2013-05-16) -- "Good Sport"
Copyright (C) 2013 The R Foundation for Statistical Computing
Platform: i386-w64-mingw32/i386 (32-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> utils:::menuInstallPkgs()
--- Please select a CRAN mirror for use in this session ---
also installing the dependencies ‘digest’, ‘bitops’, ‘ROAuth’, ‘RCurl’, ‘rjson’

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/digest_0.6.3.zip'
Content type 'application/zip' length 136316 bytes (133 Kb)
opened URL
downloaded 133 Kb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/bitops_1.0-6.zip'
Content type 'application/zip' length 35878 bytes (35 Kb)
opened URL
downloaded 35 Kb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/ROAuth_0.9.3.zip'
Content type 'application/zip' length 50300 bytes (49 Kb)
opened URL
downloaded 49 Kb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/RCurl_1.95-4.1.zip'
Content type 'application/zip' length 2836672 bytes (2.7 Mb)
opened URL
downloaded 2.7 Mb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/rjson_0.2.13.zip'
Content type 'application/zip' length 492273 bytes (480 Kb)
opened URL
downloaded 480 Kb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/twitteR_1.1.7.zip'
Content type 'application/zip' length 321359 bytes (313 Kb)
opened URL
downloaded 313 Kb

package ‘digest’ successfully unpacked and MD5 sums checked
package ‘bitops’ successfully unpacked and MD5 sums checked
package ‘ROAuth’ successfully unpacked and MD5 sums checked
package ‘RCurl’ successfully unpacked and MD5 sums checked
package ‘rjson’ successfully unpacked and MD5 sums checked
package ‘twitteR’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
        C:\Users\mma\AppData\Local\Temp\RtmpMhvlv1\downloaded_packages
> local({pkg <- select.list(sort(.packages(all.available = TRUE)),graphics=TRUE)
+ if(nchar(pkg)) library(pkg, character.only=TRUE)})
Loading required package: ROAuth
Loading required package: RCurl
Loading required package: bitops
Loading required package: digest
Loading required package: rjson
>  cred = getTwitterOAuth(YOURKEY, YOURSECRET)
Error in initRefFields(.self, .refClassDef, as.environment(.self), list(...)) : 
  object 'YOURKEY' not found
> cred=getTwitterOAuth(YOURKEY, YOURSECRET)
Error in initRefFields(.self, .refClassDef, as.environment(.self), list(...)) : 
  object 'YOURKEY' not found
> cred=getTwitterOAuth(3btKwL8i9u0uHro8xSL95Q, dTiugfubpSCnMzE5HZV9lx8CwW247ljjJtC9iaCDSo )
Error: unexpected symbol in "cred=getTwitterOAuth(3btKwL8i9u0uHro8xSL95Q"
> cred=getTwitterOAuth('3btKwL8i9u0uHro8xSL95Q', 'dTiugfubpSCnMzE5HZV9lx8CwW247ljjJtC9iaCDSo' )
Error in function (type, msg, asError = TRUE)  : 
  SSL certificate problem, verify that the CA cert is OK. Details:
error:14090086:SSL routines:SSL3_GET_SERVER_CERTIFICATE:certificate verify failed
> cred=getTwitterOAuth("3btKwL8i9u0uHro8xSL95Q", "dTiugfubpSCnMzE5HZV9lx8CwW247ljjJtC9iaCDSo" )
Error in function (type, msg, asError = TRUE)  : 
  SSL certificate problem, verify that the CA cert is OK. Details:
error:14090086:SSL routines:SSL3_GET_SERVER_CERTIFICATE:certificate verify failed
> library(RCurl) 
> options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
> cred=getTwitterOAuth("3btKwL8i9u0uHro8xSL95Q", "dTiugfubpSCnMzE5HZV9lx8CwW247ljjJtC9iaCDSo" )
To enable the connection, please direct your web browser to: 
http://api.twitter.com/oauth/authorize?oauth_token=pPC8aldJpT5AYe73j7nGgboZAoxA0FOmQPE64tZgA
When complete, record the PIN given to you and provide it here: 0143065
> save(cred)
Error in save(cred) : 'file' must be specified
> save(cred, file='TwitterCred')
> rdmTweets <- userTimeline("rdatamining", n=100)
> n <- length(rdmTweets)
> rdmTweets[1:3]
[[1]]
[1] "RDataMining: Hadoop: from single-node mode to cluster mode http://t.co/I3I4q3Gjqm"
 registerTwitterOAuth(cred)
[[2]]
[1] "RDataMining: Setting up Hadoop in clustered mode in Ubuntu http://t.co/n4OIVJ2GuC"

[[3]]
[1] "RDataMining: Introduction to Data Mining with R -- slides in PDF of a talk at University of Canberra on 6 Sept 2013 http://t.co/z8bzXWfSTK"

>  df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
>  dim(df)
[1] 99 16
> library(tm)
Error in library(tm) : there is no package called ‘tm’
> utils:::menuInstallPkgs()
also installing the dependency ‘slam’

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/slam_0.1-30.zip'
Content type 'application/zip' length 100593 bytes (98 Kb)
opened URL
downloaded 98 Kb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/tm_0.5-9.1.zip'
Content type 'application/zip' length 713681 bytes (696 Kb)
opened URL
downloaded 696 Kb

package ‘slam’ successfully unpacked and MD5 sums checked
package ‘tm’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
        C:\Users\mma\AppData\Local\Temp\RtmpMhvlv1\downloaded_packages
> library(tm)
Warning message:
package ‘tm’ was built under R version 3.0.2 
> myCorpus <- Corpus(VectorSource(df$text))
>  myCorpus <- tm_map(myCorpus, tolower)
>  # remove punctuation
>  myCorpus <- tm_map(myCorpus, removePunctuation)
>  # remove numbers
>  myCorpus <- tm_map(myCorpus, removeNumbers)
>  # remove stopwords
>  # keep "r" by removing it from stopwords
>  myStopwords <- c(stopwords('english'), "available", "via")
>  idx <- which(myStopwords == "r")
>  myStopwords <- myStopwords[-idx]
>  myCorpus <- tm_map(myCorpus, removeWords, myStopwords)
>  dictCorpus <- myCorpus
>  # stem words in a text document with the snowball stemmers,
>  # which requires packages Snowball, RWeka, rJava, RWekajars
>  myCorpus <- tm_map(myCorpus, stemDocument)
Error in loadNamespace(name) : there is no package called ‘SnowballC’
>  # inspect the first three ``documents"
>  inspect(myCorpus[1:3])
A corpus with 3 text documents

The metadata consists of 2 tag-value pairs and a data frame
Available tags are:
  create_date creator 
Available variables in the data frame are:
  MetaID 

[[1]]
hadoop from singlenode mode to cluster mode httptcoiiqgjqm

[[2]]
setting up hadoop in clustered mode in ubuntu httptconoivjguc

[[3]]
introduction to data mining with r  slides in pdf of a talk at university of canberra on  sept  httptcozbzxwfstk

> utils:::menuInstallPkgs()
trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/SnowballC_0.5.zip'
Content type 'application/zip' length 186549 bytes (182 Kb)
opened URL
downloaded 182 Kb

package ‘SnowballC’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
        C:\Users\mma\AppData\Local\Temp\RtmpMhvlv1\downloaded_packages
> utils:::menuInstallPkgs()
trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/rJava_0.9-4.zip'
Content type 'application/zip' length 704997 bytes (688 Kb)
opened URL
downloaded 688 Kb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/RWeka_0.4-19.zip'
Content type 'application/zip' length 538083 bytes (525 Kb)
opened URL
downloaded 525 Kb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/RWekajars_3.7.10-1.zip'
Content type 'application/zip' length 5754034 bytes (5.5 Mb)
opened URL
downloaded 5.5 Mb

package ‘rJava’ successfully unpacked and MD5 sums checked
package ‘RWeka’ successfully unpacked and MD5 sums checked
package ‘RWekajars’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
        C:\Users\mma\AppData\Local\Temp\RtmpMhvlv1\downloaded_packages
> myCorpus <- tm_map(myCorpus, stemDocument)
> inspect(myCorpus[1:3])
A corpus with 3 text documents

The metadata consists of 2 tag-value pairs and a data frame
Available tags are:
  create_date creator 
Available variables in the data frame are:
  MetaID 

[[1]]
hadoop from singlenod mode to cluster mode httptcoiiqgjqm

[[2]]
set up hadoop in cluster mode in ubuntu httptconoivjguc

[[3]]
introduct to data mine with r  slide in pdf of a talk at univers of canberra on  sept  httptcozbzxwfstk

>  dictCorpus <- myCorpus
>  myCorpus <- tm_map(myCorpus, stemDocument)
> myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=dictCorpus)
> myDtm <- TermDocumentMatrix(myCorpus, control = list(minWordLength = 1))
> inspect(myDtm[266:270,31:40])
A term-document matrix (5 terms, 10 documents)

Non-/sparse entries: 2/48
Sparsity           : 96%
Maximal term length: 8 
Weighting          : term frequency (tf)

          Docs
Terms      31 32 33 34 35 36 37 38 39 40
  industri  1  0  0  1  0  0  0  0  0  0
  initi     0  0  0  0  0  0  0  0  0  0
  intellig  0  0  0  0  0  0  0  0  0  0
  interact  0  0  0  0  0  0  0  0  0  0
  interest  0  0  0  0  0  0  0  0  0  0
>  findFreqTerms(myDtm, lowfreq=10)
 [1] "amp"      "analysi"  "and"      "big"      "data"     "exampl"   "for"      "mapreduc" "mine"     "slide"    "the"     
[12] "use"      "video"    "with"    
> findAssocs(myDtm, 'r', 0.30)
Error in x[term, ] : subscript out of bounds
> findAssocs(myDtm, 'miners', 0.30)
Error in x[term, ] : subscript out of bounds
> findAssocs(myDtm, 'mine', 0.30)
          data         analyt           case          studi           book httptcofhorsxq           poll 
          0.59           0.43           0.38           0.38           0.36           0.30           0.30 
> m <- as.matrix(myDtm)
> v <- sort(rowSums(m), decreasing=TRUE)
> myNames <- names(v)
> k <- which(names(v)=="miners")
> myNames[k] <- "mine"
> myNames[k] <- "mining"
> wordcloud(d$word, d$freq, min.freq=3)
Error: could not find function "wordcloud"
> library(wordcloud)
Error in library(wordcloud) : there is no package called ‘wordcloud’
> utils:::menuInstallPkgs()
also installing the dependencies ‘Rcpp’, ‘RColorBrewer’

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/Rcpp_0.10.5.zip'
Content type 'application/zip' length 3401705 bytes (3.2 Mb)
opened URL
downloaded 3.2 Mb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/RColorBrewer_1.0-5.zip'
Content type 'application/zip' length 25286 bytes (24 Kb)
opened URL
downloaded 24 Kb

trying URL 'http://cran.rstudio.com/bin/windows/contrib/3.0/wordcloud_2.4.zip'
Content type 'application/zip' length 544329 bytes (531 Kb)
opened URL
downloaded 531 Kb

package ‘Rcpp’ successfully unpacked and MD5 sums checked
package ‘RColorBrewer’ successfully unpacked and MD5 sums checked
package ‘wordcloud’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
        C:\Users\mma\AppData\Local\Temp\RtmpMhvlv1\downloaded_packages
> wordcloud(d$word, d$freq, min.freq=3)
Error: could not find function "wordcloud"
> library(wordcloud)
Loading required package: Rcpp
Loading required package: RColorBrewer
Warning messages:
1: package ‘wordcloud’ was built under R version 3.0.2 
2: package ‘Rcpp’ was built under R version 3.0.2 
> wordcloud(d$word, d$freq, min.freq=3)
Error in wordcloud(d$word, d$freq, min.freq = 3) : object 'd' not found
> d <- data.frame(word=myNames, freq=v)
> wordcloud(d$word, d$freq, min.freq=3)
> 
