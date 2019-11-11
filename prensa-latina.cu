~version: "2.0"

$tbody: //div[has-class("row")]/div[has-class("col-xlg-7 col-md-7")]

?not_exists: $tbody//div[has-class("searchResult")]
!not_exists: //meta[@property="og:title" and @content=""]
!domain: .+\.prensa-latina\.cu
!path: /.+
!path_not: /index.php

body: $tbody

@replace_tag(<div>): $tbody//td//iframe/..
@replace_tag(<div>): $tbody//td//img/../..
@replace_tag(<div>): $tbody//p//img/..
@replace_tag(<div>): $tbody//a//img/..
@set_attr(href, $@/@href): $@/img



title: $tbody//h1[has-class("visible-sm visible-md")]

cover: $tbody//div[has-class("fullNewsIntrotext")]/img
cover: $tbody//div[has-class("fullNewsIntrotext")]/span/img
cover: $tbody//div[has-class("fullNewsIntrotext")]/div/img
cover: $tbody//div[has-class("fullNewsIntrotext")]//img

@replace("Por ", ""): $tbody//div[has-class("fullNewsIntrotext")]//span[@class="autor"]/text()
@replace(",", "")
@replace(":", "")
@replace("Texto y Fotos", "")
@replace("Fotos", "")
@replace("Foto", "")

author: $tbody//div[has-class("fullNewsIntrotext")]//span[@class="autor"]/text()


##CAMbiods por si me matan
@datetime(0, "es-ES", "dd 'de' MMMMM 'de' yyyy',' HH:mm"): ($tbody//span[@class="fecha"]/text())[1]
published_date: $@
#site_name: "Prensa Latina"

@if_not($tbody//div[@style="margin:10px 0px 10px 0px;"]) {
  @remove: $tbody//b[@style="color:#000;font-weight: bold;font-size:12pt;"]
}
@if($tbody//div[@style="margin:10px 0px 10px 0px;"]){
  @combine: $tbody//div[@style="margin:10px 0px 10px 0px;"]/next-sibling::div[@style="margin:10px 0px 10px 0px;"]
  @replace_tag(<related>): $tbody//div[@style="margin:10px 0px 10px 0px;"]
  @append_to($@): $tbody//b[@style="color:#000;font-weight: bold;font-size:12pt;"]
  @wrap(<h1>): $@
}





@remove: $tbody//div[@id="newsContainer"]
@remove: $tbody//div[@id="tagsDiv"]
@remove: $tbody//div[@class="example-wrap "]
@remove: $tbody//hr

@remove: $tbody//div[has-class("widget-header cover overlay")]
@remove: $tbody//div[has-class("fullNewsIntrotext")]//span[@class="autor"]/text()
@remove: $tbody//span[@class="fecha"]

@unsupported: $tbody//a[@data-target="#audioListening"]
