<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="ISO-8859-1"/>
<xsl:template match="/">
  <html>
    <head>
      <meta http-equiv="content-type" content="text/html; charset=iso-8859-1"></meta>

<!-- doesn't work with Firefox     <link rel="stylesheet" type="text/css" href="../webserv/cplcfg/formate.css"></link> -->

      <style type="text/css">
        a:link,a:visited{color:#000;background-color:#FFF;}
        a:active{color:#000;background-color:#3e7abe;}
        a:hover{color:#FFF;background-color:#3e7abe;display:block;}
        body{color:#000;background-color:#FFF;font-family:arial, sans-serif;font-size:12pt;}
        .conform{margin-top:2%;margin-left:20%;margin-right:20%;}
        .headline{font-size:150%;font-weight:700;position:static;border-top:#90b630 solid medium;border-right:#90b630 solid medium;border-left:#90b630 solid medium;border-bottom:#90b630 solid thin;text-align:center;color:#FFF;background-color:#90b630;padding-top:5px;padding-bottom:5px;margin:2% 20% 0;}
        .cfgtable{border:0;margin-left:auto;margin-right:auto;border-left:#90b630 solid 2px;border-right:#90b630 solid 2px;border-bottom:#90b630 solid 2px;border-top:#90b630 solid 2px;border-collapse:collapse;}
        .cfgtable td{border-bottom:#90b630 solid thin;vertical-align:baseline;padding-left:5px;padding-right:5px;text-align:left;}
        .description{margin-left:20%;margin-right:20%;margin-top:0;border-left:#90b630 solid medium;border-right:#90b630 solid medium;border-bottom:#90b630 solid medium;text-align:justify;padding:20px 10px 10px;}
        .cfgtable tr{text-align:center;}
        .cfgtable th{font-weight:700;border:#90b630 solid medium;padding:10px;}
        input{margin-left:5px;margin-right:5px;}
        .cfgtable caption{margin-left:auto;margin-right:auto;font-size:150%;caption-side:top;background-color:#90b630;color:#FFF;margin-top:5%;padding-top:5px;padding-bottom:5px;vertical-align:baseline;}
        p.warning{margin-left:30%;margin-right:30%;margin-top:5%;border:red solid thick;text-align:justify;padding:10px;}
        input.warning{background:red; color:black; padding:5px;}
        h1{font-size:150%;color:#FFF;background-color:#3e7abe;text-align:center;margin:0;padding:0;}
        ul{list-style:none;border:#3e7abe solid medium;margin:0;padding:0;}
        li a{background-image:url(images/listmarker.gif);background-repeat:no-repeat;background-position:center left;border-bottom:#3e7abe solid thin;padding-left:25px;line-height:150%;display:block;font-weight:700;text-decoration:none;}
        li a:hover{background-color:#3e7abe; color:#FFF; background-image:url(images/listmarkerwh.gif);background-repeat:no-repeat;background-position:center left;display:block;}
        li a:active,a:focus{background-color:#3e7abe; color:#000; background-image:url(images/listmarkerwh.gif);background-repeat:no-repeat;background-position:center left;display:block;}
        li a:visited{text-decoration:none;}
        .navbox{margin-top:20%;width:100%;}
      </style>

      <title>EA-config file</title>
    </head>
    <body>
      <div align="center">
        <table class="cfgtable" style="width:90%;">
          <caption> I/O configuration file </caption>
          <colgroup>
            <col width="5%"></col>
            <col width="40%"></col>
            <col width="20%"></col>
            <col width="35%"></col>
          </colgroup>
          <tr>
            <th> Pos </th>
            <th> Module </th>
            <th> Type </th>
            <th> Mapping </th>
          </tr>
          <xsl:apply-templates />
        </table>
      </div>
    </body>
  </html>
</xsl:template>

<xsl:template match="WAGO">
  <xsl:for-each select="Module">
    <tr>
      <td style="text-align:center;"> <xsl:value-of select="position()" /> </td>
      <td> <xsl:value-of select="@ARTIKELNR" /> </td>
      <td style="text-align:center;"> <xsl:value-of select="@CHANNELCOUNT" /> <xsl:value-of select="@MODULETYPE" /> </td>
      <td style="text-align:center;">
        <xsl:choose>
          <xsl:when test="@MAP='FB1'">
            Fieldbus 1
          </xsl:when>
          <xsl:when test="@MAP='FB2'">
            Fieldbus 2
          </xsl:when>
          <xsl:when test="@MAP='FB3'">
            Fieldbus 3
          </xsl:when>
          <xsl:when test="@MAP='FB4'">
            Fieldbus 4
          </xsl:when>
          <xsl:when test="@MAP='FB5'">
            Fieldbus 5
          </xsl:when>
          <xsl:when test="@MAP='FB6'">
            Fieldbus 6
          </xsl:when>
          <xsl:when test="@MAP='PLC'">
            PLC
          </xsl:when>
          <xsl:otherwise>
            Fieldbus 1
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
    <xsl:apply-templates select="Kanal"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="Kanal">
  <tr>
    <td colspan = "4">
      <table style="width:100%;">
        <colgroup>
          <col width="10%"></col>
          <col width="25%"></col>
          <col width="60%"></col>
          <col width="5%"></col>
        </colgroup>
        <tr>
          <td style="border:none;"></td>
          <td style="text-align:left; border:none;"><xsl:value-of select="@CHANNELNAME" /></td>
          <td style="text-align:right; border:none;"><xsl:value-of select="." /></td>
          <td style="border:none;"></td>
        </tr>
      </table>
    </td>
  </tr>
</xsl:template>
</xsl:stylesheet>