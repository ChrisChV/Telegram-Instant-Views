~version: "2.1"

$tbody: //div[@id="article-body"]
body: $tbody

@remove: $tbody//p/a/img

@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//p/div/img/../..
@replace_tag(<div>): $tbody//p/aside/..
@replace_tag(<div>): $tbody//h4/img/..


@map($tbody//img){
  $timage: $@
  @if_not($timage/@src) {
    @set_attr(src, ./@data-src): $timage  
  }
}

title: //h1[has-class("article-title")]
subtitle: //div[has-class("article-sub-title")]
description: $subtitle
cover: //div[@itemprop="image"]//img
published_date: //div[@class="article-date"]/@content
author: //div[@class="article-author"]//span
author_url: //div[@class="article-author"]//a/@href

@remove: $tbody//div[@class="slider-picks-wrapper"]//li/div/img
@replace_tag(<a>): $tbody//div[@class="slider-picks-wrapper"]//li/div
@replace_tag(<related>): $tbody//div[@class="slider-picks-wrapper"]
@append_to($tbody): $@

@replace_tag(<slideshow>): $tbody//div[@class="slider-gallery"]

@replace_tag(<blockquote>): $tbody//aside[has-class("infobox")]

@replace_tag(<h1>): $tbody//div[has-class("fonts-review-title")]

@remove: $tbody//div[@class="amazon-pa"]//img
@remove: $tbody//div[@class="affiliate-box"]
@remove: $tbody//hr
@remove: $tbody//ul[@class="fonts-review-body"]/li[not(text())]
