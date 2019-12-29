import vwxml

fn main() {
	node := vwxml.parse('<thing abc="test"><test>Hello</test></thing>')
	println(node)
}
