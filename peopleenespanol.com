~version: "2.0"


@if(//div[@class="padded"]){
  $tbody: //div[@class="padded"]
}
@if(//div[@class="gallery content body"]){
  $tbody: //div[@class="gallery content body"]
  #@wrap_inner(<slideshow>): $tbody
}
@if(//div[has-class("article-content-container")]){
  $tbody: //div[has-class("article-content-container")]
}

body: $tbody

@replace_tag(<div>): $tbody//a/img/..



title: //h1[has-class("headline")]
subtitle: //p[has-class("dek")]
author: //a[has-class("author-name")]
author_url: //a[has-class("author-name")]/@href

@replace("\n", ""): //div[has-class("published-date")]/text()
@replace("  ", "")
@datetime(0, "en-US", "MMMMM dd',' yyyyy hh:mm aa")
published_date: $@


@remove: $tbody//span[has-class("icon-pinterest-gallery-overlay")]
@remove: $tbody//div[@class="media-img"]/img[@data-src and not(@src)]

@if(//div[has-class("component video")]//div[@class="jumpstart-video"]){
  @append_to($tbody): $@
  @unsupported: $@
}

@remove: $tbody//div[@class="component karma-below-banner vertical-gallery mobile-only"]

@replace_tag(<figure>): $tbody//div[@class="media stacked"]
@replace_tag(<figcaption>): $@/div[@class="media-body"]
@replace_tag(<cite>): $@/div[@class="credit"]

@replace_tag(<iframe>): $tbody//div[has-class("embed-instagram")]
@map($@){
  $tiframe: $@
  @set_attr(src, ./@data-embed-id)
  @replace("^", "https://www.instagram.com/p/"): $tiframe/@src
}



@remove: $tbody//div[@class="slide-info"]
@remove: $tbody//div[@class="ad-title"]


