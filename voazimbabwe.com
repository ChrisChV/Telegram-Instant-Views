~version: "2.0"

$tbody: //div[has-class("media-container")]
body: $tbody

title: $tbody//div[has-class("col-title")]/h1

@replace("T", " "): $tbody//time/@datetime
@replace("\\+.*", "")
published_date: $@

@map($tbody//video){
  @set_attr(src, $@/@data-fallbacksrc): $@
}


#@while($tbody//a[@class="btn link-showMore btn__text"]){
  @replace_tag(<iframe>): $tbody//a[@class="btn link-showMore btn__text"]
  @replace_tag(<div>): $@/..
  @set_attr(src, ./@href): $@/iframe
  @inline
  @remove: $tbody//div[@class="hdr"]
  @remove: $tbody//div[has-class("c-hlights")]
  @remove: $tbody//div[@class="sr-only"]
  @remove: $tbody//div[@class="c-lightbox__intro"]
  @remove: $tbody//div[@class="c-lightbox__nav"]
  @remove: $tbody//div[@class="c-lightbox__content-wrap"]
  @remove: $tbody//title
  @remove: $tbody//div[@class="print-dialogue"]
  @remove: ($tbody//div[@class="wsw"])[2]
  @remove: ($tbody//div[has-class("col-title")]/h1)[2]
  @remove: $tbody//footer
  @remove: $tbody//div[@class="sticked-nav-actions"]
  @remove: $tbody//div[has-class("back-to-top-nav")]
  @remove: $tbody//div[@class="responsive-indicator"]
#}



@replace_tag(<div>): $tbody//aside
@replace_tag(<div>): $tbody//a/img/..





@remove: $tbody//img[@src=""]
@remove: $tbody//time
@remove: $tbody//hr
@remove: $tbody//div[@class="c-spinner"]
@remove: $tbody//div[@class="media-download"]
@remove: $tbody//ul[@class="share__list"]
@remove: $tbody//p[@class="link-comments"]
@remove: $tbody//aside[has-class("share")]
@remove: $tbody//div[has-class("c-mmp__overlay")]
@remove: $tbody//div[@class="c-mmp__cpanel-progress-controls"]
@remove: $tbody//div[has-class("c-mmp__cpanel-container")]
@remove: $tbody//noscript
@remove: $tbody//div[has-class("c-mmp__poster")]
@remove: $tbody//div[@class="pg-title"]
@remove: $tbody//script
@remove: $tbody//div[@class="category"]
@remove: $tbody//div[@id="more-info"]










