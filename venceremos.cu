~version: "2.0"

#?path_not: /blogs-venceremos
?path_not: /quienes-somos

$tbody: //div[@class="item-page"]
body: $tbody

#@debug: $tbody//p
$tspans: $tbody//span[contains(@id,"cloak")]
@map($tspans){
  $tspan: $@
  @wrap_inner(<div>): $tspan
  @remove: $@
  @html_to_dom: $tspan/next-sibling::script
  $tdom: $@
  
  @replace("var .* =", ""): $@/text()
  
  @replace("document.*;", "")
  @replace(".*document.*", "")
  @replace("addy.*=", "")
@replace("addy................................", "")
  @replace(" \\+ ", "")
  @replace("'", "")
  @replace(".*=.*;", "")
  @replace(";document.*=", "")  
  @replace("\n", "")
  @replace("\t", "")
  @replace(" ", "")
  @replace("@;", "@")
  @replace(";$", "")
  @replace(";", ":")
  @append_to($tspan): $@
  @wrap_inner(<a>): $tspan
  @set_attr(href, ./text()): $@
  @replace("mailto:", ""): $tspan/a/text()
  @remove: $tdom
}


@replace_tag(<div>): $tbody//p//a/span/img/../../..
@replace_tag(<div>): $tbody//p/a/img/../..
@replace_tag(<div>): $tbody//p//span//img/../..
@replace_tag(<div>): $tbody//p//iframe/..
@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/span/img/../..
@replace_tag(<div>): $tbody//a/img/..


title: //div[@class="page-header"]/h2


@replace("\/.*", ""): //dl[@class="article-info muted"]/dd[@class="createdby"]/span/text()
author: $@
@replace("T", " "): //dl[@class="article-info muted"]/dd[@class="published"]/time/@datetime
@replace("\\+.*",""):
published_date: $@


@wrap(<figure>): $tbody//img
@map($tbody//span[has-class("wf_caption")]){
  $tfigure: $@
  @replace_tag(<figcaption>): $tfigure//span
  @append_to($tfigure/figure): $@
}
@replace_tag(<figcaption>): $tbody//figure/span//span
@map($tbody//div[has-class("wp-caption")]){
  $tfigure: $@
  @replace_tag(<figcaption>): $tfigure//p
  @append_to($tfigure/figure): $@
}



cover: $tbody//div[@class="joomla_add_this"]/next-sibling::div/figure
cover: $tbody//div[@class="joomla_add_this"]/next-sibling::div/span/figure





@remove: //div[@class="icons"]
@remove: //dl[@class="article-info muted"]
@remove: //div[@id="jc"]

@remove: //script
@remove: $tbody//span[@style="border-radius: 2px; text-indent: 20px; width: auto; padding: 0px 4px 0px 0px; text-align: center; font: bold 11px/20px 'Helvetica Neue',Helvetica,sans-serif; color: #ffffff; background: #bd081c  no-repeat scroll 3px 50% / 14px 14px; position: absolute; opacity: 1; z-index: 8675309; display: none; cursor: pointer;"]

@replace("\u00a0", ""): $tbody//p/text()


@unsupported: $tbody//div[@class="wp-polls"]






