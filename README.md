# vwxml
Pure V library for parsing XML.

Example: this parses `<thing abc="test"><test>Hello</test></thing>` to
`Node{name=_root_, text=, childrens=[Node{name=thing, text=, childrens=[Node{name=test, text=Hello, childrens=[], attributes=[]}], attributes=[Attribute{name=abc, value=test}]}], attributes=[]}`
(struct printed with `println`).

The library still doesn't support things like XML header tag (ex: `<?xml version=1.1>), doctype, and some other rarely used features.
