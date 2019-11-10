~version: "2.0"

$tbody: //section[has-class("cuerpo single-noticia")]
body: $tbody

title: //div[has-class("intro")]/h1
subtitle: //div[has-class("intro")]/h3

@replace("T", " "): //meta[@name="cXenseParse:recs:publishtime"]/@content
@replace(":", " ")
@replace(":[0-9][0-9]-[0-9][0-9]:[0-9][0-9]","")
@datetime(0, "en-US", "yyyy-MM-dd hh mm")
published_date: $@

@wrap(<figure>): //div[has-class("video-destacado")]/img
@append(<cite>): $@
@append_to($@): //div[has-class("bajada")]/p/text()
@wrap(<figcaption>): //div[has-class("video-destacado")]/figure/cite



@debug: //section[has-class("small-gal-wrap main-article-section")]


@remove: //p[has-class("fecha")]

@remove: //div[has-class("social")]

@remove: //div[has-class("intro")]/span

@remove: //section[has-class("small-gal-wrap main-article-section")]/ul
