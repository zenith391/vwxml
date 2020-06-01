import xml

fn main() {
	node := xml.parse('<thing abc="test"><test>Hello</test><test uid="123">World</test></thing>')
	assert(node.childrens.len == 1)
	thing := node.childrens[0]
	assert(thing.childrens.len == 2)
	eprintln('$node')
	for t in thing.childrens {
		for a in t.attributes {
			println(' (a) $a.name = $a.value')
		}
		println('---> $t.name')
	}
}
