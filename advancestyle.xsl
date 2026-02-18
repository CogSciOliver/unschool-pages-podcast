<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">

<xsl:output method="html" indent="yes"/>

<xsl:template match="/">

<html>
<head>
<title>
<xsl:value-of select="rss/channel/title"/>
</title>

<style>
body {
    font-family: -apple-system, BlinkMacSystemFont, Arial, sans-serif;
    max-width: 1000px;
    margin: 40px auto;
    padding: 0 20px;
    background: #f5f5f7;
    color: #1d1d1f;
}

.header {
    text-align: center;
    margin-bottom: 50px;
}

.cover {
    width: 260px;
    border-radius: 20px;
    box-shadow: 0 12px 30px rgba(0,0,0,0.15);
}

.description {
    max-width: 600px;
    margin: 20px auto;
    color: #555;
}

.episode {
    display: flex;
    gap: 20px;
    background: white;
    padding: 20px;
    margin-bottom: 25px;
    border-radius: 18px;
    box-shadow: 0 6px 18px rgba(0,0,0,0.06);
}

.episode img {
    width: 140px;
    height: 140px;
    border-radius: 12px;
    object-fit: cover;
}

.episode-content {
    flex: 1;
}

.meta {
    font-size: 0.9em;
    color: #777;
    margin-bottom: 10px;
}

audio {
    width: 100%;
    margin-top: 10px;
}

a {
    color: #0071e3;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}
</style>

</head>

<body>

<div class="header">
    <h1>
        <xsl:value-of select="rss/channel/title"/>
    </h1>

    <div class="description">
        <xsl:value-of select="rss/channel/description"/>
    </div>

    <img class="cover">
        <xsl:attribute name="src">
            <xsl:value-of select="rss/channel/image/url"/>
        </xsl:attribute>
    </img>
</div>


<!-- Sort newest first -->
<xsl:for-each select="rss/channel/item">
<xsl:sort select="pubDate" order="descending"/>

<div class="episode">

    <!-- Episode Image (fallback to show image if none) -->
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

        <h2>
            <xsl:value-of select="title"/>
        </h2>

        <div class="meta">
            <xsl:text>Season </xsl:text>
            <xsl:value-of select="itunes:season"/>
            <xsl:text> • Episode </xsl:text>
            <xsl:value-of select="itunes:episode"/>
            <xsl:text> • </xsl:text>
            <xsl:value-of select="pubDate"/>
            <xsl:text> • </xsl:text>
            <xsl:value-of select="itunes:duration"/>
        </div>

        <p>
            <xsl:value-of select="description"/>
        </p>

        <audio controls="controls">
            <xsl:attribute name="src">
                <xsl:value-of select="enclosure/@url"/>
            </xsl:attribute>
        </audio>

        <p>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="link"/>
                </xsl:attribute>
                Open Episode Page
            </a>
        </p>

    </div>

</div>

</xsl:for-each>

</body>
</html>

</xsl:template>

</xsl:stylesheet>

