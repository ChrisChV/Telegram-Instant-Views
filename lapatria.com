~version: "2.1"

?path_not: /indicadores-economicos
!path_not: /indicadores-economicos/.*
!path_not: /sudoku
!path_not: /sudoku/.*
!path_not: /clima
!path_not: /clima/.*
!path_not: /horoscopo
!path_not: /horoscopo/.*
!path_not: /aeropuerto
!path_not: /aeropuerto/.*
!path_not: /droguerias
!path_not: /droguerias/.*
!path_not: /calen-tributario
!path_not: /calen-tributario/.*
!path_not: /apps/.*
!path_not: /pagina/servicios
!path_not: /pagina/servicios/.*
!path_not: /pagina/la-patria-rss
!path_not: /pagina/la-patria-rss/.*
!path_not: /pagos
!path_not: /pagos/.*
!path_not: /informacion-legal
!path_not: /informacion-legal/.*
!path_not: /radio
!path_not: /radio/.*


@if(//div[has-class("field-name-body")]){
  @wrap(<div>): //div[has-class("field-name-body")]
  $tbody: $@
}
@if(//div[has-class("field-name-field-imagencaricatura")]){
  $tbody: //div[has-class("field-name-field-imagencaricatura")]
}
@if(//div[has-class("view-16-galerias")]){
  $tbody: (//div[has-class("view-16-galerias")])[1]
  @wrap(<div>): $tbody
  $tbody: $@
  
   @if(//div[has-class("field-name-body")]){
      @replace_tag(<slideshow>): $tbody/div   
   }
   @if_not(//div[has-class("field-name-body")]){
      @replace_tag(<div>): $tbody/div
   }
  
  
  @remove: $tbody//ul[@class="flex-direction-nav"]
  @remove: ($tbody//ul[@class="slides"])[2]
  @replace_tag(<figure>): $tbody//li
  $tfigure: $@
  @replace_tag(<figcaption>): $tfigure//div[has-class("field-name-field-textoitem")]
  @if_not($@) {
   @map($tfigure){
    $tf: $@
    @html_to_dom: $tf//img/@title
    @append_to($tf): $@
    @replace_tag(<figcaption>): $@
   }
  }
  
}

@if_not($tbody//div[has-class("field-name-body")]){
   @if(//div[has-class("field-name-body")]){
      @append_to($tbody): //div[has-class("field-name-body")]
   }
}

@if($tbody){
  @replace_tag(<figure>): //div[has-class("field-name-field-imagenprincipal")]
  cover: $@
  @append_to($@): //div[has-class("field-name-field-piedefotoimagenppal")]
  @replace_tag(<figcaption>): $@
}
@if_not($tbody){
   @replace_tag(<figure>): //div[has-class("field-name-field-imagenprincipal")]
   $tbody: $@
   @append_to($@): //div[has-class("field-name-field-piedefotoimagenppal")]
  @replace_tag(<figcaption>): $@
  @wrap(<div>): $tbody
  $tbody: $@
  @replace_tag(<figcaption>): //div[has-class("field-name-field-tipolectorinter")]
  @append_to($tbody//figure)
}


body: $tbody


@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//a/iframe/..


title: //h1[@class="title"]
subtitle: //div[has-class("field-name-field-resumen")]


description: $subtitle
author: //article[has-class("node-autor")]/header/h1
author: //div[has-class("field-name-field-nombrelector")]

#@datetime(0, "es-ES", "EEEE, MMMM dd, yyyy"): //div[has-class("field-name-field-fechapublicacion")]//text()
#published_date: $@
@datetime(0, "es-ES", "EEEE, MMMM dd, yyyy"):  //span[@class="date-display-single"]/text()
published_date: $@



site_name: "LA PATRIA.COM"

@replace_tag(<related>): //div[has-class("field-name-field-noticiarelacionada")]
@append_to($tbody)
@replace_tag(<h1>): $@//div[@class="field-label"]

@replace("\u00a0", ""): $tbody//p/text()



@append_to($tbody): //div[has-class("field-name-field-fotosengaleria")]
@replace_tag(<slideshow>)
@replace_tag(<figure>): $@//li
@replace_tag(<figcaption>): $@//div[has-class("field field-name-field-textoitem")]

@append_to($tbody): //div[has-class("field-name-field-preguntas")]
@remove: $@/div[@class="field-label"]

@remove: //fieldset//div[@class="field-label"]
@append_to($tbody): //fieldset

@debug: $tbody



