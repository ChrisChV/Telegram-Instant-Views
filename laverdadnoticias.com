~version: "2.0"

@if(//div[has-class("newsfull__body")]){
  $tbody: //div[has-class("newsfull__body")]
  @replace("T", " "): //time/@datetime  
  published_date: $@
}
@if_not(//div[has-class("newsfull__body")]){
  $tbody: //div[has-class("newsvideo__full")]
  @replace("HS", ""): //time/text()
  @replace(" - ", " ")
  @datetime(0, "en-US", "dd LLLL 'de' yyyy hh:mm")
  published_date: $@
}


body: $tbody


@replace_tag(<div>): $tbody//img/..


title: //h1[has-class("newsfull__title")]
subtitle: //div[has-class("newsfull__excerpt")]/p

author: //p[has-class("newsfull__author")]/a/text()
author_url: //p[has-class("newsfull__author")]/a/@href


@map($tbody//blockquote//img){
  @after_el($@/../..): $@ 
}





cover: $tbody//div[@class="newsphotogallery__image"]/..
cover: //figure[has-class("newsfull__media")]
cover: $tbody/div/div/div/figure

@if($tbody//div[@class="newsphotogallery__image"]//img[@data-full]) {
  @map($@){
    @set_attr(src, ./@data-full): $@
  }
}





@replace_tag(<figure>): $tbody//div[has-class("image")]

@replace_tag(<figure>): $tbody//div[has-class("ck-video-player")]
@wrap(<video>): $@/span[@data-type="video"]
@replace_tag(<source>): $@/span
@map($@){
  @set_attr(src, $@/@data-src): $@
}

@after_el($tbody//blockquote/div/div/blockquote[@class="twitter-tweet"]/../../..): $tbody//blockquote/div/div/blockquote[@class="twitter-tweet"]


@replace_tag(<iframe>): $tbody//div[has-class("videocover")]/video/source
@replace_tag(<div>): $@/..
@after_el($@/..): $@/iframe
@set_attr(type, ""): $@
#@replace("watch\\?v=", "embed/"): $@/@src

#@remove: $@/../div
#@set_attr(type, ""): $@/iframe
#@debug

#@debug: $tbody//iframe


@remove: $tbody//section[@class="tags"]
@remove: $tbody//div[@class="comments"]
@remove: $tbody//div[@class="mod relatednews"]
@remove: $tbody//div[@class="authorbox__item"]
@remove: //time

@remove: $tbody//div[has-class("ckeditor-poll")]

