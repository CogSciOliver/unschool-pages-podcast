<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">

<xsl:output method="html" indent="yes"/>

<xsl:template match="/">

<html>
<head>
<title><xsl:value-of select="rss/channel/title"/></title>

<!-- SEO meta -->
<meta name="description">
<xsl:attribute name="content">
<xsl:value-of select="rss/channel/description"/>
</xsl:attribute>
</meta>

<meta property="og:title">
<xsl:attribute name="content">
<xsl:value-of select="rss/channel/title"/>
</xsl:attribute>
</meta>

<meta property="og:description">
<xsl:attribute name="content">
<xsl:value-of select="rss/channel/description"/>
</xsl:attribute>
</meta>

<meta property="og:image">
<xsl:attribute name="content">
<xsl:value-of select="rss/channel/image/url"/>
</xsl:attribute>
</meta>

<!-- JSON-LD structured data for the PodcastSeries -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "PodcastSeries",
  "name": "<xsl:value-of select='rss/channel/title'/>",
  "description": "<xsl:value-of select='rss/channel/description'/>",
  "url": "<xsl:value-of select='rss/channel/link'/>",
  "image": "<xsl:value-of select='rss/channel/image/url'/>",
  "publisher": {
    "@type": "Organization",
    "name": "<xsl:value-of select='rss/channel/title'/>"
  }
}
</script>

