~version: "2.1"

@if(//div[@class="CUERPO"]){
  $tbody: //div[@class="CUERPO"]
}
@if_not(//div[@class="CUERPO"]) {
  @if(//div[@class="box-html"]){
    $tbody: //div[@class="box-html"]
  }
  @if(//div[@class="rg-gallery"]){
    $tbody: //div[@class="rg-gallery"]
    @map($tbody//ul//img){
      @set_attr(src, ./@data-large): $@
    }
    @replace_tag(<div>): $tbody//ul
    @remove: $tbody//div[contains(@class,"nav")]
  } 
}

body: $tbody

@append_to($tbody): //div[@class="box-relacionados"]
@replace_tag(<related>)
@replace_tag(<h1>): $@//div[@class="rot"]



@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//p/span/img/../..
@replace_tag(<div>): $tbody//a/span/img/../..
@replace_tag(<div>): $tbody//em/span/img/../..


title: //h1[@class="titular"]
subtitle: //p[@class="bajada"]
author: //p[@class="bajada"]/next-sibling::div[@class="epigrafe"]
@replace("Por: ", ""): $author

cover: //div[@class="foto_articulo"]/img
cover: //img[@class="fotodrag"]
site_name: "CDF"
#kicker: //div[@class="epigrafe"]

@datetime(0, "es-ES", "EEEE dd 'de' MMMM 'de' yyyy"): //span[@class="fecha"]/text()
published_date: $@

description: $subtitle
image_url: $cover/@src

#@replace_tag(<related>): //div[@class="box-relacionados"]
#@append_to($tbody)
#@replace_tag(<h1>): $@/div[@class="rot"]



@remove: $tbody//related//a[@class="foto"]
@remove: $tbody//related//a/img/..
@remove: $tbody//related//a[@class="redArt"]

@prepend_to($tbody): //div[@class="box-html"]/iframe/..
@unsupported: $tbody//div[@class="box-html"]/iframe

@replace("\u00a0", ""): $tbody//p/text()
