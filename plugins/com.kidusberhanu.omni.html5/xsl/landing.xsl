<?xml version="1.0" encoding="UTF-8"?>
<!--
  Branded landing page for index.html.
  Plugged into the HTML5 cover transform through the dita.xsl.html5.cover
  extension point. Extension points are global to the toolkit, so the template
  only fires when omni.landing = 'yes', a parameter that only the omni-html5
  transtype sets (see insertParameters.xml and build_omni-html5.xml). Plain
  html5 builds keep the stock index page.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="3.0">

  <xsl:param name="omni.landing" as="xs:string" select="'no'"/>

  <!-- The cover transform doesn't receive args.hdf, so add the head tags here -->
  <xsl:template match="*[contains(@class, ' map/map ')][$omni.landing = 'yes']"
                mode="gen-user-head" priority="10">
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="theme-color" content="#12284C"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' map/map ')][$omni.landing = 'yes']"
                mode="chapterBody" priority="10">
    <xsl:variable name="meta" select="*[contains(@class, ' bookmap/bookmeta ')]"/>
    <xsl:variable name="title"
        select="normalize-space((.//*[contains(@class, ' bookmap/mainbooktitle ')])[1])"/>
    <xsl:variable name="subtitle"
        select="normalize-space((.//*[contains(@class, ' bookmap/booktitlealt ')])[1])"/>
    <xsl:variable name="version"
        select="string(($meta//*[contains(@class, ' topic/vrm ')])[1]/@version)"/>
    <xsl:variable name="tagline"
        select="string(($meta//*[contains(@class, ' topic/data ')][@name = 'tagline'])[1]/@value)"/>
    <xsl:variable name="first"
        select="(.//*[contains(@class, ' bookmap/chapter ')][@href])[1]/@href"/>

    <body class="omni-landing">
      <header>
        <xsl:copy-of select="document('../include/header.xml')/*"/>
      </header>
      <main role="main">
        <section class="omni-hero">
          <p class="omni-eyebrow">
            <xsl:value-of select="string-join(($subtitle, concat('Version ', $version)), '  |  ')"/>
          </p>
          <h1 class="omni-hero-title"><xsl:value-of select="$title"/></h1>
          <xsl:if test="$tagline != ''">
            <p class="omni-tagline"><xsl:value-of select="$tagline"/></p>
          </xsl:if>
          <p class="omni-cta">
            <a class="omni-btn omni-btn-primary"
               href="{replace(string($first), '\.dita$', '.html')}">Start reading</a>
            <a class="omni-btn" href="pdf/OMNI-MESH-User-Guide.pdf">User guide (PDF)</a>
            <a class="omni-btn" href="pdf/OMNI-MESH-Technical-Edition.pdf">Technical edition (PDF)</a>
          </p>
        </section>
        <section class="omni-contents" aria-label="Contents">
          <h2>Contents</h2>
          <xsl:variable name="map" as="element()*">
            <xsl:apply-templates select="." mode="normalize-map"/>
          </xsl:variable>
          <xsl:apply-templates select="$map" mode="toc"/>
        </section>
      </main>
      <footer>
        <xsl:copy-of select="document('../include/footer.xml')/*"/>
      </footer>
    </body>
  </xsl:template>

</xsl:stylesheet>
