~version: "2.1"


?path: /juegos/requisitos/.+
?not_exists: //meta[@content="game"]
!exists: //meta[@property="og:type" and (@content="article" or @content="game")]
!path_not: /autor/.+





@if(//div[@id="div_cuerpo_noticia"]){
  $tbody: //div[@id="div_cuerpo_noticia"]
  subtitle: $tbody/p
  
}
@if_not(//div[@id="div_cuerpo_noticia"]){
  @if(//div[@id="div_main"]//article){
    $tbody: //div[@id="div_main"]//article
    
  }
  @if((//div[@id="div_main"]//article)[2]){
    $tbody: (//div[@id="div_main"]//article)[2]
    
  }
  @if_not(//div[@id="div_main"]//article){
    $tbody: //div[@id="div_main"]
    
    @append(" "): $tbody//div[has-class("mar_rl12 mar_t12 s14 lh19 a_n fftit")]//b
    
    
    $tlink: $tbody//div[@class="fr"]/next-sibling::div[@class="fl"]
    @wrap(<ul>): $tlink
    @append_to($tlink/..): $tbody//div[@class="fr"]
    @replace_tag(<li>): $@/../div    
    $temp: "true"
    @if_not($tbody//li[@class="fl"]/a) {
       @remove: $tbody//li[@class="fl"]
    }
    @if_not($tbody//li[@class="fr"]/a) {
       @remove: $tbody//li[@class="fr"]
    }
  }
}


 kicker: $tbody//div[has-class("oh he52")]//h3
    
    @remove: //div[@class="dt c7 wi100 bg_pat_pl2 cab_gs brillo_cab"]
    @remove: $tbody//div[@class="mar_rl5"]
    @remove: $tbody//div[@class="oh he52"]
    @remove: $tbody//div[has-class("guia")]
    @remove: $tbody//div[@id="zona_comentarios"]
    @remove: $tbody//div[has-class("caja_gris_opc")]
    @remove: $tbody//div[@class="ffnav upp s24 b mar_rl10 mar_b10 mar_t30 c0"]
    @remove: $tbody//div[@class="ffnav b upp c1 s28 s24_600 mar_t10 mar_r10"]
    @remove: $tbody//div[@class="ffnav b col_plat s50 s36_600 mar_b16"]




@remove: //nav[has-class("ffnav bg_nav bg_nav_1 c1o a_c1o")]
@remove: //div[has-class("dt c7 wi100 bg_pat_pl1 cab_gs brillo_cab")]
@remove: //div[has-class("der2 columna_312_bg pr")]
@remove: //div[has-class("dt c7 wi100 bg_pat_pl5 cab_gs brillo_cab")]


@map($tbody//img){
  @set_attr(src, $@/@data-src): $@
}


body: $tbody


title: $tbody/h1
title: $tbody//p[has-class("s42 s36_600")]/strong/text()
title: $tbody//p[has-class("fftit s20 b")]
title: $tbody//p[has-class("s50 s36_600")]
title: $tbody//div[@class="txt nw oh"]/h2

kicker: $tbody//h2[has-class("s18 as14_600 n")]


author: $tbody//a[@rel="author"]
author: $tbody//span[@rel="author"]
author_url: $tbody//a[@rel="author"]/@href


@wrap_inner(<b>): $tbody//p[@class="s18 fw5 fftit c2 lh27 mar_t30 mar_b40"]

##Para dar formato a alguno titulo
@replace_tag(<h2>): //div[has-class("txt nw oh")]

##Para dar formato a la fecha
@replace("T", " "): //meta[@property="og:updated_time"]/@content
@match("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]")
published_date: $@
@datetime(0, "es-ES", "dd 'de' LLLL 'de' yyyy"): $tbody//span[has-class("c5 s12 pa r0")]/text()
published_date: $@
@datetime(0, "es-ES", "dd 'de' LLLL 'de' yyyy" ): $tbody//div[has-class("pr a_n")]/span/text()
published_date: $@



##Para dar formato a las figuras
@replace_tag(<div>): $tbody//img/../../a
@replace_tag(<figure>): $@/..
@replace_tag(<figcaption>): $@/span[@class="p"]



@replace_tag(<figure>): $tbody//img/..
@map($@){
  @append_to($@): $@/../next-sibling::span
  @replace_tag(<figcaption>)
}



@if_not($temp) {
  cover: ($tbody//figure)[1]
  @if(//div[has-class("video_main")]/div[@class="you_padre"]){
    @replace_tag(<figure>): //div[has-class("video_main")]
    cover: $@
  }
  @if(//div[has-class("video_main")]/figure[@id="video_iframe"]){
    $tvideo: $@
    @html_to_dom: $tvideo/@data-config
    @json_to_xml: $@/text()
    @append(<video>, src, $@/url_vid): $tvideo
    cover: $tvideo
  }
}

@append_to(//div[has-class("val_redondo")]/../../figure): //div[has-class("val_redondo")]
@replace_tag(<figcaption>): $@


##Para dar formato a algunos titulos
@wrap(<h1>): $tbody//strong[@class="tit2d titulo_art db"]
@map($tbody//p//h1/strong[@class="tit2d titulo_art db"]){
  @before_el($@/../..): $@/..
}




##Para dar formato a las blockquote
@replace_tag(<blockquote>): $tbody//strong[has-class("citas")]
@map($@){
  @before_el($@/..): $@ 
}

@remove: $tbody//div[@id="val_ana_3"]//img
@prepend_to($tbody//div[@id="val_ana_3"]): $tbody//div[@id="val_ana_3"]/div[has-class("nota_ana_end_3")]
@replace_tag(<h1>)
#@debug: $tbody//div[@id="val_ana_3"]
#@append_to($tbody//div[@id="val_ana_3"]): $tbody//div[@id="val_ana_3"]/div[has-class("nota_ana_3")]
@remove: $tbody//div[has-class("s14 b pr estre_ana_cont")]
@replace_tag(<ul>): $tbody//div[has-class("mar_l4 s16 c4 lh19 d_fl")]
@replace_tag(<li>): $@/p



## Para dar formato a los videos propios de la pagina
@map($tbody//figure[@id="video_iframe"]){
  $tvideo: $@
  @replace("\"",""): $tvideo/@data-config
  @replace("\\\\","")
  @match("url_vid:https:.*mp4,")
  @replace("url_vid:","")
  @replace(",","")
  @append(<video>): $tvideo
  @append(<source>, src, $tvideo/@data-config): $@
  @set_attr(type, "video/mp4"): $@
  
}




@replace_tag(<related>):  $tbody/div[has-class("mar_rl2 mar_t20 fftit s14 lh19 br3 a_n pad_10 caja_j_rela")]
@replace_tag(<h1>): $@/div//a

@if(//div[@id="div_cuerpo_noticia"]){
  #@remove: $tbody/div
  @remove: $tbody//div[@class="s11 c7 pad_t5 fr"]
  #@debug: $tbody
  @remove: $tbody//p[last()]
}

@replace_tag(<slideshow>): $tbody//figure/div[@data-page_actual]/..
@replace_tag(<div>): $tbody//p/slideshow/..

#@map($tbody//a[has-class("ffnav")]){
#  @replace_tag(<iframe>): $@
#  $tiframe: $@
#  @set_attr(src, ./@href): $@
#  @inline: $tiframe
  
#}



@remove: //script
#@remove: //div[has-class("val_redondo bg_c1c cF fftit b")]
@remove: //div[has-class("pr a_n")]
@remove: //div[has-class("dtc tar pr t2 wi1 nw")]
@remove: //div[has-class("nw oh ellipsis")]

@remove: $tbody//div[has-class("fr pr")]

@remove: //div[has-class("ico_comprar_34")]/next-sibling::p

@remove: $tbody//div[has-class("mar_rl12 mar_t12 s14 lh19 a_n fftit")]//br

@unsupported: $tbody//div[@id="zona_encuesta0"]






