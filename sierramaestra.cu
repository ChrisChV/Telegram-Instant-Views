~version: "2.0"

?exists: //meta[@name="author"]
!path_not: /index.php/component/search/.*
!path_not: /index.php/quienes-somos
!path_not: /index.php/prensa-cubana
!path_not: /index.php/mapa-del-sitio
!path_not: /index.php/cartelera
!path_not: /index.php/centro-de-pronosticos
?not_exists: //meta[@property="og:type"]


@if(//div[@class="item-page"]){
  $tbody: //div[@class="item-page"]
}
@if_not(//div[@class="item-page"]) {
  $tbody: //div[@id="gkContent"]
}

body: $tbody

@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/div/img/../..

title: $tbody//h2/a
title: //div[@class="page-header"]/h1

published_date: //time/@datetime

@map($tbody//img){
  @wrap(<figure>): $@
  $tfigure: $@
  @if($tfigure//img[@title]){
    @append(<figcaption>): $tfigure
    @html_to_dom: $tfigure//img/@title
    @append_to($tfigure//figcaption): $@
  }
}

@replace("_thumb", ""): $tbody//figure//img/@src

image_url: $tbody//img[1]/@src

@remove: $tbody/h1
@remove: $tbody//p[@class="article-info"]
@remove: $tbody//span[@class="speasyimagegallery-gallery-item-title"]
@remove: $tbody//div[@id="gkFooter"]




