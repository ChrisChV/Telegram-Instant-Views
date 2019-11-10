~version: "2.1"

?exists: //meta[@property="og:type" and @content="article"]
?path: /frances/.+
?path: /english/.+

$tbody: //div[@class="col-sm-8"]
body: $tbody


@replace_tag(<div>): $tbody//p/img/..
@replace_tag(<div>): $tbody//a/img/..
@replace_tag(<div>): $tbody//em/img/..
@replace_tag(<div>): $tbody//p/iframe/..

title: $tbody//h1

@datetime(0, "es-ES", "EEEE, dd 'de' MMMM 'de' yyyy '-' HH:mm"): $tbody//h5/small/text()[1]
published_date: $@

image_url: $tbody//img/@src

site_name: "Radio Cadena Agramonte"

@remove: $tbody//ol
@remove: $tbody//h5/small/..
@remove: $tbody//div[@id="collapseExample"]
@remove: $tbody//span[@class="glyphicon glyphicon-tags"]/../..
@remove: $tbody//a[@id="upl"]/..
@remove: $tbody//hr
@remove: $tbody//div[has-class("panel")]
@remove: $tbody//a[@id="coment"]

