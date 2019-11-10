~version: "2.1"

?exists: //meta[@property="og:type" and @content="article"]
!path_not: /ew-compare-old/.*
!path_not: /ew-compare/.*
!path_not: /brightsparks/.*
!path_not: /sitemap/.*

$tbody: //div[@class="entry"]
body: $tbody

@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//a/iframe/..
@replace_tag(<div>): $tbody//p/div/img/../..
@replace_tag(<div>): $tbody//strong/img/..

@map($tbody//p/strong/div/img){
  @before_el($@/../../..): $@
}

@append(" "): $tbody//a/next-sibling::em/prev-sibling::a

@map($tbody//img){
  @replace("(-[0-9][0-9][0-9]x[0-9][0-9][0-9][0-9])|(-[0-9][0-9][0-9]x[0-9][0-9][0-9])", ""): $@/@src
}

title: //h1[has-class("post-title")]
title: //h1[@class="tribe-events-single-event-title"]
title: //h1[@class="page-title"]


author: //span[@class="post-meta-author"]/a/text()
author_url: //span[@class="post-meta-author"]/a/@href

@prepend_to($tbody): //div[@class="intro"]
@wrap_inner(<b>)


site_name: "Electronics Weekly.com"

@map($tbody//blockquote){
  $tb: $@
  @if($tb//img){
    @before_el($tb): $@
  }
}

$ttemp: $tbody//div[@href and not(contains(@href, "static"))]/img

@map($ttemp){
  @set_attr(href, ./../@href): $@
}

@map($tbody//div/img/../next-sibling::p[@class="wp-caption-text"]){
  @replace_tag(<figcaption>): $@
  $tcap: $@
  @replace_tag(<figure>): $@/prev-sibling::div
  @append_to($@): $tcap
}

@map($tbody//div/img/next-sibling::p[@class="wp-caption-text"]){
  @replace_tag(<figcaption>): $@
  $tcap: $@
  @replace_tag(<figure>): $@/..
  @append_to($@): $tcap
}


@remove: //meta[@property="article:author"]

@prepend(" "): $tbody//a[contains(@title, "Permalink")]

@replace_tag(<slideshow>): $tbody//div[@id="gallery-2"]

@replace("\u00a0", " "): $tbody//p/text()

@remove: $tbody//p[@class="tribe-events-back"]
@remove: $tbody//h3[@class="tribe-events-visuallyhidden"]
@remove: $tbody//img[@class="tribe-events-spinner-medium"]
@remove: $tbody//div[@class="wp-polls"]
@remove: $tbody//div[@class="wp-polls-loading"]/next-sibling::p
@remove: $tbody//div[@class="wp-polls-loading"]
@remove: $tbody//ul[@class="tribe-events-sub-nav"]
