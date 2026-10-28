<?xml version="1.0" encoding="UTF-8"?>
<!--
  Attribute-set and page-geometry overrides for the omni-pdf transtype.
  Every color comes from the palette variables below, so a rebrand is a
  six-line change.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

  <!-- Palette -->
  <xsl:variable name="omni.ink">#1B2333</xsl:variable>
  <xsl:variable name="omni.navy">#12284C</xsl:variable>
  <xsl:variable name="omni.accent">#0B7A75</xsl:variable>
  <xsl:variable name="omni.muted">#5B6475</xsl:variable>
  <xsl:variable name="omni.rule">#CDD4DF</xsl:variable>
  <xsl:variable name="omni.tint">#EDF5F4</xsl:variable>

  <!-- Page geometry: US Letter, single-sided, no hanging title column -->
  <xsl:variable name="page-width">215.9mm</xsl:variable>
  <xsl:variable name="page-height">279.4mm</xsl:variable>
  <xsl:variable name="page-margins">19mm</xsl:variable>
  <xsl:variable name="page-margin-top">24mm</xsl:variable>
  <xsl:variable name="page-margin-bottom">22mm</xsl:variable>
  <xsl:variable name="mirror-page-margins" select="false()"/>
  <xsl:variable name="side-col-width">0pt</xsl:variable>
  <xsl:variable name="default-font-size">10pt</xsl:variable>
  <xsl:variable name="default-line-height">14pt</xsl:variable>

  <!-- Screen PDF, not a printed book: never pad a sequence with blank pages.
       ("auto" still pads when the next sequence restarts at page 1.) -->
  <xsl:attribute-set name="__force__page__count">
    <xsl:attribute name="force-page-count">no-force</xsl:attribute>
  </xsl:attribute-set>

  <!-- Chapter opener: navy label and number, accent rules -->
  <xsl:attribute-set name="__chapter__frontmatter__name__container">
    <xsl:attribute name="font-size">13pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="letter-spacing">1.5pt</xsl:attribute>
    <xsl:attribute name="color" select="$omni.accent"/>
    <xsl:attribute name="padding-top">0pt</xsl:attribute>
    <xsl:attribute name="space-after">4pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="__chapter__frontmatter__number__container">
    <xsl:attribute name="font-size">40pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color" select="$omni.navy"/>
  </xsl:attribute-set>

  <!-- App messages in the body font, not monospace -->
  <xsl:attribute-set name="msgph">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="color">#3A4A63</xsl:attribute>
  </xsl:attribute-set>

  <!-- Body text: sans-serif in ink instead of the stock serif in black -->
  <xsl:attribute-set name="__fo__root" use-attribute-sets="base-font">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="color" select="$omni.ink"/>
    <xsl:attribute name="xml:lang" select="translate($locale, '_', '-')"/>
    <xsl:attribute name="writing-mode" select="$writing-mode"/>
  </xsl:attribute-set>

  <!-- Headings -->
  <xsl:attribute-set name="topic.title" use-attribute-sets="common.title">
    <xsl:attribute name="color" select="$omni.navy"/>
    <xsl:attribute name="font-size">20pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-before">0pt</xsl:attribute>
    <xsl:attribute name="space-after">14pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">6pt</xsl:attribute>
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">2pt</xsl:attribute>
    <xsl:attribute name="border-after-color" select="$omni.accent"/>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topic.topic.title" use-attribute-sets="common.title">
    <xsl:attribute name="color" select="$omni.navy"/>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-before">16pt</xsl:attribute>
    <xsl:attribute name="space-after">6pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-after-color" select="$omni.rule"/>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="topic.topic.topic.title" use-attribute-sets="common.title">
    <xsl:attribute name="color" select="$omni.accent"/>
    <xsl:attribute name="font-size">11.5pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-before">12pt</xsl:attribute>
    <xsl:attribute name="space-after">3pt</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="section.title" use-attribute-sets="common.title">
    <xsl:attribute name="color" select="$omni.accent"/>
    <xsl:attribute name="font-size">10.5pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-before">12pt</xsl:attribute>
    <xsl:attribute name="space-after">3pt</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="__toc__header" use-attribute-sets="common.title">
    <xsl:attribute name="color" select="$omni.navy"/>
    <xsl:attribute name="font-size">20pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-after">14pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">6pt</xsl:attribute>
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">2pt</xsl:attribute>
    <xsl:attribute name="border-after-color" select="$omni.accent"/>
  </xsl:attribute-set>

  <xsl:attribute-set name="__toc__chapter__content" use-attribute-sets="__toc__topic__content">
    <xsl:attribute name="color" select="$omni.navy"/>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="padding-top">12pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Notes: tinted panel with an accent rule instead of a bare bold label -->
  <xsl:attribute-set name="note" use-attribute-sets="common.block">
    <xsl:attribute name="background-color" select="$omni.tint"/>
    <xsl:attribute name="border-start-style">solid</xsl:attribute>
    <xsl:attribute name="border-start-width">3pt</xsl:attribute>
    <xsl:attribute name="border-start-color" select="$omni.accent"/>
    <xsl:attribute name="padding">6pt 8pt 6pt 8pt</xsl:attribute>
    <xsl:attribute name="start-indent">inherit</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="note__label">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color" select="$omni.accent"/>
  </xsl:attribute-set>

  <!-- UI labels read as interface text -->
  <xsl:attribute-set name="uicontrol">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="color" select="$omni.navy"/>
  </xsl:attribute-set>

  <!-- Tables: navy header row, hairline rules -->
  <xsl:attribute-set name="thead.row.entry">
    <xsl:attribute name="background-color" select="$omni.navy"/>
    <xsl:attribute name="color">#FFFFFF</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="common.border__top">
    <xsl:attribute name="border-before-style">solid</xsl:attribute>
    <xsl:attribute name="border-before-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-before-color" select="$omni.rule"/>
  </xsl:attribute-set>
  <xsl:attribute-set name="common.border__bottom">
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-after-color" select="$omni.rule"/>
  </xsl:attribute-set>
  <xsl:attribute-set name="common.border__left">
    <xsl:attribute name="border-start-style">solid</xsl:attribute>
    <xsl:attribute name="border-start-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-start-color" select="$omni.rule"/>
  </xsl:attribute-set>
  <xsl:attribute-set name="common.border__right">
    <xsl:attribute name="border-end-style">solid</xsl:attribute>
    <xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-end-color" select="$omni.rule"/>
  </xsl:attribute-set>

  <xsl:attribute-set name="fig.title" use-attribute-sets="base-font common.title">
    <xsl:attribute name="color" select="$omni.muted"/>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
    <xsl:attribute name="space-before">4pt</xsl:attribute>
    <xsl:attribute name="space-after">10pt</xsl:attribute>
    <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="table.title" use-attribute-sets="base-font common.title">
    <xsl:attribute name="color" select="$omni.navy"/>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-before">10pt</xsl:attribute>
    <xsl:attribute name="space-after">6pt</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
  </xsl:attribute-set>

  <!-- Running header and footer text, used by the templates in fo/xsl/custom.xsl -->
  <xsl:attribute-set name="omni.header">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">8.5pt</xsl:attribute>
    <xsl:attribute name="color" select="$omni.muted"/>
    <xsl:attribute name="start-indent" select="$page-margins"/>
    <xsl:attribute name="end-indent" select="$page-margins"/>
    <xsl:attribute name="space-before">11mm</xsl:attribute>
    <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
    <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
    <xsl:attribute name="border-after-style">solid</xsl:attribute>
    <xsl:attribute name="border-after-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-after-color" select="$omni.rule"/>
  </xsl:attribute-set>

  <xsl:attribute-set name="omni.footer">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">8.5pt</xsl:attribute>
    <xsl:attribute name="color" select="$omni.muted"/>
    <xsl:attribute name="start-indent" select="$page-margins"/>
    <xsl:attribute name="end-indent" select="$page-margins"/>
    <xsl:attribute name="space-after">10mm</xsl:attribute>
    <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
