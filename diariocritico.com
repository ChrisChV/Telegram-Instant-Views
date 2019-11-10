~version: "2.1"

?path_not: /mvc/amp/.*


@if(//div[@id="textoNoticia"]){
  $tbody: //div[@id="textoNoticia"]
}
@if_not(//div[@id="textoNoticia"]){
  $tbody: //div[@class="noticiaContent"]
}


body: $tbody

@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//strong/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..
@replace_tag(<div>): $tbody//a/iframe/..
@replace_tag(<div>): $tbody//p//img/../..
@replace_tag(<div>): $tbody//a//img/../..
@replace_tag(<div>): $tbody//td//img/../../..
@replace_tag(<div>): $tbody//h3/div/img/../..
@replace_tag(<div>): $tbody//h2/div/img/../..
@replace_tag(<div>): $tbody//a/div/span/img/../../..
@replace_tag(<div>): $tbody//strong/div/div/span/img/../../../..
@replace_tag(<div>): $tbody//p/div/div/img/../../..
@replace_tag(<div>): $tbody//p/div/div/div/span/img/../../../../..


title: //h1[@class="titulo"]
@replace("> ", ""): //h3[@class="antesubtitulo subtit"]
subtitle: //h3[@class="antesubtitulo subtit"]
subtitle: //div[@class="noticiadeapoyo"]
published_date: //meta[@itemprop="datePublished"]/@content

@replace_tag(<figure>): //div[@class="fotodiv"]
cover: $@
@append(<figcaption>)
@append_to($@): //td[@class="pie"]
@replace_tag(<cite>)


site_name: "Diariocrítico"  



author: //h3[@class="f-nombre"]/a/text()
author_url: //h3[@class="f-nombre"]/a/@href
author: //span[@class="nombre_firmante"]

image_url: $cover//img/@src

kicker: //h3[@class="antesubtitulo antetit"]




@map($tbody//div/img/..){
  @replace_tag(<figure>): $@
  $tfigure: $@
  @if($@/img/@alt){
    @html_to_dom: $@
    @append_to($tfigure)
    @replace_tag(<figcaption>)
  }
}


@map($tbody//figure){
  
  $tfigure: $@
  @if(($tfigure//img)[2]){
    @wrap(<figure>): $@
    @wrap(<figure>): ($tfigure//img)[1]
    @replace_tag(<div>): $tfigure
  }
  
}



@if_not($tbody/p) {
  @before(<p>): $tbody//br
}



@prepend_to($tbody): //div[@id="bloque_nadjuntos"]

@prepend_to($tbody): //div[@class="entradilla" and @itemprop="about"]
@wrap_inner(<b>)
@wrap_inner(<p>)

#@map($tbody//td//figure){
 # @set_attr(href, $@/@href): $@/img
#}

@map($tbody//figure){
  $tfigure: $@
  @if($tfigure/text()){
    $ttext: $@
    @append(<a>, href, $tfigure/@href): $tfigure
    @append_to($@): $ttext
  }
  @if($tfigure//figcaption/next-sibling::a){
    @after_el($tfigure): $@
  }
  @if($tfigure//img//next-sibling::a){
    @before_el($tfigure): $@
  }
  @set_attr(href, $tfigure/@href): $tfigure//img
}



@replace_tag(<related>): $tbody//img[@src="/bancodeimagenes/31/horoscopodiawhatsapp.jpg"]/../../next-sibling::table

@remove: //meta[@name="author"]

@remove: $tbody//img[@src="/fotos/WhatsApp.png"]/../..
@remove: $tbody//img[@src="/bancodeimagenes/31/horoscopodiawhatsapp.jpg"]
@remove: $tbody//hr
@remove: $tbody//b//table
#@remove: $tbody//table//td[text()]

@unsupported: $tbody//div[@id="container-widget-loteria-nacional-navidad"]




