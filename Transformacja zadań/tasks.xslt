<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns="http://www.mini.pw.edu.pl/projob"
    xmlns:t1="http://www.mini.pw.edu.pl/projob/teacher1"
    xmlns:t2="http://www.mini.pw.edu.pl/projob/teacher2"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:key name="student" match="//t1:Student | //t2:Student" use="@id" />
  <xsl:key name="task" match="*[starts-with(name(), 'Task')]" use="name()" />

  <xsl:template match="//*[local-name() = 'Student']">
    <xsl:if test="generate-id() = generate-id(key('student', @id))">
      <Student>
        <xsl:attribute name="id">
          <xsl:value-of select="@id" />
        </xsl:attribute>
        <Name>
          <xsl:value-of select="./*[local-name() = 'Name']"/>
        </Name>
        <Surname>
          <xsl:value-of select="./*[local-name() = 'Surname']" />
        </Surname>
      </Student>
    </xsl:if>
  </xsl:template>

  <xsl:template match="//*[starts-with(name(), 'Task')]">
    <xsl:if test="generate-id() = generate-id(key('task', name()))">
      <Task>
        <xsl:attribute name="id">
          <xsl:value-of select="name()" />
        </xsl:attribute>
        <xsl:attribute name="description">
          <xsl:value-of select="@description"/>
        </xsl:attribute>
        <xsl:attribute name="maxPoints">
          <xsl:value-of select="@maxPoints"/>
        </xsl:attribute>
      </Task>
    </xsl:if>
  </xsl:template>

  <xsl:template match="//t1:Result" >
    <Result>
      <xsl:attribute name="studentId">
        <xsl:value-of select="t1:Student/@id"/>
      </xsl:attribute>
      <xsl:attribute name="taskId">
        <xsl:value-of select="name(..)"/>
      </xsl:attribute>
      <xsl:attribute name="points">
        <xsl:value-of select="t1:Points"/>
      </xsl:attribute>
    </Result>
  </xsl:template>

  
  <xsl:template match="//t2:*[starts-with(name(), 'Task')]">
    <Result>
      <xsl:attribute name="studentId">
        <xsl:value-of select="../../@id"/>
      </xsl:attribute>
      <xsl:attribute name="taskId">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:attribute name="points">
        <xsl:value-of select="current()"/>
      </xsl:attribute>
    </Result>
  </xsl:template>

  <xsl:template match="/">
    <Results>
      <Students>
        <xsl:apply-templates select="//*[local-name() = 'Student']" />
      </Students>

      <Tasks>
        <xsl:apply-templates select="//*[starts-with(name(), 'Task')]" />
      </Tasks>

      <ReceivedResults>
        <xsl:apply-templates select="//t1:Result" />
        <xsl:apply-templates select="//t2:*[starts-with(name(), 'Task')]" />
      </ReceivedResults>
    </Results>
  </xsl:template>
</xsl:stylesheet>
