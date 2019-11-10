~version: "2.1"



@if(//div[@class="video-grande"]){
  $tbody: //div[@class="video-grande"]
}
@if(//div[@id="noticiaint"]){
  $tbody: //div[@id="noticiaint"]
}



body: $tbody


@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//a/iframe/..
@replace_tag(<div>): $tbody//u/img/..


title: //div[@class="f-right"]/h1
title: //div[@class="cabezal620"]
subtitle: //div[@class="f-right"]/h3
kicker: //div[@class="volanta"]

site_name: "ElDiarioSur.com"

published_date: //h6[@class="fecha_interna"]/@content

author: //div[@class="fotoautor"]/span
author_url: //div[@class="fotoautor"]/a/@href

@replace_tag(<div>): //div[has-class("fotonota")]//a
@replace_tag(<figure>): //div[has-class("fotonota")]/div[@class="item"]
@replace_tag(<figcaption>): $@//p
#@replace_tag(<cite>): $@/span

@if_not((//div[has-class("fotonota")]//img)[2]){
  cover: //div[has-class("fotonota")]//figure
}
@if((//div[has-class("fotonota")]//img)[2]){
  @replace_tag(<slideshow>): //div[has-class("fotonota")]
  @prepend_to($tbody): $@
}

cover: //div[@class="fotoNota-ext"]/img

@replace_tag(<related>): $tbody//blockquote[not(@class)]


@replace_tag(<figure>): $tbody//div[@class="fotointerior"]
@replace_tag(<figcaption>): $@/div[@class="instcodigo"]



@replace("\u00a0", " "): $tbody//p/text()

@if($tbody//div[@class="zoom"]){
  @match("-[0-9]+\\.html"): //meta[@property="og:url"]/@content
  @replace("-","")
  @replace(".html", "")  
  @html_to_dom
  $noticia: $@
  
  @map($tbody//div[@class="zoom"]/../..){
     $tdiv: $@
     @match("-...._"): $@/img/@src
     @replace("-", "")
     @replace("_", "")
     @html_to_dom
     $img: $@
     @append(<iframe>, src, "\\/a\/includes\/modulos\/vergaleria2\\.asp?id="): $tdiv
     @replace("\\\\", ""): $@/@src
     @html_to_dom
     $tdom: $@
     @append_to($@): $noticia/text()
     #@append("&id_foto="): $tdom
     #@append_to($tdom): $img/text()
     @append("&tipo=noticia"): $tdom
     @set_attr(src, $tdom/text()): $tdiv/iframe
     @if($tbody//div[@class="zoom"]/../..//div[@class="masfotos"]){
        @set_attr(href, $tdiv/iframe/@src): $tdiv//img
     }
     @inline: $tdiv/iframe
     $tinline: $@
     @set_attr(src, $@//img/@src): $tdiv//img
     
     #@remove: $tinline
     
  }
}

#@map($tbody//strong){
#  @debug: $@
#  @prepend(" "): $@
#}




@remove: //div[@class="w300"]
@unsupported: $tbody//a[contains(@href, "infogr")]



