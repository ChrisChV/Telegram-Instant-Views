~version: "2.0"

@if(//div[has-class("entry-content")]){
  $tbody:  //div[has-class("entry-content")]
}
@if_not(//div[has-class("entry-content")]){
  $tbody: //div[has-class("post_content")]
}



body: $tbody


title: //header[has-class("entry-header")]/h1[@class="entry-title"]/text()
author: //header[has-class("entry-header")]/p[@class="entry-meta"]/span[@class="entry-author"]/a/span[@class="entry-author-name"]/text()
author_url: //header[has-class("entry-header")]/p[@class="entry-meta"]/span[@class="entry-author"]/a/@href


@replace_tag(<div>): $tbody//iframe[has-class("youtube-player")]/../..

##Para dar formato a la fecha
@replace("T"," "): //meta[@property="article:published_time"]/@content
@match("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]")
published_date: $@


##Para dar formato a las imagenes
@replace_tag(<div>): $tbody//img/../../a
@map($tbody//figure/div/img){
  @set_attr(src, $@/@data-lazy-src): $@  
}
@map($tbody//figure/img){
  @set_attr(src, $@/@data-lazy-src): $@
}
@map($tbody//iframe[@src="about:blank"]){
  @set_attr(src, $@/@data-lazy-src): $@
}

cover: ($tbody//figure)[1]
@set_attr(src, //div[has-class("image-post-thumb jlsingle-title-above")]/img/@data-lazy-src): //div[has-class("image-post-thumb jlsingle-title-above")]/img
cover: //div[has-class("image-post-thumb jlsingle-title-above")]/img


@remove: //ul[has-class("essb_links_list essb_hide_name")]



#@remove: $tbody//blockquote/../iframe
@wrap(<related>): $tbody//blockquote/../../prev-sibling::h3
@replace_tag(<div>): $tbody//blockquote/../..
@append_to($tbody//related): $@[@class="wp-block-embed is-type-rich is-provider-soyacincau-com"]
@remove: $tbody//noscript



@if_not($tbody//related) {
  @append(<related>): $tbody
  @replace_tag(<div>): $tbody//div[has-class("wp-block-embed is-type-rich is-provider-soyacincau-com")]/div/blockquote
  @remove: $tbody//div[has-class("wp-block-embed is-type-rich is-provider-soyacincau-com")]/prev-sibling::h2
  @append_to($tbody//related): $tbody//div[has-class("wp-block-embed is-type-rich is-provider-soyacincau-com")]
  
}



#@after_el($tbody//img/../../p): $tbody//img/../../p/img


@if_not(//div[has-class("entry-content")]){
  @remove: $tbody//p/img
  @replace_tag(<figure>): $tbody//img/../..
  @map($tbody//figure/div/img){
    @set_attr(src, $@/@data-orig-file): $@
  }
}

@map($tbody//figure){
  $tfigure: $@
  @if_not($tfigure/next-sibling::p/text()) {
    @if($tfigure/next-sibling::p/em){
      $tem: $@/text()
      @append(<figcaption>): $tfigure
      @append_to($tfigure/figcaption): $tem
    }   
  }
}

@remove: //div[has-class("sharedaddy sd-sharing-enabled")]
@remove: //div[@style="clear:both; margin-top:0em; margin-bottom:1em;"]

@replace_tag(<figure>): $tbody//post/..
@replace_tag(<iframe>): $@/post
@set_attr(src, $@/@href): $@



