<?xml version="1.0" encoding="UTF-8"?>
<!--
  Template overrides for the omni-pdf transtype:
    * a branded front cover driven entirely by bookmap metadata
    * one running header and footer used on every body and contents page
  Text comes from the map (titles, prodinfo, critdates, bookrights, data) and
  from cfg/common/vars/en.xml, so nothing product-specific is hard-coded here.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="2.0">

  <!-- Metadata pulled from the merged bookmap ($map is defined by PDF2) -->
  <xsl:variable name="omni.product"
      select="normalize-space(($map//*[contains(@class, ' topic/prodname ')])[1])"/>
  <xsl:variable name="omni.title"
      select="normalize-space(($map//*[contains(@class, ' bookmap/mainbooktitle ')])[1])"/>
  <xsl:variable name="omni.subtitle"
      select="normalize-space(($map//*[contains(@class, ' bookmap/booktitlealt ')])[1])"/>
  <xsl:variable name="omni.version"
      select="string(($map//*[contains(@class, ' topic/vrm ')])[1]/@version)"/>
  <xsl:variable name="omni.platform"
      select="normalize-space(($map//*[contains(@class, ' topic/platform ')])[1])"/>
  <xsl:variable name="omni.revised"
      select="string(($map//*[contains(@class, ' topic/revised ')])[1]/@modified)"/>
  <xsl:variable name="omni.tagline"
      select="string(($map//*[contains(@class, ' topic/data ')][@name = 'tagline'])[1]/@value)"/>
  <xsl:variable name="omni.copyright-year"
      select="normalize-space(($map//*[contains(@class, ' bookmap/copyrfirst ')])[1])"/>
  <xsl:variable name="omni.copyright-holder"
      select="normalize-space(($map//*[contains(@class, ' bookmap/bookowner ')])[1])"/>
  <xsl:variable name="omni.doc-title"
      select="normalize-space(string-join(($omni.title, $omni.subtitle), ' '))"/>

  <!-- ===================================================== Front cover -->
  <xsl:template name="createFrontCoverContents">
    <!-- Navy band across the top third of the page -->
    <fo:block-container absolute-position="fixed" top="0mm" left="0mm"
                        width="{$page-width}" height="108mm"
                        background-color="{$omni.navy}">
      <fo:block/>
    </fo:block-container>
    <!-- Accent stripe under the band -->
    <fo:block-container absolute-position="fixed" top="108mm" left="0mm"
                        width="{$page-width}" height="3mm"
                        background-color="{$omni.accent}">
      <fo:block/>
    </fo:block-container>

    <!-- Title block, reversed out of the band -->
    <fo:block-container absolute-position="fixed" top="42mm" left="{$page-margins}"
                        width="170mm" text-align="start">
      <fo:block font-family="sans-serif" font-size="10pt" font-weight="bold"
                letter-spacing="2pt" color="#9FD8D3" space-after="6pt">
        <xsl:value-of select="upper-case($omni.subtitle)"/>
      </fo:block>
      <fo:block font-family="sans-serif" font-size="36pt" font-weight="bold"
                letter-spacing="1pt" color="#FFFFFF" line-height="110%">
        <xsl:value-of select="$omni.title"/>
      </fo:block>
      <xsl:if test="$omni.tagline != ''">
        <fo:block font-family="sans-serif" font-size="13pt" color="#DCE6F2"
                  space-before="10pt" line-height="135%">
          <xsl:value-of select="$omni.tagline"/>
        </fo:block>
      </xsl:if>
    </fo:block-container>

    <!-- Edition details under the band -->
    <fo:block-container absolute-position="fixed" top="126mm" left="{$page-margins}" width="170mm" text-align="start">
      <fo:block font-family="sans-serif" font-size="11pt" font-weight="bold" color="{$omni.navy}">
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="'omni-cover-version'"/>
          <xsl:with-param name="params">
            <version><xsl:value-of select="$omni.version"/></version>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:if test="$omni.platform != ''">
          <xsl:text>  |  </xsl:text>
          <xsl:value-of select="$omni.platform"/>
        </xsl:if>
      </fo:block>
      <xsl:if test="$omni.revised castable as xs:date">
        <fo:block font-family="sans-serif" font-size="10pt" color="{$omni.muted}" space-before="4pt">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'omni-cover-revised'"/>
            <xsl:with-param name="params">
              <date><xsl:value-of select="format-date(xs:date($omni.revised), '[MNn] [D], [Y]')"/></date>
            </xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </xsl:if>
    </fo:block-container>

    <!-- Rights line at the foot of the cover -->
    <fo:block-container absolute-position="fixed" top="250mm" left="{$page-margins}" width="170mm" text-align="start">
      <fo:block font-family="sans-serif" font-size="8.5pt" color="{$omni.muted}"
                border-before-style="solid" border-before-width="0.5pt"
                border-before-color="{$omni.rule}" padding-before="6pt">
        <xsl:text>&#xA9; </xsl:text>
        <xsl:value-of select="string-join(($omni.copyright-year, $omni.copyright-holder), ' ')"/>
        <xsl:text>. Single-sourced in DITA XML and published with DITA Open Toolkit.</xsl:text>
      </fo:block>
    </fo:block-container>
    <fo:block/>
  </xsl:template>

  <!-- ============================================ Running header/footer -->
  <!-- Header: product name on the left, current chapter on the right -->
  <xsl:template name="omni.header">
    <fo:block xsl:use-attribute-sets="omni.header" text-align-last="justify">
      <fo:inline font-weight="bold" color="{$omni.navy}">
        <xsl:value-of select="$omni.product"/>
      </fo:inline>
      <fo:leader leader-pattern="space"/>
      <fo:retrieve-marker retrieve-class-name="current-header"/>
    </fo:block>
  </xsl:template>

  <!-- Footer: document title on the left, page number on the right -->
  <xsl:template name="omni.footer">
    <fo:block xsl:use-attribute-sets="omni.footer" text-align-last="justify">
      <xsl:value-of select="$omni.doc-title"/>
      <fo:leader leader-pattern="space"/>
      <xsl:call-template name="getVariable">
        <xsl:with-param name="id" select="'omni-footer-page'"/>
        <xsl:with-param name="params">
          <pagenum><fo:page-number/></pagenum>
        </xsl:with-param>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <xsl:template name="insertBodyOddHeader">
    <fo:static-content flow-name="odd-body-header"><xsl:call-template name="omni.header"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertBodyFirstHeader">
    <fo:static-content flow-name="first-body-header"><xsl:call-template name="omni.header"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertBodyLastHeader">
    <fo:static-content flow-name="last-body-header"><xsl:call-template name="omni.header"/></fo:static-content>
  </xsl:template>

  <xsl:template name="insertBodyOddFooter">
    <fo:static-content flow-name="odd-body-footer"><xsl:call-template name="omni.footer"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertBodyFirstFooter">
    <fo:static-content flow-name="first-body-footer"><xsl:call-template name="omni.footer"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertBodyLastFooter">
    <fo:static-content flow-name="last-body-footer"><xsl:call-template name="omni.footer"/></fo:static-content>
  </xsl:template>

  <!-- Preface and glossary pages get the same running header and footer -->
  <xsl:template name="insertPrefaceOddHeader">
    <fo:static-content flow-name="odd-body-header"><xsl:call-template name="omni.header"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertPrefaceFirstHeader">
    <fo:static-content flow-name="first-body-header"><xsl:call-template name="omni.header"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertPrefaceOddFooter">
    <fo:static-content flow-name="odd-body-footer"><xsl:call-template name="omni.footer"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertPrefaceFirstFooter">
    <fo:static-content flow-name="first-body-footer"><xsl:call-template name="omni.footer"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertGlossaryOddHeader">
    <fo:static-content flow-name="odd-glossary-header"><xsl:call-template name="omni.header"/></fo:static-content>
  </xsl:template>
  <xsl:template name="insertGlossaryOddFooter">
    <fo:static-content flow-name="odd-glossary-footer"><xsl:call-template name="omni.footer"/></fo:static-content>
  </xsl:template>

  <!-- Restart page numbering at 1 on the first chapter (the hook PDF2 ships
       commented out in commons.xsl), so the preface keeps roman numerals and
       the body starts at page 1. -->
  <xsl:template name="startPageNumbering" as="attribute()*">
    <xsl:variable name="id" select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id"/>
    <xsl:variable name="mapTopic" select="key('map-id', $id)"/>
    <xsl:if test="not(($mapTopic/preceding::*[contains(@class, ' bookmap/chapter ') or contains(@class, ' bookmap/part ')])
                  or ($mapTopic/ancestor::*[contains(@class, ' bookmap/chapter ') or contains(@class, ' bookmap/part ')]))">
      <xsl:attribute name="initial-page-number">1</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- Contents pages: same footer, no chapter marker in the header -->
  <xsl:template name="insertTocOddHeader">
    <fo:static-content flow-name="odd-toc-header">
      <fo:block xsl:use-attribute-sets="omni.header">
        <fo:inline font-weight="bold" color="{$omni.navy}"><xsl:value-of select="$omni.product"/></fo:inline>
      </fo:block>
    </fo:static-content>
  </xsl:template>
  <xsl:template name="insertTocOddFooter">
    <fo:static-content flow-name="odd-toc-footer"><xsl:call-template name="omni.footer"/></fo:static-content>
  </xsl:template>

</xsl:stylesheet>