<!-- Styles -->
<style>
:root { --brand:#7a5cff; }
body { font-family:-apple-system,BlinkMacSystemFont,Arial,sans-serif; max-width:1100px; margin:40px auto; padding:0 20px; background:#f5f5f7; color:#1d1d1f; transition: background .3s,color .3s; }
body.dark { background:#121212; color:#f1f1f1; }
.header { text-align:center; margin-bottom:40px; }
.cover { width:220px; border-radius:20px; box-shadow:0 10px 25px rgba(0,0,0,.15); }
.subscribe a { margin:0 10px; padding:8px 14px; background:var(--brand); color:white; border-radius:8px; text-decoration:none; font-size:.9em; }
.episode { display:flex; gap:20px; background:white; padding:20px; margin-bottom:20px; border-radius:16px; box-shadow:0 5px 15px rgba(0,0,0,.05); transition:transform .2s ease; }
body.dark .episode { background:#1e1e1e; }
.episode:hover { transform:translateY(-3px); }
.episode img { width:120px; height:120px; border-radius:12px; object-fit:cover; }
.episode-content { flex:1; }
.meta { font-size:.85em; color:#777; margin-bottom:8px; }
.details { display:none; margin-top:10px; animation:fade .3s ease-in-out; }
@keyframes fade { from{opacity:0;} to{opacity:1;} }
button { background:var(--brand); color:white; border:none; padding:6px 12px; border-radius:6px; cursor:pointer; margin-top:5px; }
audio { width:100%; margin-top:10px; }
.pagination { text-align:center; margin-top:30px; }
.pagination button { margin:0 5px; }
input, select { padding:8px 12px; border-radius:8px; border:1px solid #ccc; margin-bottom:15px; }
</style>

<!-- Scripts -->
<script>
var currentPage=1, perPage=10;
function paginate(){var e=document.getElementsByClassName("episode");for(var i=0;i<e.length;i++){e[i].style.display="none";}var s=(currentPage-1)*perPage, t=s+perPage;for(var i=s;i<t&&i<e.length;i++){e[i].style.display="flex";}}
function nextPage(){var e=document.getElementsByClassName("episode"); if(currentPage*perPage<e.length){currentPage++; paginate();}}
function prevPage(){if(currentPage>1){currentPage--; paginate();}}
function toggleDetails(id){var e=document.getElementById(id); e.style.display=e.style.display==="block"?"none":"block";}
function searchEpisodes(){var input=document.getElementById("search").value.toLowerCase();var eps=document.getElementsByClassName("episode");for(var i=0;i<eps.length;i++){eps[i].style.display=eps[i].innerText.toLowerCase().includes(input)?"flex":"none";}}
function filterSeason(){var s=document.getElementById("seasonFilter").value;var eps=document.getElementsByClassName("episode");for(var i=0;i<eps.length;i++){eps[i].style.display=(s==="all"||eps[i].getAttribute("data-season")===s)?"flex":"none";}}
function toggleDark(){document.body.classList.toggle("dark");}
window.onload=paginate;
</script>

</head>

<body>

<div class="header">
<h1><xsl:value-of select="rss/channel/title"/></h1>
<p><xsl:value-of select="rss/channel/description"/></p>
<img class="cover"><xsl:attribute name="src"><xsl:value-of select="rss/channel/image/url"/></xsl:attribute></img>

<div class="subscribe">
<a><xsl:attribute name="href">https://podcasts.apple.com/search?term=<xsl:value-of select='rss/channel/title'/></xsl:attribute>Apple Podcasts</a>
<a><xsl:attribute name="href">https://open.spotify.com/search/<xsl:value-of select='rss/channel/title'/></xsl:attribute>Spotify</a>
<a><xsl:attribute name="href"><xsl:value-of select="rss/channel/link"/></xsl:attribute>RSS</a>
</div>

<div class="controls">
<input type="text" id="search" placeholder="Search episodes..." onkeyup="searchEpisodes()"/>
<select id="seasonFilter" onchange="filterSeason()">
<option value="all">All Seasons</option>
<xsl:for-each select="rss/channel/item[not(itunes:season=preceding::item/itunes:season)]">
<option><xsl:attribute name="value"><xsl:value-of select="itunes:season"/></xsl:attribute>Season <xsl:value-of select="itunes:season"/></option>
</xsl:for-each>
</select>
<button onclick="toggleDark()">Dark Mode</button>
</div>
</div>

<!-- Episodes -->
<xsl:for-each select="rss/channel/item">
<xsl:sort select="pubDate" order="descending"/>

<div class="episode">
<xsl:attribute name="data-season"><xsl:value-of select="itunes:season"/></xsl:attribute>

<!-- Episode JSON-LD -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "PodcastEpisode",
  "name": "<xsl:value-of select='title'/>",
  "description": "<xsl:value-of select='description'/>",
  "datePublished": "<xsl:value-of select='pubDate'/>",
  "episodeNumber": "<xsl:value-of select='itunes:episode'/>",
  "partOfSeries": {
    "@type": "PodcastSeries",
    "name": "<xsl:value-of select='/rss/channel/title'/>"
  },
  "associatedMedia": {
    "@type": "AudioObject",
    "contentUrl": "<xsl:value-of select='enclosure/@url'/>",
    "duration": "<xsl:value-of select='itunes:duration'/>"
  }
}
</script>

<img><xsl:attribute name="src"><xsl:choose><xsl:when test="itunes:image/@href"><xsl:value-of select="itunes:image/@href"/></xsl:when><xsl:otherwise><xsl:value-of select="/rss/channel/image/url"/></xsl:otherwise></xsl:choose></xsl:attribute></img>

<div class="episode-content">
<h2><xsl:value-of select="title"/></h2>
<div class="meta">Season <xsl:value-of select="itunes:season"/> • Episode <xsl:value-of select="itunes:episode"/> • <xsl:value-of select="pubDate"/> • <xsl:value-of select="itunes:duration"/></div>

<button><xsl:attribute name="onclick">toggleDetails('ep<xsl:value-of select="position()"/>')</xsl:attribute>View Episode</button>

<div class="details" id="ep<xsl:value-of select='position()'/>">
<p><xsl:value-of select="description"/></p>
<audio controls="controls"><xsl:attribute name="src"><xsl:value-of select="enclosure/@url"/></xsl:attribute></audio>
<p><a><xsl:attribute name="href"><xsl:value-of select="enclosure/@url"/></xsl:attribute>Download Episode</a></p>
</div>
</div>
</xsl:for-each>

<div class="pagination">
<button onclick="prevPage()">Previous</button>
<button onclick="nextPage()">Next</button>
</div>

</body>
</html>

</xsl:template>
</xsl:stylesheet>
