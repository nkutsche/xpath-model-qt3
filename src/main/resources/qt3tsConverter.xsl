<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:qt="http://www.w3.org/2010/09/qt-fots-catalog"
    xmlns:x="http://www.jenitennison.com/xslt/xspec"
    xmlns:nk="http://www.nkutsche.com/xpath-model"
    exclude-result-prefixes="xs"
    version="3.0"
    xpath-default-namespace="http://www.w3.org/2010/09/qt-fots-catalog"
    >
    <xsl:import href="dependency:/com.nkutsche+xpath-model/xsl/xpath-model.xsl"/>
    
    <xsl:param name="result-dir" select="resolve-uri('../testsuite-conv/', base-uri(.))"/>
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="/catalog">
        <xsl:variable name="fname" select="tokenize(base-uri(.), '/')[last()]"/>
        
            <xsl:next-match>
                <xsl:with-param name="result-dir" select="$result-dir" tunnel="yes"/>
            </xsl:next-match>
        
    </xsl:template>
    
    <xsl:template match="test-set[@file]">
        <xsl:param name="result-dir" select="$result-dir" tunnel="yes"/>
        <xsl:variable name="doc" select="doc(resolve-uri(@file, base-uri(.)))"/>
        
        <xsl:next-match/>
        
        <xsl:result-document href="{resolve-uri(@file, $result-dir)}">
            <xsl:apply-templates select="$doc"/>
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template match="test-case[not(qt:spec(.) = ('XQ10+', 'XQ30+', 'XQ31', 'XQ31+', 'XQ10', 'XQ30'))]/test">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:variable name="parsed" select="nk:xpath-model(.)"/>
            <xsl:variable name="expected-error-code" select="../result/(.|any-of)/error/@code"/>
            
            <xsl:choose>
                <xsl:when test="$parsed/self::*:expr">
                    <xsl:sequence select="$parsed => nk:xpath-serializer()"/>
                </xsl:when>
                <xsl:when test="$expected-error-code[starts-with(., 'XPST')]">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message select="'[' || ../@name || ':' || string-join($expected-error-code, '|') || '] Could not parse expression: ' || ." terminate="yes"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="qt:spec" as="xs:string*">
        <xsl:param name="test-case" as="element(qt:test-case)"/>
        <xsl:sequence select="
            $test-case/(qt:dependency[@type = 'spec'], ../qt:dependency[@type = 'spec'])[1]/@value/tokenize(., '\s')
            "/>
    </xsl:function>
    
</xsl:stylesheet>