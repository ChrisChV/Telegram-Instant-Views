~version: "2.1"

$tbody: //div[@class="notecontent"]
body: $tbody

title: //h1[@class="titulo-notared"]

@before(<p>): $tbody//br



author: //span[@class="nota-autor"]

published_date: //time[@itemprop="datePublished"]/@content

@replace_tag(<figure>): //article[@class="notaprimaria"]
cover: $@
@replace_tag(<figcaption>): $@//div[has-class("nota-pie-foto")]

@debug: //div[@id="myGallery"]
