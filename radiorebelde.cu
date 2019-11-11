~version: "2.0"


?path_not: /english/about-us/

$tbody: //div[@class="row"]/div[@class="col-md-8"]
body: $tbody

@before_el($tbody//p//img/..): $tbody//p//img
@before_el($tbody//p//iframe/../../..): $tbody//p//iframe

title: $tbody/h2[1]
@replace("\n",""): $tbody/h4[1]/small/text()
@replace("\t", "")
@replace("\/.*", "")
published_date: $@

author: $tbody/h4[1]/small/a/text()
author_url: $tbody/h4[1]/small/a/@href

@wrap(<figure>): $tbody//img
@append(<figcaption>): $@
@map($@){
   $tfigure: $@
   @append_to($tfigure): $tfigure/../next-sibling::p/span[@style="color:#808080;"]/span/span/text()
}

@remove: $tbody/h4[1]
@remove: $tbody/ol
@remove: $tbody//hr
@remove: $tbody//h4[@class="comment-title"]
@remove: $tbody//form
@remove: $tbody//a[@class="twitter-share-button"]
@remove: $tbody//div[@id="myTabContent"]
@remove: $tbody//h3//span[@class="label label-default"]
@remove: //embed
