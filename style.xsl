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
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
            background: #fafafa;
            color: #222;
        }

        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .cover {
            max-width: 250px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }

        .episode {
            background: white;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .episode h2 {
            margin-top: 0;
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
            color: #3366cc;
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

    <p>
        <xsl:value-of select="rss/channel/description"/>
    </p>

    <img class="cover">
        <xsl:attribute name="src">
            <xsl:value-of select="rss/channel/image/url"/>
        </xsl:attribute>
    </img>
</div>


<xsl:for-each select="rss/channel/item">

<div class="episode">

    <h2>
        <xsl:value-of select="title"/>
    </h2>

    <div class="meta">
        <xsl:value-of select="pubDate"/>
        <xsl:text> • </xsl:text>
        Duration: <xsl:value-of select="itunes:duration"/>
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
            View original episode page
        </a>
    </p>

</div>

</xsl:for-each>

</body>
</html>

</xsl:template>

</xsl:stylesheet>
