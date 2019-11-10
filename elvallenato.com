~version: "2.1"



$tbody: //div[@class="contenido-content"]
body: $tbody



@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//a/iframe/..


title: //div[@class="title-content"]/h2

published_date: //meta[@itemprop="uploadDate"]/@content


@match("Fecha: .* \\|"): (//div[@class="title-content"]/p)[1]
@replace("Fecha: ", "")
@replace(" \\|", "")
published_date: $@



@prepend_to($tbody): (//div[@class="title-content"]/p)[3]

#author: //div[@class="title-content"]/h3
subtitle: (//div[@class="title-content"]/h3)[1]
author: //div[@class="title-content"]/span

cover: //div[@class="title-content"]/next-sibling::div/img
site_name: "ElVallenato.com"



@remove: $tbody//div[@class="video-reproductor"]/div
@html_to_dom: $tbody//div[@class="video-reproductor"]/script
@match("file: .*,")
@replace("\"", "")
@replace("file: ", "")
@replace(",", "")
@replace("/v/", "/embed/")
@replace_tag(<iframe>)
@set_attr(src, ./text()): $@


@remove: $tbody//script
@remove: $tbody//ins
@remove: //meta[@name="author"]

@append_to((//div[has-class("videos-relacionados")])[1]): //div[has-class("videos-relacionados")]/prev-sibling::div[@class="row title-page"]/h3
@replace_tag(<related>): (//div[has-class("videos-relacionados")])[1]
@append_to($tbody)

@replace_tag(<div>): $tbody//p
@wrap(<p>): $tbody/div/text()

@replace_tag(<related>): //div[has-class("letras-relacionadas")]
$trel: ($@)[1]
@prepend_to($trel): ($@/../../prev-sibling::div[has-class("title-page")])[1]
@append_to($tbody): $trel



?path: /vallenatos/.*

@prepend_to($tbody): (//div[@class="header-content"])[1]
title: $tbody//div[@class="header-content"]//h1
subtitle: $tbody//div[@class="header-content"]//h2
@remove: $tbody//div[@class="header-content"]//div[@class="icons"]
@replace_tag(<div>): $tbody//div[@class="header-content"]//p
@wrap(<p>): $@/text()

@remove: $tbody//a/div/img




