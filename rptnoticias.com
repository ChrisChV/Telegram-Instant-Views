~version: "2.0"

?exists: //meta[@property="og:type" and @content="article"]
!path_not: /contacto-noticias-de-valledupar/

$tbody: //div[@class="section_wrapper"]
body: $tbody

title: //div[@class="title_wrapper"]/h1

@replace_tag(<div>): $tbody//a/img/..

@replace_tag(<figure>): //div[@class="section section-post-header"]//div[has-class("image_frame")]
@replace_tag(<figcaption>): $@/p
cover: //div[@class="section section-post-header"]//figure[has-class("image_frame")]

@replace("i1.wp.com/",""): $cover//img/@src
@replace("i0.wp.com/",""): $cover//img/@src
@replace("\\?.*",""): $cover//img/@src


@replace_tag(<div>): $tbody//strong/img/..
@replace_tag(<div>): $tbody//p/div/img/../..
@replace_tag(<div>): $tbody//p/iframe/..

@replace_tag(<div>): $tbody//h3/iframe/..



@wrap(<p>): $tbody/text()
@set_attr(class, "figcaption"): $@
@replace_tag(<figure>): $tbody//p/img/..
@map($@){
  $tfigure: $@
  @replace_tag(<figcaption>): $tfigure/next-sibling::noscript/next-sibling::p[@class="figcaption"]
  @append_to($tfigure): $@
}






## Para dar formato a los relacionados
#@replace_tag(<related>): //div[@class="section-related-adjustment "]
#@append_to($tbody): $@
#@remove: $tbody//related/div/div/div[@class="single-photo-wrapper image"]



@replace_tag(<slideshow>): $tbody//div[has-class("gallery")]
@replace_tag(<figure>): $tbody//slideshow//dl
@replace_tag(<figcaption>): $@//dd

@replace_tag(<slideshow>): $tbody//ul[has-class("wp-block-gallery")]


@map(//div[has-class("wp-caption")]){
  @replace_tag(<figure>): $@
  $tfigure: $@
  @replace_tag(<figcaption>): $@/p
  @remove: $tfigure//noscript
  @if($tfigure//img/@data-orig-file){
    @replace("\\?.*", ""): $tfigure//img/@data-orig-file
    @set_attr(src, ./@data-orig-file): $tfigure//img
  }
}



@remove: $tbody//div[@class="sharedaddy sd-sharing-enabled"]
@remove: $tbody//div[has-class("sd-like")]
@remove: $tbody//noscript

