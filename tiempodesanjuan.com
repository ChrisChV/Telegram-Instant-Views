~version: "2.0"

@if(//div[@id="cuerpo-nota"]){
  $tbody: //div[@id="cuerpo-nota"]
}
@if_not(//div[@id="cuerpo-nota"]) {
  $tbody: //div[@class="main-video"]
}

@replace_tag(<related>): $tbody//aside[has-class("relacionadas")]

@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//p/iframe/..

body: $tbody

title: //h1[@class="titular"]
title: //div[@class="bajada"]
#title: //div[has-class("item-titulo")]/h1
subtitle: //strong[@class="bajada"]

#kicker: //h2[@class="volanta"]

site_name: "Tiempo de San Juan"

@replace("\n", ""): //div[@class="fecha"]/text()
@replace(" · ", " ")
@datetime(0, "es-ES", "EEEEE',' dd 'de' MMMMM 'de' yyyyy HH:mm")
published_date: $@



@if_not(//div[@class="main-content-foto"]//figure[2]) {
  #Por si me matan
  @set_attr(src, //div[@class="main-content-foto"]//figure//a/@href): //div[@class="main-content-foto"]//figure//img 
  cover: //div[@class="main-content-foto"]//figure  
 
}
@if(//div[@class="main-content-foto"]//figure[2]){
  
  @replace_tag(<slideshow>): //div[@class="main-content-foto"]
  @prepend_to($tbody): $@
}

@remove: $tbody//script



@unsupported: $tbody//a[@class="rm-mag-embed"]


