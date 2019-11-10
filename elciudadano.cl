~version: "2.0"

@if(//span[@class="cb-itemprop"]){
  $tbody: //span[@class="cb-itemprop"]
}
@if_not(//span[@class="cb-itemprop"]) {
  $tbody: //section[has-class("the_content")]
}

body: $tbody

@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//p/div/img/../..
@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//p/iframe[not(@class)]/..



title: //div[has-class("hentry")]/h1[has-class("entry-title")]

author: //span[has-class("author")]
author_url: //span[has-class("author")]//a/@href
subtitle: //span[@class="titular-bajada"]
site_name: "El Ciudadano"

@set_attr(src, ./@data-lazy-src): //div[@id="cb-featured-image"]/div[@class="cb-mask"]/img
cover: //div[@id="cb-featured-image"]/div[@class="cb-mask"]/img
cover: //div[@id="cb-par-wrap"]/img

published_date: //div[has-class("hentry")]//span[@class="cb-date"]/time/@datetime

kicker: //span[@class="titular-epigrafe"]

@replace_tag(<figure>): $tbody//noscript/img/..
@map($@){
  @append_to($@): $@/next-sibling::p[@class="wp-caption-text"]
  @replace_tag(<figcaption>): $@
}


@remove: $tbody//iframe[@class="wp-embedded-content"]

#@combine: $tbody//blockquote[@class="wp-embedded-content"]/next-sibling::blockquote[@class="wp-embedded-content"]

@remove: $tbody//blockquote[@class="wp-embedded-content"]/next-sibling::p
@combine: $tbody//blockquote[@class="wp-embedded-content"]/next-sibling::blockquote[@class="wp-embedded-content"]
@replace_tag(<related>): $tbody//blockquote[@class="wp-embedded-content"]
#@replace_tag(<h1>): $tbody//related/prev-sibling::p/em/strong/../..
#@replace_tag(<h1>): $tbody//related/prev-sibling::p/strong/..
#@append_to($tbody//related[@class="wp-embedded-content"]): $@

@remove: $tbody//form
@remove: $tbody//script
@remove: $tbody//p/strong/b/img/../../..
@remove: $tbody//div[@id="newsletter-signup"]
@remove: $tbody//div[contains(@id,"Preload")]




@replace("\u00a0", ""): $tbody//p/text()

@remove: $tbody//img[@data-lazy-src]



