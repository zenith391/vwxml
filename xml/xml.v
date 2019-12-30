module xml

struct Attribute {
	pub mut:
		name string
		value string
}

struct ParserState {
	pub mut:
		in_head_tag bool
		in_attribute_key bool
		in_attribute_val bool
		attr_key string
		attr_val string
		in_string bool
		head_tag_str string
		tag_text string
		tag_attributes []Attribute
}

struct Node {
	pub mut:
		attributes []Attribute
		name string
		text string
		childrens []Node
		parent &Node
}

fn can_be_included(ch byte) bool {
	return ch != `\n` && ch != `\t` && ch != `\r`
}

pub fn (state mut ParserState) push_attribute() {
	state.tag_attributes << Attribute{state.attr_key, state.attr_val}
}

pub fn (attr Attribute) str() string {
	return "Attribute{name=" + attr.name + ", value=" + attr.value + "}"
}

pub fn (node Node) str() string {
	return "Node{name=" + node.name + ", text=" + node.text + ", childrens=" + node.childrens.str() + ", attributes=" + node.attributes.str() + "}"
}

pub fn parse(xml string) Node {
	root := Node{[]Attribute, "_root_", "", []Node, &Node(0)}
	chars := xml.bytes()

	mut state := ParserState{false,false,false,"","",false,"","",[]Attribute}
	mut curr_node := &root
	for ch in chars {
		if state.in_head_tag {
			if ch == `>` {
				state.in_head_tag = false
				state.in_attribute_key = false
				state.in_attribute_val = false
				head := state.head_tag_str
				if head.starts_with("/") { // closing head
					curr_node.text = state.tag_text
					curr_node.parent.childrens << *curr_node
					curr_node = curr_node.parent
					state.tag_text = ""
				} else if head.starts_with("?") { // incomplete test
					if (state.attr_key != "") {
						state.push_attribute()
					}
					state.attr_key = ""
					state.attr_val = ""
					state.tag_attributes = []
				} else {
					if (state.attr_key != "") {
						state.push_attribute()
					}
					state.attr_key = ""
					state.attr_val = ""
					curr_node = &Node{state.tag_attributes, state.head_tag_str, "", []Node, curr_node}
					state.tag_attributes = []
				}
			} else {
				if !state.in_string && ch == ` ` {
					state.in_attribute_key = true
					state.in_attribute_val = false
					if (state.attr_key != "") {
						state.push_attribute()
					}
					state.attr_key = ""
					state.attr_val = ""
				} else if state.in_attribute_key || state.in_attribute_val {
					if state.in_attribute_key {
						if ch == `=` {
							state.in_attribute_key = false
							state.in_attribute_val = true
						} else {
							state.attr_key = state.attr_key + ch.str()
						}
					} else if state.in_attribute_val {
						if ch == `"` || ch == `'` {
							state.in_string = !state.in_string
						} else {
							if state.in_string {
								state.attr_val = state.attr_val + ch.str()
							}
						}
					}
				} else {
					if (can_be_included(ch)) {
						state.head_tag_str = state.head_tag_str + ch.str()
					}
				}
			}
		} else {
			if ch == `<` {
				state.in_head_tag = true
				state.head_tag_str = ""
			} else {
				if (can_be_included(ch)) {
					state.tag_text = state.tag_text + ch.str()
				}
			}
		}
	}
	return root
}
