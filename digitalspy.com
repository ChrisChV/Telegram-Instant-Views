~version: "2.1"

$tbody: //div[has-class("article-body-content")]
@if(//div[@class="listicle-body"]){
 $tbody: //div[@class="listicle-body"]
}


@if(//div[has-class("slideshow-container")]){
  $tbody: //div[has-class("slideshow-container")]
  
  @map($tbody//picture/../..){
    @replace_tag(<figure>): $@
    $tfigure: $@
    @append(<figcaption>)
    @append(<cite>): $tfigure//figcaption
    @append_to($tfigure//figcaption): $tfigure/../../../div[@class="slideshow-slide-content"]
    @append_to($tfigure//cite): $tfigure//span[@class="image-photo-credit"]/text()
    @if($tfigure//span[@class="image-copyright"]){
      @append(" "): $tfigure//cite
      @append_to($tfigure//cite): $tfigure//span[@class="image-copyright"]/text()
      
    }
    
    
  }
  @replace_tag(<slideshow>): $tbody//div[@class="slide-container    "]
  @remove: $tbody//span[@class="slide-button-view-gallery-text"]
  @remove: $tbody//span[@class="slide-button-view-gallery-count"]
  @remove: $tbody//div[@class="next-gallery-flyout-mask"]
  @remove: $tbody//button
  @remove: $tbody//div[@class="authors "]
  @remove: $tbody//div[@class="slideshow-rail"]
}

body: $tbody





@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//a/iframe/..
@replace_tag(<div>): $tbody//a/picture/img/../..
@replace_tag(<div>): $tbody//a/div/div/div/img/../../../..


@map($tbody//iframe){
  @set_attr(src, ./@data-src): $@  
}
@map($tbody//img){
  @set_attr(src, ./@data-src): $@
}





@map($tbody//div[has-class("embed-image")]){
  @replace_tag(<figure>): $@
  $tfigure: $@
  @append(<figcaption>)
  @replace_tag(<cite>): $tfigure//div[@class="image-credit embed-image-credit"]
  @append_to($tfigure//figcaption)
  @if($tfigure//span[@class="image-photo-credit"]){
    @if($tfigure//span[@class="image-copyright"]){
      @append(" "): $tfigure//span[@class="image-photo-credit"]
    }
  }
}

@map(//div[@class="product-embed-image-wrap"]){
  @replace_tag(<figure>): $@
  $tfigure: $@
  @append(<figcaption>)
  @replace_tag(<cite>): $tfigure//div[has-class("image-credit")]
  @append_to($tfigure//figcaption)
  @replace_tag(<p>): $tfigure/next-sibling::div[@class="product-embed-info"]/div/div
  
  
}

title: //h1[@class="content-hed standard-hed"]
subtitle: //h2[@class="content-dek standard-dek"]/next-sibling::p
published_date: //time/@datetime
@if_not((//span[@class="byline-name"])[2]){
  author: //span[@class="byline-name"]/text()
  author_url: //a[@class="byline-name"]/@href
}
@if((//span[@class="byline-name"])[2]){
  @append(" and "): (//span[@class="byline-name"])[1]
  @append_to((//span[@class="byline-name"])[1]): (//span[@class="byline-name"])[2]
  author: //span[@class="byline-name"]
}



@replace_tag(<figure>): //div[has-class("content-lede-image")]
cover: $@
@append(<figcaption>)
@append(<cite>): $@
@append_to($@): $cover//span[@class="image-photo-credit"]
@if($cover//span[@class="image-photo-credit"]){
  @append(" "): $cover//cite
}
@append_to($cover//cite): $cover//span[@class="image-copyright"]

#@append_to($cover//figcaption)
@set_attr(src, ./@data-src): $cover//img


@map(//div[has-class("embed-editorial-links")]){
  @append_to($tbody): $@
}

@combine: //div[has-class("embed-editorial-links")]/next-sibling::div[has-class("embed-editorial-links")]
@replace_tag(<related>): //div[has-class("embed-editorial-links")]
@replace_tag(<h1>): $tbody//related//div[@class="editorial-links-header"]

@replace("resize=", ""): $cover//img/@src




@remove: $tbody//iframe[contains(@id,"poll")]
@remove: $tbody//div[@class="gallery-module   "]

@if(//div[has-class("glimmerPlayer")]){
   @prepend_to($tbody): //div[has-class("glimmerPlayer")]
}

@unsupported: //div[has-class("glimmerPlayer")]



