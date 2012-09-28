library(XML)
library(RJSONIO)
library(RCurl)

 x=altmetrics(doi ='10.1038/480426a')
 > names(x)
 [1] "title"                   "doi"                    
 [3] "pmid"                    "nlmid"                  
 [5] "tq"                      "altmetric_jid"          
 [7] "issns"                   "journal"                
 [9] "cohorts"                 "altmetric_id"           
[11] "schema"                  "is_oa"                  
[13] "cited_by_fbwalls_count"  "cited_by_feeds_count"   
[15] "cited_by_gplus_count"    "cited_by_posts_count"   
[17] "cited_by_tweeters_count" "cited_by_accounts_count"
[19] "context"                 "score"                  
[21] "history"                 "url"                    
[23] "added_on"                "published_on"           
[25] "subjects"                "scopus_subjects"        
[27] "last_updated"            "readers_count"          
[29] "readers"                 "images"                 
[31] "details_url"      


ldply(x, function(foo) {
	return(data.frame(journal = foo$journal, doi = foo$doi, pmid = foo$pmid))
	})
