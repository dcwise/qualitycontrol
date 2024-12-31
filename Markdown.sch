<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  
  <sch:pattern id="avoidPercent" is-a="avoidWordInContext">
    <sch:param name="context" value="*" />
    <sch:param name="word" value="percent" />
    <sch:param name="message" value="应使用 '%' 符号，而不是拼写 'percent'。" />
  </sch:pattern>
  
  <sch:pattern id="avoidSemicolonAtEndOfListItem" is-a="avoidEndFragment">
    <sch:param name="element" value="li" />
    <sch:param name="fragment" value=";" />
    <sch:param name="message" value="列表项不应以分号结尾。" />
  </sch:pattern>
  
  <sch:pattern id="listsShouldNotContainOnly1Item" is-a="restrictNumberOfChildren">
    <sch:param name="parentElement" value="ol|ul" />
    <sch:param name="element" value="li" />
    <sch:param name="min" value="2" />
    <sch:param name="max" value="9999999" />
    <sch:param name="message" value="列表应至少包含 2 个项目。" />
  </sch:pattern>
  
  <sch:pattern id="avoidBoldInHeaders" is-a="restrictChildrenElements">
    <sch:param name="parentElement" value="h1|h2|h3|h4|h5|h6" />
    <sch:param name="disallowedChildren" value="strong" />
    <sch:param name="message" value="标题中不应包含粗体内容。" />
  </sch:pattern>
  
  <sch:pattern id="curencySymbolShouldStayBeforeNumber" is-a="avoidRegExpPattern">
    <sch:param name="context" value="*" />
    <sch:param name="regexp" value="\d[¢$Ξ€£₾¥]" />
    <sch:param name="flags" value="i" />
    <sch:param name="message" value="货币符号应放在数字之前，而不是之后。" />
  </sch:pattern>
 
  <sch:pattern id="noSpaceBeforePunctuation" is-a="avoidRegExpPattern">
    <sch:param name="context" value="*" />
    <sch:param name="regexp" value=" [，；。：！？]" />
    <sch:param name="flags" value="i" />
    <sch:param name="message" value="中文标点符号前不应有空格。" />
  </sch:pattern>
  
  <!-- 模式定义 -->
  <sch:pattern id="avoidWordInContext" abstract="true">
    <sch:title>如果指定元素中出现某个词或短语，则发出警告</sch:title>
    <sch:p>此模式允许您建议用户不要在元素中使用特定词语，或在多个元素中使用（用 '|' 分隔）。检查不区分大小写。</sch:p>
    
    <parameters xmlns="http://oxygenxml.com/ns/schematron/params">
      <parameter>
        <name>context</name>
        <desc>指定我们将验证不包含指定词语的上下文。可以用管道字符分隔多个元素，例如 title|p 将检查 title 和 p 元素。</desc>
      </parameter>
      <parameter>
        <name>word</name>
        <desc>指定我们要查找的词或短语。</desc>
      </parameter>
      <parameter>
        <name>message</name>
        <desc>当指定词语出现在指定元素中时，用户将看到的消息。</desc>
      </parameter>
    </parameters>
    
    <sch:rule context="$context">
      <sch:report test="./text()[matches(., '(^|\s)$word([\s,;.:!?]|$)', 'i')]" role="warn" >
        $message
      </sch:report>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="avoidEndFragment" abstract="true">
    <sch:title>如果元素以指定片段或字符结尾，则发出警告</sch:title>
    <sch:p>此模式允许您建议用户不要使用特定的结束序列来结束元素。</sch:p>
    
    <parameters xmlns="http://oxygenxml.com/ns/schematron/params">
      <parameter>
        <name>element</name>
        <desc>指定我们将验证不包含指定词语的元素。</desc>
      </parameter>
      <parameter>
        <name>fragment</name>
        <desc>指定要检查的文本。</desc>
      </parameter>
      <parameter>
        <name>message</name>
        <desc>当指定文本以给定片段结尾时，用户将看到的消息。</desc>
      </parameter>
    </parameters> 
    <sch:rule context="$element">
      <sch:assert test="not(ends-with(normalize-space(.), '$fragment'))" role="warn">
        $message
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="restrictNumberOfChildren" abstract="true">
    <sch:title>限制父元素中子元素的数量</sch:title>
    <sch:p>检查父元素中子元素的数量是否在指定限制之间。</sch:p>
    
    <parameters xmlns="http://oxygenxml.com/ns/schematron/params">
      <parameter>
        <name>parentElement</name>
        <desc>指定我们应该检查嵌套的元素。</desc>
      </parameter>
      <parameter>
        <name>element</name>
        <desc>指定我们将查找的子元素。</desc>
      </parameter>
      <parameter>
        <name>min</name>
        <desc>允许的最小出现次数。</desc>
      </parameter>
      <parameter>
        <name>max</name>
        <desc>允许的最大出现次数。</desc>
      </parameter>
      <parameter>
        <name>message</name>
        <desc>如果子元素的数量不在指定限制内，我们应该向用户显示的消息。</desc>
      </parameter>
    </parameters>
    <sch:rule context="$parentElement">
      <sch:let name="children" value="count($element)"/>
      <sch:assert test="$children &lt;= $max" role="warn">
        $message 
      </sch:assert>
      <sch:assert test="$children &gt;= $min" role="warn"> 
        $message
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="restrictChildrenElements" abstract="true">
    <sch:title>限制可以出现在父元素中的子元素</sch:title>
    <sch:p>您可以使用此功能指定在其他元素中禁止的元素列表。</sch:p>
    
    <parameters xmlns="http://oxygenxml.com/ns/schematron/params">
      <parameter>
        <name>parentElement</name>
        <desc>指定父元素。</desc>
      </parameter>
      <parameter>
        <name>disallowedChildren</name>
        <desc>指定以逗号分隔的元素本地名称列表。</desc>
      </parameter>
      <parameter>
        <name>message</name>
        <desc>如果匹配的元素包含不在允许元素列表中的子元素，我们应该向用户显示的附加消息。</desc>
      </parameter>
    </parameters>
    <sch:rule context="$parentElement/*">
      <sch:let name="elements" 
        value="tokenize(translate(normalize-space('$disallowedChildren'), ' ', ''), ',')"/>
      <sch:report test="child::*/local-name() = $elements" role="warn">
        $message
      </sch:report>
    </sch:rule>
  </sch:pattern>
  
  <sch:pattern id="avoidRegExpPattern" abstract="true">
    <sch:title>定义一个正则表达式以查找不需要的模式。</sch:title>
    
    <parameters xmlns="http://oxygenxml.com/ns/schematron/params">
      <parameter>
        <name>context</name>
        <desc>此规则将激活的 Schematron 上下文。</desc>
      </parameter>
      <parameter>
        <name>regexp</name>
        <desc>用于在上下文中匹配不需要的模式的正则表达式。</desc>
      </parameter>
      <parameter>
        <name>flags</name>
        <desc>正则表达式标志。</desc>
      </parameter>
      <parameter>
        <name>message</name>
        <desc>当正则表达式匹配时显示给用户的消息。</desc>
      </parameter>
    </parameters> 
    
    <sch:rule context="$context">
      <sch:report test="./text()[matches(., '$regexp', '$flags')]" role="warn">
        $message
      </sch:report>
    </sch:rule>
  </sch:pattern>
  
</sch:schema>