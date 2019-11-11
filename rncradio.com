~version: "2.0"

?path:/.+


#content-center-general
@if(//div[has-class("group-right")]){
  $tbody: //div[has-class("group-right")]  
}
@if(//div[has-class("content-center-general")]){
  $tbody: //div[has-class("content-center-general")]
  
  
  @after_el($tbody/div/p): $tbody/div/p/audio
  @match("http(s)*:.*mp3"): $tbody/div/audio/source/@src
}

@after_el(//p/iframe/..): //p/iframe 
@after_el(//p/img/..): //p/img

body: $tbody
title: //div[has-class("field field--name-node-title field--type-ds field--label-hidden field--item")]/h1
title: //div[has-class("field--name-node-title")]/h1

subtitle: //div[has-class("field field--name-dynamic-token-fieldnode-ds-summary field--type-ds field--label-hidden field--item")]/p
subtitle: //div[has-class("field--name-dynamic-token-fieldnode-ds-summary")]/p

@replace("-",""): //div[has-class("field--name-field-pub-date")]/p/text()
published_date: $@

##Para darle formato a las figuras sueltas en el articulo
@replace_tag(<figure>): //div[has-class("caption-img-foot")]/article
@replace_tag(<figcaption>): $@/div[@class="description-img"]
@replace_tag(<cite>): $@/div[@class="fright"]

cover: $tbody/div[has-class("field field--name-field-image field--type-entity-reference field--label-hidden field--name-field-image-highlighted field--item")]/div/figure
cover: //div[has-class("header-special")]/div/img
@replace_tag(<figure>): //div[has-class("imagen-principal-noticia")]
@replace_tag(<cite>): $@/b
@wrap(<figcaption>)
cover: $@/..

author: (//div[has-class("autor")]/a/text())[0]
author_url: //div[has-class("autor")]/a/@href

##Para darle formato a la galeria
@replace_tag(<figure>): //div[has-class("field field--name-field-image-gallery field--type-entity-reference field--label-hidden field--items")]/div[@class="field--item"]/div
$temp: $@
@map($temp/div/div){
  @before_el($@): $@/img
}
@map(//div[has-class("field field--name-field-image-gallery field--type-entity-reference field--label-hidden field--items")]/div[@class="field--item"]/figure/div){
  @before_el($@): $@/img
}
@replace_tag(<figcaption>): //div[has-class("field field--name-field-image-gallery field--type-entity-reference field--label-hidden field--items")]/div[@class="field--item"]/figure/div
@replace_tag(<cite>): $@/div[@class="field field--name-field-image-author field--type-string field--label-hidden field--item"]
@replace_tag(<slideshow>): //div[has-class("field field--name-field-image-gallery field--type-entity-reference field--label-hidden field--items")]

##Para darle formato a videos de youtube
@replace_tag(<figure>): //div[has-class("paragraph paragraph--type--paragraph-video paragraph--view-mode--default")]
@replace_tag(<cite>): $@/div[@class="field field--name-field-video-description field--type-string-long field--label-hidden field--item"]
@wrap(<figcaption>)

##Para darle formato a sus propios videos
@replace_tag(<figure>): //div[has-class("animated")]
@replace_tag(<figcaption>): $@/div

##Para dar formato a los audiosque tienen tag de video
@replace_tag(<audio>): //video/source[@type="audio/mp3"]/..
$tempaudio: $@
@remove: $tempaudio/../../div/div/div/div/div/span
@replace_tag(<figcaption>): $tempaudio/../../div/div/div/div/div/p
@append_to($tempaudio/../figcaption): $@/text()
@remove: $tempaudio/../../div/div/div[@class="control-time"]


@match("http(s)*:.*mp4"): //figure[has-class("animated")]/video/source/@src

## Para darle formato al footer
@wrap(<footer>): //div[has-class("field field--name-field-source field--type-string field--label-inline")]
@prepend_to(//div[has-class("field field--name-field-source field--type-string field--label-inline")]/div[@class="field--item"]/span/span/p): ": "
@wrap(<strong>): //div[has-class("field field--name-field-source field--type-string field--label-inline")]/div[@class="field--label"]/text()
@prepend_to(//div[has-class("field field--name-field-source field--type-string field--label-inline")]/div[@class="field--item"]/span/span/p): $@ 

##Para dar formato a los blockquotes
@replace_tag(<cite>): //div[@id="rcnradio-blockquote"]/span[@id="author"]
@append_to(//div[@id="rcnradio-blockquote"]/blockquote)

@replace_tag(<related>): //div[has-class("field field--name-field-related field--type-entity-reference field--label-above")]
@replace_tag(<h1>): $@/div[@class="field--label"]
@replace_tag(<div>): $@/..//div[has-class("field field--name-node-title field--type-ds field--label-hidden field--item")]/h2
@remove: //related[has-class("field field--name-field-related field--type-entity-reference field--label-above")]//div[has-class("field field--name-field-section field--type-entity-reference field--label-hidden field--item")]

@remove: //div[has-class("sharebox")]
@remove: //div[has-class("field field--name-field-tags field--type-entity-reference field--label-above")]
@remove: //img[@type="mp4"]
@remove: //img[@type="mp3"]
@remove: //img[@type="mp4 …"]
@remove: //iframe[@width="1"]
@remove: //img[has-class("filter-image-invalid")]
#@remove: //div[has-class("field field--name-field-related field--type-entity-reference field--label-above")]
@unsupported: //iframe[has-class("pdf")]





