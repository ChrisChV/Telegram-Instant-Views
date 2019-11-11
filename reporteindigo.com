~version: "2.0"

$tbody: //div[@id="the-content"]



body: $tbody
title: //h3[@class="[ title-post ][ text-center ]"]/a/text()
subtitle: //div[@class="[ text-expert ]"]/p/text()

author: //div[@class="[ card-content ]"]//p[@class="[ author ][ text-center ]"]/text()
author: //h5[has-class("[ title-post ][ font-size--26 ]")]/a/text()
author_url: //h5[has-class("[ title-post ][ font-size--26 ]")]/a/@href

##Para dar formato al cover
@replace_tag(<figure>): //div[@class="[ relative ][ hide-on-small-only ]"]
@wrap(<figcaption>): $@/p
@replace_tag(<cite>): $@/p
cover: $@/../..
@replace_tag(<figure>): //div[@class="[ card-image ][  ]"]
@wrap(<figcaption>): $@/p
@replace_tag(<cite>): $@/p
cover: $@/../..



##Para dar formato a las imagenes del articulo
@remove: //noscript
@replace_tag(<div>): $tbody//img/..



@replace("//", "https://"): $tbody//img/@src
@replace("https:https://", "https://") 
@map($tbody//img){
  @set_attr(srcset, ""): $@
}




##Para dar formato a la fecha
#@datetime(0, "es-ES", "LLL d',' y"): //div[@class="[ card-content ]"]/div[@class="[ info-post ][ size-static ]"]/div/div[@class="[ col s6 ][ text-left ]"]/span/text()


@replace("Sep", "Sept"): //div[@class="[ card-content ]"]/div[@class="[ info-post ][ size-static ]"]/div/div[@class="[ col s6 ][ text-left ]"]/span/text()
@datetime(0, "es-ES", "LLL dd, yyyy"): //div[@class="[ card-content ]"]/div[@class="[ info-post ][ size-static ]"]/div/div[@class="[ col s6 ][ text-left ]"]/span/text()
published_date: $@

@map($tbody//blockquote){
  $tblockq: $@
  @append_to($tblockq//p[@class="[ author-cita ]"]): $tblockq/p[@class="[ author-cita ]"]/next-sibling::p
  @replace_tag(<cite>): $tblockq//p[@class="[ author-cita ]"]
  @replace("- ", ""): $@/text()
}




##Para dar formato a los related
@replace_tag(<related>): //div[@id="related-post"]
@replace_tag(<h1>): $@/div/span/span
@append_to($tbody): $@/../../..
@remove: //related//div[@class="card-content"]/a


##Para dar formato a los iframes
@replace_tag(<div>): $tbody//iframe/..

@remove: $tbody//div[@id="jp-relatedposts"]



@replace_tag(<iframe>): //div[@class="[ card-image ][  ]"]//section[has-class("[ content-play-buttons ]")]
@append_to($tbody)
@unsupported: $@
@unsupported: $tbody//iframe[has-class("scribd_iframe_embed")]

@if(//div[@id="kaltura-video-single"]){
  @append_to($tbody): $@
  @unsupported: $@
}




