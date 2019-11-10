~version: "2.0"


?path:/[0-9][0-9][0-9][0-9]/.+
?path:/especiales/.+
?path:/especial-agua-jibara/
!path_not:/especiales
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


## Para procesar los <cite> en las figures
@clone: //figure/figcaption
@replace_tag("<cite>")
@match("\\((Foto.*\\))|(Photo.*\\)|(Ilustración.*))"): //figure/cite
@replace("\\(", "")
@replace("\\)", "")
@map($@){
  @append_to($@/../figcaption): $@
}
@match("(.*\\()|(.*\\.)"): //figure/figcaption/text()
@replace("\\(", "")



##Para procesar la imagenes en esta pagina http://www.escambray.cu/2015/sancti-spiritus-cuando-el-ingenio-se-convierte-en-medicina-fotos/
@replace_tag(<figure>): //img[has-class("alignleft size-full")]/../..
@replace_tag(<div>): //img[has-class("alignleft size-full")]/..
@replace_tag(<div>): (//img[has-class("alignleft size-full")]/../../..)[2]


?path_not:/especiales/.+
!path_not:/especial-agua-jibara/


cover: //img[has-class("alignleft size-full")]
cover: $tbody/figure
cover: $tbody//img[1]

#@debug: $tbody//img

@remove: //a/img

@remove: //aside

@remove: //span

@remove: //nav

@remove: //div[@id="footerF"]


?path:/especiales/.+
?path:/especial-agua-jibara/



cover: $imgurl

kicker: $tbody/div/header/div/b/span/text()
kicker: //div[@class="entry"]/div/header/div/div/b/span/text()

@replace_tag(<p>): $tbody/div/div/span
@prepend_to($tbody)

@replace("-[0-9][0-9][0-9]x[0-9][0-9][0-9]", ""): //figure[@class="gallery-item"]//img/@src  
@wrap(<figure>): //figure[@class="gallery-item"]//img
@append_to($@/figure): //figure[@class="gallery-item"]//figcaption

@replace_tag(<dev>): //img[@title="Tuinicú en imágenes"]/..

@remove: //div[has-class("type1")]//br

@remove: //a/img

@remove: //aside

@remove: //span

@remove: //nav

@remove: //div[@id="footerF"]


?path:/especiales/volvieron/

@set_attr(src, //table/tr/td/@background): $cover
@replace_tag(<dev>): //p

?path:/especiales/comarcas-del-tuinucu/imagenes/

@remove: //a[@name="historia"]

?path:/especiales/la-revancha-del-tuinucu/


#@replace_tag(<div>): //table
#@after_el(//img/../../td): //img
#@wrap(<figure>): //img
#@replace_tag(<figcaption>): //img/../../a

#@replace_tag(<tablecell>): //td
#@replace_tag(<tablerow>): //tr

#@set_attr(class, "bordered"): //table
#@set_attr(width, ""): //table
#@debug: //table

@unsupported: //table

#@map(//figure){
  #@debug: $@
 # @debug: $@/..
 # @append_to($@): $@/../figcaption
#}

?path:/especiales/volvieron/.*

@set_attr(src, //table/tr/td/img/@src): $cover
@remove: //table/tr/td/img
@replace_tag(<div>): //table


