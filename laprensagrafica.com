~version: "2.1"

@if(//div[@class="news-body"]){
  $tbody: //div[@class="news-body"]
}
@if_not(//div[@class="news-body"]){
  @if(//div[has-class("news-video-full")]){
    $tbody: //div[has-class("news-video-full")]
  }
  @if(//article[has-class("news-full")]){
    $tbody: //article[has-class("news-full")]
    @wrap(<div>): $tbody
    $tbody: $@
  }
}

body: $tbody

@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..

title: //header//h1[@class="news-title"]
title: //h1[@class="news-title"]

author: //p[@class="news-author"]//span[@itemprop="name"]
author: //div[@class="data-bottom"]//p/text()[2]
subtitle: //div[@class="news-excerpt"]


@datetime(0, "es-ES", "dd 'de' MMMM 'de' yyyy '-' HH:mm"): //time/text()
published_date: $@



@map(//div[@class="news-photogallery"]//figure){
  $tfigure: $@
  @replace_tag(<cite>): $tfigure//footer
  @append_to(/$tfigure//figcaption): $@
}

@if_not($tbody//article[has-class("news-full")]){
  @if_not(//div[@class="news-photogallery"]//figure[2]){
    cover: //div[@class="news-photogallery"]//figure
  }
  @if(//div[@class="news-photogallery"]//figure[2]){
    
    @remove: $tbody//div//text()/..
    $temp: $tbody//div//text()
    @prepend_to($tbody): //div[@class="news-photogallery"]
    @if($temp){
      @replace_tag(<slideshow>): //div[@class="news-photogallery"]
    }
  }
}

site_name: "La Prensa Gráfica"
description: $subtitle

@map($tbody//figure){
  $tfigure: $@
  @replace_tag(<cite>): $tfigure//footer
  @append_to($tfigure//figcaption): $@
}





@remove: $tbody//section[has-class("mod-tags")]
@remove: $tbody//section[has-class("mod-list")]
@remove: $tbody//section[has-class("mod-comments")]
@remove: $tbody//img[@style and @width and @height]
@remove: $tbody//div[@class="data-bottom"]
@remove: $tbody//div[@class="news-line"]


