# vwxml
Pure V library for parsing XML. The data is accessed with a tree API accessible directly within the `Node`  struct.

Example: this parses `<thing abc="test"><test>Hello</test></thing>` to
`Node{name=_root_, text=, childrens=[Node{name=thing, text=, childrens=[Node{name=test, text=Hello, childrens=[], attributes=[]}], attributes=[Attribute{name=abc, value=test}]}], attributes=[]}`
(struct printed with `println`).

It doesn't support (yet):
- CDATA sections
- Error handling
- Schemas (DTD)

The features listed above will all be supported soon
