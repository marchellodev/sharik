<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wix="http://schemas.microsoft.com/wix/2006/wi">

  <!-- Copy all attributes and elements to the output. -->
  <xsl:output method="xml" indent="yes" />
  <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="*" />
    </xsl:copy>
  </xsl:template>

  <xsl:key name="file-search" match="" use="@Id" />
  <xsl:template match="wix:Component[key('file-search', @Id)]" />
  <xsl:template match="wix:ComponentRef[key('file-search', @Id)]" />
</xsl:stylesheet>