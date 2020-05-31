import xml

fn main() {
	node := xml.parse('<thing abc="test"><test>Hello</test></thing>')
	eprintln('$node')
	thing := node.childrens[0].name
	eprintln('$thing')
	assert node.childrens[0].name == "thing"
}
