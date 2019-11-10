~version: "2.1"

?exists: //meta[@property="og:type" and @content="article"]

$tbody: //article[@class="col-sm-12 col-md-12"]
body: $tbody


@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//p/div/img/../..

site_name: "elmostrador"

title: //h2[@class="titulo-single"]

author: //p[has-class("autor-y-fecha")]//a
author_url: //p[has-class("autor-y-fecha")]//a/@href
author: //p[has-class("autor-y-fecha")]//span
@datetime(0, "es-ES", "dd MMMM, yyyy"): //p[has-class("autor-y-fecha")]/text()[2]
published_date: $@

@replace_tag(<related>): //section[has-class("noticias-relacionadas")]
@append_to($tbody): $@
@prepend_to($@): $tbody//section[has-class("articulos-relacionados")]
@remove: $@//p[@class="autor-noticia-post"]



$temp: $tbody//div[contains(@id, "attachment")]

@map($temp){
  @replace_tag(<figure>): $@
  $tfigure: $@
}

@replace_tag(<figcaption>): $tbody//figure//p[@class="wp-caption-text"]


#@replace_tag(<video>): $tbody//iframe[@id="vrudo"]
@unsupported: $tbody//iframe[@id="vrudo"]

@map($tbody//figure/span[@class="image-and-copyright-container"]){
  $tspan: $@
  @append(<figcaption>): $tspan/..
  @append_to($@): $tspan/text()
}


@remove: $tbody//div[@class="col-xs-12 col-sm-4 col-md-2 acciones"]
@remove: $tbody//div[has-class("tags-noticias")]
@remove: $tbody//div[has-class("compartir-noticia")]
@remove: $tbody//img[@alt="DW"]
@remove: $tbody//noscript
@remove: $tbody//img[@alt="BBC Mundo"]

@replace("\u00a0", ""): $tbody//p/text()


