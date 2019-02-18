~version: "2.0"


?path:/[0-9][0-9][0-9][0-9]/.+
?path:/especiales/.+
?path:/especial-agua-jibara/
!path_not:/especiales
!path_not:/especiales/la-revancha-del-tuinucu/
!path_not:/especiales/agua-a-punta-de-lapiz/
!path_not:/especiales/fidel/
!path_not:/especiales/los-cinco-son-hombres-heroicos/
!path_not:/especiales/monumentos/
!path_not:/especiales/temporal/
!path_not:/especiales/el-ramal-condenado/
!path_not:/especiales/modelo-cubano/
!path_not:/especiales/caguanes-entre-la-magia-y-la-aventura/


#title: //body/meta[@property="og:title"]/@content
title: //h1[@class="name post-title entry-title"]
subtitle: //div[@class="articulo-subtitulos"]





@if( //div[@class="entry"] ){
  $tbody: //div[@class="entry"]
}
@if( //div[@class="postarea"] ){
  $tbody: //div[@class="postarea"]
}


$relatedlinks: //div[has-class("content")]/section[@id="related_posts"]/div[@class="block-head"]/h3
$relatedlinks+: //div[has-class("related-item")]//h3/a


@append("<related>"): $tbody
@append_to($tbody/related): $relatedlinks

@wrap("<figure>"): $tbody/figure/a/img

body: $tbody

@match("http://.*jpg"): $tbody/div[1]/@style
$imgurl: $@
$test: ""
@append("<img>", src, $imgurl)
$imgurl: $@





@replace_tag("<figure>"): $tbody//code
@replace_tag("<div>"):  $tbody//p[last()]


author: //div[has-class("post-cover-head")]/span/a
author: //div[has-class("post-cover-head")]/section/div/h3/a
#published_date: //body/meta[@property="article:published_time"]/@content

@replace(":", " "): //body/meta[@name="date"]/@content
@datetime(0, "en-US", "yyyy-MM-dd hh mmaa")
published_date: $@


?path_not:/especiales/.+
!path_not:/especial-agua-jibara/

cover: $tbody/figure
cover: $tbody//img[1]

@remove: //a/img

@remove: //aside

@remove: //span

@remove: //nav

@remove: //div[@id="footerF"]


?path:/especiales/.+
?path:/especial-agua-jibara/

cover: $imgurl

@replace("-[0-9][0-9][0-9]x[0-9][0-9][0-9]", ""): //figure[@class="gallery-item"]//img/@src  
@wrap(<figure>): //figure[@class="gallery-item"]//img
@append_to($@/figure): //figure[@class="gallery-item"]//figcaption
  
@remove: //div[has-class("type1")]//br

@remove: //a/img

@remove: //aside

@remove: //span

@remove: //nav

@remove: //div[@id="footerF"]