# Markdown 规则检测

提交了 Schematron 文件 Markdown.sch，其应用效果如图：

![image](https://github.com/user-attachments/assets/b4ec6aef-d1c9-4c28-bb03-e1c0d3dec4da)




因为 AIGC 很自然被普遍感到适合文档开发使用。为此，北京镭试图探索并证明了在文档开发的质量控制阶段的应用。
此 Schematron 规则集包含了一些常见的 DITA XML 文档编写约束规则,总共包含14条规则。下面逐条进行解释:

1. 简短描述(shortdesc)长度不应超过55个字符,否则会给出警告。如果超长,可以运行快速修复(Quick Fix)功能自动缩短为40个字符。



2. 对于有 href 属性的图像(image),如果缺少 alt 属性(补充文本描述),则会给出警告,并提供快速修复选项自动为图像添加补充文本。



3. pre 元素内的文本不应以句号、问号、叹号、逗号、顿号、分号、冒号、引号等标点开头。



4. 任意一行的行尾不应包含引号、括号等不允许的标点符号。 



5. 省略号应使用……或……… (6个点)的标准形式。(该规则被注释掉未生效)



6. 在中文语境下的 pre 元素中,必须使用全角标点符号,不得使用半角标点符号。



7. 全角中文标点符号前后不应有半角空格。如果存在,会提供修正建议。



8. note 元素中不能包含表格(table)和图形(graphic),前后也不能紧挨表格。



9. note 元素中的内容不应超过4行文字。



10. 表格单元格中的内容应保持左对齐。



11. 每个表格行所占用的最大字符串长度为60字符,以确保输出格式正确。




12. 所有表格都需要有描述列内容的表头行。如果缺少,可以运行快速修复自动为表格添加表头行。



总的来说,这些规则旨在为DITA文档的编写提供一系列约束和最佳实践建议,以提高文档质量。

免责: 使用者自己负责必要的调整或者优化。北京镭内容公司对此不承担任何风险或者责任。且如果使用，需要援引来自本公司-北京镭内容信息科技有限公司。

<div class="highlight highlight-source-shell">
<pre>
<span class="pl-c"># Load vfio-pci module</span>
sudo modprobe vfio-pci

<span class="pl-c"># Unbind device from current driver</span>
<span class="pl-c1">echo</span> 0000:3a:00.4 | sudo tee /sys/bus/pci/devices/0000:3a:00.4/driver/unbind

<span class="pl-c"># Bind device to vfio-pci driver</span>
<span class="pl-c1">echo</span> 0x1d22 0x3690 | sudo tee /sys/bus/pci/drivers/vfio-pci/new_id
</pre>
</div>
