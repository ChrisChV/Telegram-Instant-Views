~version: "2.0"

@if(//div[@id="cuerpo_noticia"]){
  $tbody: //div[@id="cuerpo_noticia"]
}
@if(//div[@class="base_40_article"]){
  $tbody: //div[@class="base_40_article"]
}



body: $tbody


title: //article[@class="contenido_articulo_salida_video"]/h1
subtitle: //article[@class="contenido_articulo_salida_video"]/h2

author: //div[@class="contenido_autor_entrada_video_z2"]//h2/a
author_url: //div[@class="contenido_autor_entrada_video_z2"]//h2/a/@href

@replace("T"," "): //meta[@name="date"]/@content
@replace("\\+.*","")
published_date: $@

cover: //div[@class="base_imagen_articulo_z1 h30"]//img

@map($tbody//div[@class="media"]/div/script[2]){
  @htmldecode: $@
  @match("datosVideo_.*.urls.push\\(.*\\)")
  @replace("datosVideo_.*.urls.push\\('", "")
  @replace("'\\)", "")
  @wrap(<figure>): $@/..
  @append(<iframe>, src, $@/div/script[2]/text()): $@ 
  @replace_tag(<figcaption>): $@/../div/p
}

@prepend_to($tbody): //div[@class="contenedor_fotos_galeria_z2"]
##DESCOMENTAR ESTO
#@replace_tag(<div>): $tbody//a//img/..


@set_attr(src, ./@data-src): $tbody//img[@data-src]
@replace_tag(<figure>): $tbody//div[@class="contenedor_imagen_centro_z2"]
@replace_tag(<figcaption>): $@/p


@replace("\u00a0", ""): $tbody//p/text()
@remove: $tbody//a[not(text())]




