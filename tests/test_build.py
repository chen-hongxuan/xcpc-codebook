"""Tests for the print-only heading transformation used by the build script."""

import re
import unittest

from scripts.build import transform


HIDE_RULE = re.compile(r"#set\s+heading\s*\(\s*outlined\s*:\s*false\s*\)")
RESTORE_RULE = re.compile(r"#set\s+heading\s*\(\s*outlined\s*:\s*true\s*\)")


class TransformTests(unittest.TestCase):
    def assert_rule_count(self, output, count):
        self.assertEqual(len(HIDE_RULE.findall(output)), count)
        self.assertEqual(len(RESTORE_RULE.findall(output)), count)

    def test_unmarked_source_is_unchanged(self):
        source = (
            '= 普通标题 <ordinary>\n'
            '正文有 $x^2$、`raw`、*强调*。\n'
            '```typst\n== 代码中的文本\n```\n'
        )
        self.assertEqual(transform(source), source)

    def test_heading_levels_and_indentation(self):
        source = '=& 一级\n  ==& 二级\n\t======& 六级\n'
        output = transform(source)

        self.assertIn('= 一级\n', output)
        self.assertIn('  == 二级\n', output)
        self.assertIn('\t====== 六级\n', output)
        self.assertNotIn('=&', output)
        self.assertNotIn('==&', output)
        self.assertNotIn('======&', output)
        self.assert_rule_count(output, 3)

    def test_rich_heading_text_numbering_and_trailing_label_survive(self):
        source = (
            '#set heading(numbering: "1.1")\n'
            '==& *粗体* _斜体_ $x^2 + y^2$ `raw` <rich-heading>\n'
            '正文 [方括号] 保持原样。\n'
        )
        output = transform(source)

        self.assertIn('#set heading(numbering: "1.1")\n', output)
        self.assertIn('== *粗体* _斜体_ $x^2 + y^2$ `raw` <rich-heading>\n', output)
        self.assertIn('正文 [方括号] 保持原样。\n', output)
        self.assert_rule_count(output, 1)

    def test_unmatched_brackets_in_headings_are_preserved(self):
        source = '==& 左方括号 [未闭合 <left>\n===& 右方括号 ] <right>\n'
        output = transform(source)

        self.assertIn('== 左方括号 [未闭合 <left>\n', output)
        self.assertIn('=== 右方括号 ] <right>\n', output)
        self.assert_rule_count(output, 2)

    def test_marker_at_eof_without_newline(self):
        output = transform('开头正文\n==& 最后一节 <end>')

        self.assertIn('开头正文\n', output)
        self.assertIn('== 最后一节 <end>', output)
        self.assertNotIn('==& 最后一节', output)
        self.assert_rule_count(output, 1)

    def test_multiple_markers_and_following_ordinary_heading(self):
        source = (
            '==& 隐藏甲\n'
            '段落。\n'
            '===& 隐藏乙\n'
            '=== 普通丙 <ordinary>\n'
        )
        output = transform(source)

        self.assertIn('== 隐藏甲\n', output)
        self.assertIn('=== 隐藏乙\n', output)
        self.assertIn('=== 普通丙 <ordinary>\n', output)
        self.assertLess(output.index('== 隐藏甲'), output.index('=== 隐藏乙'))
        self.assertLess(output.index('=== 隐藏乙'), output.index('=== 普通丙'))
        self.assert_rule_count(output, 2)
        hides = list(HIDE_RULE.finditer(output))
        restores = list(RESTORE_RULE.finditer(output))
        self.assertLess(hides[0].start(), output.index('== 隐藏甲'))
        self.assertLess(output.index('== 隐藏甲'), restores[0].start())
        self.assertLess(restores[0].start(), hides[1].start())
        self.assertLess(hides[1].start(), output.index('=== 隐藏乙'))
        self.assertLess(output.index('=== 隐藏乙'), restores[1].start())
        self.assertLess(restores[1].start(), output.index('=== 普通丙'))

    def test_three_and_four_backtick_fences_are_ignored(self):
        source = (
            '```typst\n'
            '==& 三反引号中的字面文本\n'
            '```\n'
            '````typst\n'
            '```\n'
            '==& 四反引号中的字面文本\n'
            '```\n'
            '````\n'
            '==& 真正的标题\n'
        )
        output = transform(source)

        self.assertIn('==& 三反引号中的字面文本\n', output)
        self.assertIn('==& 四反引号中的字面文本\n', output)
        self.assertIn('== 真正的标题\n', output)
        self.assert_rule_count(output, 1)

    def test_multiline_inline_raw_is_ignored(self):
        source = (
            '这段 `raw 从这里开始\n'
            '==& raw 中的字面文本\n'
            '到这里结束`，然后是普通正文。\n'
            '==& 真正的标题\n'
        )
        output = transform(source)

        self.assertIn('==& raw 中的字面文本\n', output)
        self.assertIn('== 真正的标题\n', output)
        self.assert_rule_count(output, 1)

    def test_line_comments_and_nested_block_comments_are_ignored(self):
        source = (
            '// ==& 行注释\n'
            '  // ==& 缩进行注释\n'
            '/* 外层注释\n'
            '==& 外层字面文本\n'
            '/* 内层注释\n'
            '==& 内层字面文本\n'
            '*/\n'
            '==& 返回外层的字面文本\n'
            '*/\n'
            '==& 真正的标题\n'
        )
        output = transform(source)

        for text in (
            '// ==& 行注释\n',
            '  // ==& 缩进行注释\n',
            '==& 外层字面文本\n',
            '==& 内层字面文本\n',
            '==& 返回外层的字面文本\n',
        ):
            self.assertIn(text, output)
        self.assertIn('== 真正的标题\n', output)
        self.assert_rule_count(output, 1)

    def test_multiline_code_string_is_ignored(self):
        source = (
            '#let example = "字符串包含 \\"引号\\"\n'
            '==& 字符串中的字面文本\n'
            '字符串结束"\n'
            '==& 真正的标题\n'
        )
        output = transform(source)

        self.assertIn('==& 字符串中的字面文本\n', output)
        self.assertIn('== 真正的标题\n', output)
        self.assert_rule_count(output, 1)

    def test_unpaired_smart_quote_in_markup_does_not_hide_later_heading(self):
        source = '普通正文中的 "未配对引号\n==& 真正的标题\n'
        output = transform(source)

        self.assertIn('普通正文中的 "未配对引号\n', output)
        self.assertIn('== 真正的标题\n', output)
        self.assert_rule_count(output, 1)

    def test_multiline_string_in_code_expression_hides_literal_marker(self):
        source = (
            '#let s = (\n'
            '"字符串\n'
            '==&字面文本\n'
            '"\n'
            ')\n'
            '==& 真标题\n'
        )
        output = transform(source)

        self.assertIn('==&字面文本\n', output)
        self.assertIn('== 真标题\n', output)
        self.assert_rule_count(output, 1)

    def test_inserted_rules_keep_heading_indentation(self):
        output = transform('  ==& 缩进标题\n')

        self.assertIn('  == 缩进标题\n', output)
        self.assertRegex(
            output, r'(?m)^  #set\s+heading\s*\(\s*outlined\s*:\s*false\s*\)$'
        )
        self.assertRegex(
            output, r'(?m)^  #set\s+heading\s*\(\s*outlined\s*:\s*true\s*\)$'
        )

    def test_restore_rule_follows_multiline_comment_and_math(self):
        source = (
            '==& 标题 /*注释\n'
            '注释结束*/\n'
            '== 后续标题\n'
            '==& 数学标题 $x\n'
            '+y$\n'
            '== 之后标题\n'
        )
        output = transform(source)

        self.assertIn('== 标题 /*注释\n注释结束*/\n', output)
        self.assertIn('== 数学标题 $x\n+y$\n', output)
        self.assert_rule_count(output, 2)
        restores = list(RESTORE_RULE.finditer(output))
        self.assertLess(output.index('注释结束*/'), restores[0].start())
        self.assertLess(restores[0].start(), output.index('== 后续标题'))
        self.assertLess(output.index('+y$'), restores[1].start())
        self.assertLess(restores[1].start(), output.index('== 之后标题'))


if __name__ == '__main__':
    unittest.main()
