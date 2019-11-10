~version: "2.0"

@if(//div[@class="row content cols-70-30"][1]){
  $tbody: //div[@class="row content cols-70-30"][1]
}
@if_not(//div[@class="row content cols-70-30"][1]) {
  @if(//div[@id="tamano"]){
    $tbody: //div[@id="tamano"]
  }
  @if_not(//div[@id="tamano"]) {
    $tbody: //article[@class="desarrollo"]  
  }
}


body: $tbody

@replace_tag(<div>): $tbody//aside/aside

@wrap_inner(<b>): $tbody//p[@class="entradilla"]

@replace_tag(<div>): $tbody//a//img/..
@replace_tag(<div>): $tbody//strong//img/..
@replace_tag(<div>): $tbody//p//img/..

@map($tbody//figure[has-class("multimedia-item")]){
  $tfigure: $@
  @append_to($tfigure/figcaption/span[@itemprop="author"]): $tbody//figure[@class="multimedia-item image"]/figcaption/span[@itemprop="name"]/text()
  @if($tfigure/figcaption/span[@itemprop="name"]/next-sibling::span/text()){
    @append(" \\ "): $tfigure/figcaption/span[@itemprop="author"]
    @append_to($tfigure/figcaption/span[@itemprop="author"]): $tfigure/figcaption/span[@itemprop="name"]/next-sibling::span/text()
  }
  
  @replace_tag(<cite>): $tfigure/figcaption/span[@itemprop="author"]
}

@map(//div[@class="foto"]){
  $tfigure: $@
  @replace_tag(<figure>): $tfigure
  $tfigure: $@
  @append(" | "): $tfigure/p/span[@class="autor"]
  @append_to($tfigure/p/span[@class="autor"]): $tfigure/p/span[@class="agencia"]/text()
  #@append(" | "): $tfigure/p/span[@itemprop="author"]
  @append_to($tfigure/p/span[@itemprop="author"]): $tfigure/p/span[@itemprob="provider"]/text()
  @replace_tag(<figcaption>): $tfigure/p
  @replace_tag(<cite>): $tfigure/figcaption/span[@class="autor"]
  @replace_tag(<cite>): $tfigure/figcaption/span[@itemprop="author"]
}

@map($tbody//div[@class="foto externa"]){
  $tfigure: $@
  @replace_tag(<figure>): $tfigure
  @replace_tag(<figcaption>): $@/p
}



@prepend_to($tbody): //ul[@class="subtitulos"]

title: //h1[@class="js-headline"]
title: $tbody/header/h1


#@replace("T", " "): //time/@datetime
#@replace("\\+.*", "")
#published_date: $@
@replace("T", " "): //meta[@name="date"]/@content
@replace("Z", "")
published_date: $@
@replace(" \\| ", " "): $tbody//time/p/text()
@datetime(0, "es-ES", "dd/MM/yyyy HH:mm")
published_date: $@


site_name: "Expansión"


author: //li[@class="author-name"]
author: //li[@class="author-twitter"]
author: //div[@class="firma"]/span[@itemprop="name"]
author: //div[@class="info_autor"]/span[@class="nombre"]
author_url: //li[@class="author-twitter"]/a/@href

cover: $tbody//figure[@class="multimedia-item image"][1]
cover: //img[@id="fotoPrincipal"]/../..


image_url: $cover//img/@src
image_url: $tbody//figure//img/@src

kicker: //span[@class="kicker"]

@map($tbody//figure//div[@class="image-item"]){
   @set_attr(href, $@/@href): $@/img
}



@replace_tag(<related>): //div[@class="related-links inside-news-body"]
@prepend_to($@): $@/prev-sibling::aside/div/h4



@replace_tag(<div>): $tbody//aside[@class="apoyos"]

@replace_tag(<div>): $tbody//aside/figure/div/img/../../..





@replace_tag(<ul>): $tbody//div[@class="subtitle-items"]
@replace_tag(<li>): $@/p

@replace_tag(<div>): $tbody//aside//blockquote

@replace_tag(<div>): $tbody//aside/figure/div/div/img/../../../..


@map($tbody//div[has-class("sumario")]/figure){
  $tfigure: $@
  @replace_tag(<figcaption>): $tfigure/next-sibling::p
  @append_to($tfigure)
}






@remove: $tbody//div[@class="right-col"]
@remove: $tbody//div[@class="includes-under-tags"]
@remove: $tbody//aside[@class="related-tags inside-news-body"]
@remove: $tbody//div[@class="compartir iconos_sociales"]
@remove: $tbody//time
@remove: $tbody//div[@id="comentar"]
@remove: $tbody/div[@rel="nofollow"]
@remove: $tbody//div[@id="listado_comentarios"]

@remove: $tbody//aside[@class="summary-item"]/prev-sibling::h3[@class="subhead"]

#@unsupported: $tbody//aside[@class="summary-item"]

#@unsupported: $tbody//aside[@class="summary-item"]//figure[@class="multimedia-item graphic"]
@remove: $tbody//aside[@class="summary-item"]//figure[@class="multimedia-item graphic"]
@unsupported: $tbody//section[@class="ficha_resultados"]
@unsupported: $tbody//section[@class="modulo minuto_a_minuto"]
@unsupported: //figure[@class="multimedia-item video"]



