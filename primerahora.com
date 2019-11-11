~version: "2.0"

?path_not: /fotogalerias/
!path_not: /videos/

@if(//div[@class="blogpost"]){
  $tbody: //div[@class="blogpost"]
}
@if(//section[@class="Mmovie"]){
  $tbody: //section[@class="Mmovie"]
}
@if(//div[@id="showcase"]){
  $tbody: //div[@id="showcase"]
  @remove: $tbody//div[@class="showcase-thumbnail"]
  @map($tbody//div[@class="showcase-content"]){
     @replace_tag(<figure>): $@
     @replace_tag(<figcaption>): $@//p
  }
  
  ##POr si me matan
  #@wrap_inner(<slideshow>): //div[@id="showcase"]
  #@remove: $tbody/slideshow/img[@class="galery_loader"]
  @remove: $tbody//img[@class="galery_loader"]
}

body: $tbody


@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<figure>): $tbody//p/img/..
@wrap(<figcaption>): $@/span
@replace_tag(<cite>): $@/span
@replace_tag(<div>): $tbody//p/iframe/..

title: $tbody//div[has-class("ntscott")]/h1
title: $tbody//article[has-class("tscott")]/h1
@replace("Por ", ""): $tbody//div[has-class("ntscott")]/h6/strong/text()
author: $@
@replace("Por ", ""): $tbody//section[has-class("fivecol")]/h2
author: $@
@if_not($tbody//div[has-class("ntscott")]/h1) {
  @remove: $tbody//article[has-class("tscott")]/h6
}

@replace("\\|", ""): $tbody//div[has-class("ntscott")]/h6/text()[2]
@replace("\\.", "")
@datetime(0, "es-ES", "MM/dd/yyyy hh:mm")
published_date: $@

@replace_tag(<div>): $tbody//blockquote[1]
subtitle: $@

##Para dar formato a los iframe de instagram
@map($tbody//div[@class="instagram-media"]){
  @wrap(<div>): $@
  $tinst: $@
  @append(<iframe>): $tinst
  @set_attr(src, $tinst/div/@data-instgrm-permalink): $@
  @remove: $tinst/div
}

@replace_tag(<related>): $tbody//div[@class="related_content"]

#@append_to($tbody): //article[has-class("RelatedArticle")]
#@replace_tag(<related>): $@

@remove: $tbody//div[@class="d1b_tags"]
@remove: $tbody//div[@class="li-rec-desktop"]
@remove: $tbody//div[@class="container caddons"]
@remove: $tbody//script
@remove: $tbody//a[@id="comentarios"]
@remove: $tbody//a[@href="https://www.primerahora.com/"]
@remove: $tbody//a[@href="https://www.primerahora.com/mr/"]
@remove: $tbody//div[@style="height: 27px; background-color: #FBF2F2; border-radius: 6.5px; text-align: left; padding-left: 15px; padding-top: 20px; margin: 5px; font-family: verdana; border: #E0E0E0; border-width: 1px; border-style: solid; color: red;"]
@remove: $tbody//div[has-class("ntscott")]
@remove: $tbody//section[has-class("fivecol")]
@remove: $tbody//figure[@class="twocol"]
@remove: $tbody//div[@class="baddons"]

@unsupported: $tbody//div[@class="twitter-tweet"]
@unsupported: //section[@class="Mmovie"]//div[@id="embedPlayer2"]
@unsupported: $tbody//section[@class="bgallery"]

@debug: $tbody//iframe


