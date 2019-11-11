~version: "2.0"

?path_not: /formulario/contacto
!path_not: /info/.*
!exists: //meta[@name="twitter:title"]

@if(//div[has-class("section_")]){
  $tbody: //div[has-class("section_")]
}
@if(//div[has-class("galeria")]){
  $tbody: //div[has-class("galeria")]
}
@if_not(//div[has-class("section_")]){
  @if_not( //div[has-class("galeria")] ) {
    @if(//div[@id="block-system-main"] ) {
      $tbody: //div[@id="block-system-main"]/div//div[has-class("content")]
      @append_to($tbody): //div[@class="seccion"]
      
      
    }  
  }
}
body: $tbody


@map($tbody//a/img){
  $tfigure: $@
  @if_not($tfigure/../span[@class="fake expansible fake_ampliar"]) {
    @set_attr(href, $tfigure/../@href): $tfigure  
  }
}
@map( $tbody//a[@class="thumb"]//img ) {
   @set_attr(href, ""): $@
}
@replace_tag(<p>): $tbody//h3[@class="entradilla"]
kicker: //div[@class="antetitulo"]



@replace_tag(<div>): $tbody//img/..
@replace_tag(<div>): $tbody//iframe/..
@replace_tag(<span>): $tbody//a/div/img/../..
@replace_tag(<div>): $tbody//p/span/div/img/../../..
@replace_tag(<div>): $tbody//p//img/../..


$temp: $tbody//img[contains(@alt,"allave_inglesa")]
@map($temp){
  $timg: $@
  @wrap(<p>): $@/next-sibling::strong
  $tp: $@
  @replace_tag(<pic>): $timg
  @prepend_to($tp): $@
  @debug: $tp
  @replace_tag(<pic>): $tp/next-sibling::img
  @append_to($tp): $@
}



title: $tbody//h1[has-class("supertitular")]

##Para dar formato a los subtitulos
@replace_tag(<ul>): $tbody//div[has-class("subtitulos")]
@replace_tag(<li>): $@/h2

##Para dar formato al autor
author: $tbody//div[has-class("submitted mb")]/a/text()
author_url: $tbody//div[has-class("submitted mb")]/a/@href

author: $tbody//div[has-class("submitted mb")]/text()[2]

site_name: "SoyMotor"

@if_not($tbody//p[@class="entradilla"]) {
  subtitle: //p[@class="entradilla"]
}



##Para dar formato a la fecha
@replace(" \\| ", ""): $tbody//div[has-class("submitted mb")]/span[@class="fecha"]/text()
@replace(" - ", " ")
@replace("sep", "sept")
@datetime(0, "es-ES", "dd LLL yyy HH:mm")
published_date: $@

##Para dar formato al cover
@replace_tag(<figure>): $tbody/span[@class="media "]
@replace_tag(<figcaption>): $@/span[@class="imagen_pie"]
cover: $@/..

##Para dar formato a los relacionados
@replace_tag(<related>): $tbody//div[has-class("seccion")]
@replace_tag(<h1>): $@/div[@class="rotulo"]
@remove: $@/../div[has-class("dependientes")]/div/div/span
@remove: $tbody//related/div[has-class("dependientes")]/div/div/div[@class="submitted en_bloque"]

@remove: $tbody//div[has-class("sidebar-mini")]//div[@class="autor"]
@replace_tag(<related>): $tbody//div[has-class("sidebar-mini")]/div/div/div


##Para dar formato a las galerias
@replace("picture", "mega"): $tbody//div[@class="navigations"]/div/div/ul/li/div/img/@src
@replace_tag(<figure>):$tbody//div[@class="navigations"]/div/div/ul/li
@replace_tag(<figcaption>): $@/div/div/h2

##Para dar formato a los videos
@if($tbody//div[has-class("cabecera_video")]){
  @html_to_dom: $tbody//div[has-class("cabecera_video")]/script[2]/text()
  @match("https://youtu.be/..........."): $@/text()
  $tyoutube: $@

  @prepend(<iframe>): $tbody
  @set_attr(src, $tyoutube): $@
  
  @remove: $tbody//div[has-class("cabecera_video")]/div[@class="media"]
  @remove: $tbody//div[has-class("cabecera_video")]/div/div

}


##Para los figcaptions que estan en paragraph
#@wrap(<figure>): $tbody//img
#@replace_tag(<figcaption>): $tbody//img/../../next-sibling::p[@class="rtecenter"]
#@map($tbody//img){
#  $timage: $@
#  @if($timage/../../next-sibling::figcaption[@class="rtecenter"]){
#      @prepend_to($timage/..): $@
#  }
#}




@remove: $tbody//div[has-class("antetitulo")]
@remove: $tbody//div[has-class("submitted mb")]
@remove: $tbody//ul[has-class("social-node")]
@remove: $tbody//div[has-class("tienda-link")]
@remove: $tbody//div[has-class("button-container")]
@remove: $tbody//div[has-class("section")]/form[@id="user-login-form"]/..
@remove: $tbody//div[@class="video"]
@remove: $tbody//p[@class="rtecenter"]/strong/a


