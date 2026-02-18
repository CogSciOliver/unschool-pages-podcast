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
body {
    font-family: -apple-system, BlinkMacSystemFont, Arial, sans-serif;
    max-width: 1100px;
    margin: 40px auto;
    padding: 0 20px;
    background: #f5f5f7;
    color: #1d1d1f;
    transition: background .3s, color .3s;
}

body.dark {
    background: #121212;
    color: #f1f1f1;
}

.header { text-align: center; margin-bottom: 40px; }

.cover {
    width: 240px;
    border-radius: 20px;
    box-shadow: 0 12px 30px rgba(0,0,0,0.15);
}

.controls {
    margin: 30px 0;
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
    justify-content: center;
}

input, select, button {
    padding: 8px 12px;
    border-radius: 8px;
    border: 1px solid #ccc;
}

button {
    cursor: pointer;
}

.episode {
    display: flex;
    gap: 20px;
    background: white;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 18px;
    box-shadow: 0 6px 18px rgba(0,0,0,0.06);
}

body.dark .episode {
    background: #1e1e1e;
}

.episode img {
    width: 130px;
    height: 130px;
    border-radius: 12px;
    object-fit: cover;
}

.episode-content { flex: 1; }

.meta {
    font-size: 0.85em;
    color: #777;
    margin-bottom: 8px;
}

.description {
    display: none;
    margin-top: 8px;
}

audio { width: 100%; margin-top: 10px; }

a { color: #0071e3; text-decoration: none; }
a:hover { text-decoration: underline; }
</style>

<script>
function toggleDesc(id){
    var el = document.getElementById(id);
    el.style.display = el.style.display === "none" ? "block" : "none";
}

function searchEpisodes(){
    var input = document.getElementById("search").value.toLowerCase();
    var episodes = document.getElementsByClassName("episode");
    for (var i=0;i<episodes.length;i++){
        var text = episodes[i].innerText.toLowerCase();
        episodes[i].style.display = text.includes(input) ? "flex" : "none";
    }
}

function filterSeason(){
    var season = document.getElementById("seasonFilter").value;
    var episodes = document.getElementsByClassName("episode");
    for (var i=0;i<episodes.length;i++){
        var s = episodes[i].getAttribute("data-season");
        episodes[i].style.display = (season==="all" || s===season) ? "flex" : "none";
    }
}

function toggleDark(){
    document.body.classList.toggle("dark");
}
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
</div>

<div class="controls">
    <input type="text" id="search" placeholder="Search episodes..." onkeyup="searchEpisodes()"/>
    
    <select id="seasonFilter" onchange="filterSeason()">
        <option value="all">All Seasons</option>
        <xsl:for-each select="rss/channel/item[not(itunes:season=preceding::item/itunes:season)]">
            <option>
                <xsl:attribute name="value">
                    <xsl:value-of select="itunes:season"/>
                </xsl:attribute>
                Season <xsl:value-of select="itunes:season"/>
            </option>
        </xsl:for-each>
    </select>

    <button onclick="toggleDark()">Toggle Dark Mode</button>
</div>

<xsl:for-each select="rss/channel/item">
<xsl:sort select="pubDate" order="descending"/>

<div class="episode">
<xsl:attribute name="data-season">
    <xsl:value-of select="itunes:season"/>
</xsl:attribute>

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
toggleDesc('desc<xsl:value-of select="position()"/>')
</xsl:attribute>
Show Description
</button>

<div class="description">
<xsl:attribute name="id">
desc<xsl:value-of select="position()"/>
</xsl:attribute>
<xsl:value-of select="description"/>
</div>

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

</xsl:for-each>

</body>
</html>

</xsl:template>
</xsl:stylesheet>
