~version: "2.0"

?path_not: /usuarios/.+
!path_not: /suscribete/.*

@if(//div[@class="pg-body"]){
  $tbody: //div[@class="pg-body"]
  
}

#@if(//div[@class="pg-microsite"]){
  @prepend_to($tbody): //div[@class="gd"]/div[@class="gdu u16 u-first"]/div[@class="pg-media"]
#}

body: $tbody

title: //h1[@class="pg-bkn-headline"]
author: $tbody//small[@class="author"]/a/text()
author_url: $tbody//small[@class="author"]/a/@href
author: //p[@class="author"]/a/text()
author_url: //p[@class="author"]/a/@href
author: //p[@class="author"]/text()
author: $tbody//small[@class="author"]/text()
subtitle: //h1[@class="pg-bkn-headline"]/next-sibling::p
kicker: //h2[@class="opinion-section"]

@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<related>): $tbody//aside[@class="rel-content-news"]
@replace_tag(<h1>): $@//span[@class="text"]
@remove: $tbody//related//figure
@append_to($tbody): $tbody//related


@replace_tag(<slideshow>): //div[has-class("gallery-slider")]
@prepend_to($tbody): $@
@append(" "): $tbody/slideshow//span[@class="source"]
@append_to($tbody/slideshow//span[@class="source"]): $tbody/slideshow//span[@class="author"]
@replace_tag(<cite>): $tbody/slideshow//span[@class="source"]


@prepend_to($tbody): //ul[@class="summary"]
@wrap_inner(<b>): $@//p



@map($tbody//figure[@class="image-holder"]){
  $tfigure: $@
  @set_attr(src, ./@data-src): $tfigure//img
  @replace_tag(<cite>): $tfigure//span[@class="source"]
  @replace("/", ""): $tfigure//figcaption/div/p/text()
}


@set_attr(src, ./@data-src): //div[@class="pg-media"]/figure//img
@replace_tag(<cite>): //div[@class="pg-media"]/figure//span[@class="source"]
@remove: //div[@class="pg-media"]/figure//comment()
@replace("/", ""): //div[@class="pg-media"]/figure//figcaption/div/p/text()
@if_not(//div[has-class("gallery-slider")] ) {
  @if_not(//div[@class="pg-microsite"]) {
    @if_not(//div[@class="pg-media"]/div[@class="inset"]) {
      cover: //div[@class="pg-media"]//figure      
    }
  }
}




@replace_tag(<div>): $tbody//aside[has-class("rel-content-more")]

#@replace_tag(<blockquote>): $tbody//aside[@class="rel-content-phrases"]

@remove: $tbody//div[@class="md-lite-share"]
@remove: $tbody//p[@class="byline"]
@remove: $tbody//time

