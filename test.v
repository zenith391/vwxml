import xml

fn main() {
	node := xml.parse('<thing abc="test"><test>Hello</test></thing>')
	println(node)
}
