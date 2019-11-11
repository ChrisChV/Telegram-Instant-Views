~version: "2.1"

$tbody: //div[@class="gallery"]
body: $tbody

@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//a/iframe/..


title: //div[@class="col-xs-12 col-sm-8 nopaddingleft"]/div/h1

@replace_tag(<figure>): (//div[@class="col-xs-12 col-sm-8 nopaddingleft"]//picture)[1]
cover: $@
@append_to($@): $@/next-sibling::noscript/next-sibling::p/em
@replace_tag(<figcaption>)

author: //div[has-class("editorImgContainer")]/next-sibling::div//a/text()
author_url: //div[has-class("editorImgContainer")]/next-sibling::div//a/@href


@match("[A-Z][a-z][a-z] [0-9][0-9], [0-9][0-9][0-9][0-9]"): //i[@class="fa fa-clock-o"]/../text()
@datetime(0, "en-US", "MMM dd, yyyy"): ($@)[1]
published_date: $@

site_name: "Technology Networks"

@map($tbody//p){
  $tp: $@
  @if($@//br){
    @before(<p>): $@
    @replace_tag(<div>): $tp
  }
  
}

@replace_tag(<related>): //div[@class="col-xs-12 col-sm-8 nopaddingleft"]//hr[@class="relatedContentHr"]/..
#@append_to($tbody)

