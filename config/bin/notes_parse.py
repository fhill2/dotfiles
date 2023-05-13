#!/usr/bin/python
# ==========================================================
# mistle - does not support writing after parsing
# import mistletoe
# with open(fp, 'r') as fin:
    # print(mistletoe.markdown(fin))

# from mistletoe import Document, HTMLRenderer

# with open(fp, 'r') as fin:
    # with HTMLRenderer() as renderer:     # or: `with HTMLRenderer(AnotherToken1, AnotherToken2) as renderer:`
        # doc = Document(fin)              # parse the lines into AST
        # rendered = print(renderer.render(doc))  # render the AST
        # internal lists of tokens to be parsed are automatically reset when exiting this `with` block
# ==========================================================
# https://markdown-it-py.readthedocs.io/en/latest/using.html
# https://github.com/executablebooks/markdown-it-py/issues/164#issuecomment-834857967
# Basic example - parsing markdown, editing (not implemented) - writing back to file
fp="/home/f1/dev/notes/1/arch-config/apple-ios-iphone-support.md"
fp="/home/f1/tmp/markdown.md"
def read_file(fp):
    f = open(fp, "r")
    lines = f.readlines()
    f.close()
    return "".join(lines)

from markdown_it import MarkdownIt
from mdformat.renderer import MDRenderer

mdit = MarkdownIt()
env = {}
tokens = mdit.parse(read_file(fp), env)

rendered_part = MDRenderer().render(tokens, mdit.options, env)
print(rendered_part)
# ==========================================================
