<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">

<xsl:output method="html" indent="yes"/>

<xsl:template match="/">

<html>
<head>
<title><xsl:value-of select="rss/channel/title"/></title>

<style>
:root {
    --brand: #7a5cff; /* CHANGE THIS FOR YOUR BRAND COLOR */
}

body {
    font-family: -apple-system, BlinkMacSystemFont, Arial, sans-serif;
    max-width: 1100px;
    margin: 40px auto;
    padding: 0 20px;
    background: #f5f5f7;
    color: #1d1d1f;
}

.header { text-align:center; margin-bottom:40px; }

.cover {
    width:220px;
    border-radius:20px;
    box-shadow:0 10px 25px rgba(0,0,0,.15);
}

.subscribe a {
    margin:0 10px;
    padding:8px 14px;
    background:var(--brand);
    color:white;
    border-radius:8px;
    text-decoration:none;
    font-size:.9em;
}

.episode {
    display:flex;
    gap:20px;
    background:white;
    padding:20px;
    margin-bottom:20px;
    border-radius:16px;
    box-shadow:0 5px 15px rgba(0,0,0,.05);
    transition:transform .2s ease;
}

.episode:hover { transform:translateY(-3px); }

.episode img {
    width:120px;
    height:120px;
    border-radius:12px;
    object-fit:cover;
}

.episode-content { flex:1; }

.meta {
    font-size:.85em;
    color:#777;
    margin-bottom:8px;
}

.details {
    display:none;
    margin-top:10px;
    animation:fade .3s ease-in-out;
}

@keyframes fade {
    from { opacity:0; }
    to { opacity:1; }
}

button {
    background:var(--brand);
    color:white;
    border:none;
    padding:6px 12px;
    border-radius:6px;
    cursor:pointer;
    margin-top:5px;
}

audio { width:100%; margin-top:10px; }

.pagination {
    text-align:center;
    margin-top:30px;
}

.pagination button {
    margin:0 5px;
}
</style>

<script>
var currentPage = 1;
var perPage = 10;

function paginate(){
    var episodes = document.getElementsByClassName("episode");
    for(var i=0;i<episodes.length;i++){
        episodes[i].style.display="none";
    }
    var start=(currentPage-1)*perPage;
    var end=start+perPage;
    for(var i=start;i<end && i<episodes.length;i++){
        episodes[i].style.display="flex";
    }
}

function nextPage(){
    var episodes=document.getElementsByClassName("episode");
    if(currentPage*perPage < episodes.length){
        currentPage++;
        paginate();
    }
}

function prevPage(){
    if(currentPage>1){
        currentPage--;
        paginate();
    }
}

function toggleDetails(id){
    var el=document.getElementById(id);
    el.style.display = el.style.display==="block" ? "none" : "block";
}

window.onload=paginate;
</script>

</head>

<body>

<div class="header">
<h1><xsl:value-of select="rss/channel/title"/></h1>
<p><xsl:value-of select="rss/channel/description"/></p>

<img class="cover">
<xsl:attribute name="src">
<xsl:value-of select="rss/channel/image/url"/>
</xsl:attribute>
</img>

<div class="subscribe">
<a href="https://podcasts.apple.com/">Apple Podcasts</a>
<a href="https://open.spotify.com/">Spotify</a>
<a href="#">RSS</a>
</div>
</div>

<xsl:for-each select="rss/channel/item">
<xsl:sort select="pubDate" order="descending"/>

<div class="episode">

<img>
<xsl:attribute name="src">
<xsl:choose>
<xsl:when test="itunes:image/@href">
<xsl:value-of select="itunes:image/@href"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/rss/channel/image/url"/>
</xsl:otherwise>
</xsl:choose>
</xsl:attribute>
</img>

<div class="episode-content">

<h2><xsl:value-of select="title"/></h2>

<div class="meta">
Season <xsl:value-of select="itunes:season"/> •
Episode <xsl:value-of select="itunes:episode"/> •
<xsl:value-of select="pubDate"/> •
<xsl:value-of select="itunes:duration"/>
</div>

<button>
<xsl:attribute name="onclick">
toggleDetails('ep<xsl:value-of select="position()"/>')
</xsl:attribute>
View Episode
</button>

<div class="details">
<xsl:attribute name="id">
ep<xsl:value-of select="position()"/>
</xsl:attribute>

<p><xsl:value-of select="description"/></p>

<audio controls="controls">
<xsl:attribute name="src">
<xsl:value-of select="enclosure/@url"/>
</xsl:attribute>
</audio>

<p>
<a>
<xsl:attribute name="href">
<xsl:value-of select="enclosure/@url"/>
</xsl:attribute>
Download Episode
</a>
</p>

</div>

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
