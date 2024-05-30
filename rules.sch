<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:dita-xt="http://dita-ot.sourceforge.net/ns/201007/dita-xt"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns uri="http://www.oxygenxml.com/ai/function" prefix="ai"/>
    <!-- Rule 1: shortdes 简洁 -->    
    <sch:pattern>
        <sch:rule context="shortdesc">
            <sch:report test="string-length(.) > 55" role="warn" sqf:fix="rephrase">简短描述必须简洁。</sch:report>
            <sqf:fix id="rephrase">
                <sqf:description>
                    <sqf:title>缩短描述</sqf:title>
                </sqf:description>
                <sqf:replace match="text()"
                    select="ai:transform-content('措辞修订为一个少于 40 个字的短语。', .)"/>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    <!-- Rule 2: image 补充文本 -->   
    <sch:pattern>
        <sch:rule context="image[@href]">
            <sch:report test="not(alt)" role="warn" sqf:fix="image-alt">图像没有补充文本。</sch:report>
            <sqf:fix id="image-alt">
                <sqf:description>
                    <sqf:title>增加补充文本</sqf:title>
                </sqf:description>
                <sqf:add match="." position="last-child">
                    <alt>
                        <xsl:value-of select="ai:transform-content('为这张图像创建一个简短的补充文本描述:', concat('${attach(', resolve-uri(@href), ')}'))"/>
                    </alt>
                </sqf:add>
            </sqf:fix>
        </sch:rule>

  
        <sch:rule context="image[@keyref]">
            <sch:report test="not(alt)" role="war" sqf:fix="image-alt-keyref">图像没有补充文本.<sch:value-of select="ditaaccess:getKeyRefAbsoluteReference(@keyref, base-uri())"/> </sch:report>
            <sqf:fix id="image-alt-keyref">
                <sqf:description>
                    <sqf:title>Add alternate text</sqf:title>
                </sqf:description>
                <sqf:add match="." position="last-child">
                    <alt>
                        <xsl:value-of select="
                            ai:transform-content(
                            '为这张图像创建一个简短的补充文本描述:',
                            concat('${attach(', ditaaccess:getKeyRefAbsoluteReference(@keyref, base-uri()), ')}'))"/>
                    </alt>
                </sqf:add>
            </sqf:fix>
        </sch:rule>

    </sch:pattern>
    <!-- Rule 3: 标点符号 should not start with punctuation -->
    <sch:pattern>
        <sch:rule context="pre/text()">
            <sch:let name="firstChar" value="substring(normalize-space(.), 1, 1)"/>
            <sch:let name="isPunctuation" value="contains('，。、；！？：&quot;&quot;）', $firstChar)"/>
            <sch:report test="$isPunctuation">
                一行文字不应以句号、问号、叹号、逗号、顿号、分号、冒号、开始引号、结束引号等标点开始。
            </sch:report>
        </sch:rule>
    </sch:pattern>   
    <!-- Rule 4:结尾标点符号 Line should not end with certain punctuation -->
    <sch:pattern id="check-punctuation-at-end-of-line-in-pre">
        <sch:rule context="pre">
            <sch:assert test="not(matches(., '.*[&quot;（【]\\n'))">
                文档在任何一行的结尾都不得包含不允许的标点符号（如"、(、[等）。
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- Rule 5:省略号 Ellipsis should be ... or ...... -->
    <!--sch:pattern>
        <sch:rule context="title/text() | context/text()">
            <sch:assert test="not(matches(., '[^…\.]{3}'))">
                省略号需为……或......（六个点）。
            </sch:assert>
        </sch:rule>
    </sch:pattern-->
    <!-- Rule 6: 半角中文标点符号 halfwidth Chinese punctuation -->
    <sch:pattern id="check-fullwidth-punctuation-in-pre">
        <sch:rule context="pre">
            <sch:assert test="not(matches(., '[，。！？；：&quot;&quot;''（）《》【】『』｛｝､｡ｖｗｅｒｑｐｙｕｉｏａｓｄｆｇｈｊｋｌｚｘｃｖｂｎｍ１２３４５６７８９０＊＋－／＝％＆＃＄＠]'))">
                中文语境下的'pre'元素的内容必须使用全角标点符号，不得使用半角标点符号。
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- rule 7: 标点符号的空格：全角中文标点符号前后不应该有半角空 -->
    <sch:pattern>
        <sch:rule context="text()">
            <sch:let name="incorrectSpacing" value="matches(., '([^\s])\s+([，。、；！？])|([，。、；！？])\s+([^\s])') "/>
            <sch:let name="correctSpacing" value="replace(., '([^\s])\s+([，。、；！？])|([，。、；！？])\s+([^\s])', '$1$2$3')"/>
            <sch:report test="$incorrectSpacing">
                全角中文标点符号前后不应该有半角空格。请将间距更正为：<sch:value-of select="$correctSpacing"/>.
            </sch:report>
        </sch:rule>
    </sch:pattern>
    <!-- Rule 8: NOTE 元素不可以内置表格图像 -->
    <sch:pattern>
        <sch:rule context="note">
            <sch:assert test="not(table) and not(graphic) and not(preceding-sibling::table and following-sibling::table)">
                注意和说明中不能包含表格和图形，并且前后不能包含表格。
            </sch:assert>
        </sch:rule>
    </sch:pattern> 
    <!-- Rule 9: note 长度控制 the number of 4 lines in note elements -->
    <sch:pattern>
        <sch:rule context="note">
            <sch:assert test="count(text()) &lt;= 4">
                注意和说明的内容不能过长，建议不要超过 4 行。
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- Rule 10: 单元格左侧对齐 cells must have left-aligned content -->
    <sch:pattern>
        <sch:rule context="table/tbody/tr/td|table/tbody/tr/th">
            <sch:assert test="normalize-space(.) = normalize-space(replace(normalize-space(.), '[\t\r\n]+', ''))">
                单元格中的所有内容都建议保持左对齐。
            </sch:assert>
        </sch:rule>
    </sch:pattern>   
    <!-- Rule 11: 表格行不要跨页  -->
    <sch:pattern>
        <sch:rule context="tbody/*">
            <sch:assert test="string-length(normalize-space()) &gt;= 1 and string-length(normalize-space()) &lt;= 60">
                在 DITA 文件中，每个表格行所占用的最大字符串长度为 60 字符，以确保输出格式正确。
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- Rule 12: Note element cannot contain tables and graphics -->
    <sch:pattern>  <sch:rule context="note">
        <sch:assert test="not(table) and not(graphic)">      注意和说明中不能包含表格和图形。    </sch:assert> 
    </sch:rule>
    </sch:pattern>
    <!-- Rule 13: All tables need a header row describing column contents -->
    <sch:pattern id="table-header-row">
        <sch:rule context="*[contains(@class, ' topic/table ')]">
            <sch:assert test="*[contains(@class, ' topic/tgroup ')]/*[contains(@class, ' topic/thead ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ') and normalize-space()]" role="warning">All tables need a header row describing column contents.</sch:assert>
            <sch:report test="not(*[contains(@class, ' topic/tgroup ')]/*[contains(@class, ' topic/thead ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ') and normalize-space()])">
                <fix-set id="add-header-row" name="Add header row to table">
                    <qfix:insert-as-first-child node-step="*[contains(@class, ' topic/tgroup ')]" use-accumulators="false" xmlns:qfix="http://www.schematron-quickfix.com/validator/process">
                        <thead class="- topic/thead ">
                            <row class="- topic/row ">
                                <xsl:for-each select="*[contains(@class, ' topic/colspec ')]">
                                    <entry class="- topic/entry ">
                                        <xsl:choose>
                                            <xsl:when test="@colname">
                                                <xsl:value-of select="@colname"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('Column ', position())"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </entry>
                                </xsl:for-each>
                            </row>
                        </thead>
                    </qfix:insert-as-first-child>
                </fix-set>
            </sch:report>
        </sch:rule>
    </sch:pattern>
    <!-- RULE 14 非 non-ASCII 字符处理 -->
    <sch:pattern id="no-nonascii-chars-in-text">
        <sch:rule context="/">
            <sch:assert test="@*[contains(translate(substring-after(string(), ' '), '', ''), '')]" />
        </sch:rule>
    </sch:pattern>    
    <sch:pattern id="check-halfwidth-punctuation">  
        <sch:rule context="task//text()">  
            <!-- 列出一些常见的全角中文标点符号（用于排除） -->  
            <sch:assert test="not(matches(., '[，。！？；：“”‘’（）《》【】『』｛｝､｡＄％＃＆＊＋－／＝～＿＾｜￥]'))">  
                文本中不得包含全角中文标点符号。  
            </sch:assert>              
        </sch:rule>  
    </sch:pattern>
</sch:schema>
