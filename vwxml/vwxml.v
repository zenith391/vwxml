module vwxml

struct Attribute {
	pub mut:
		name string
		value string
}

struct Node {
	pub mut:
		attributes []Attribute
		name string
		text string
		childrens []Node
		parent &Node
}

pub fn parse(xml string) Node {
	root := Node{[]Attribute, "_root_", "", []Node, &Node(0)}
	chars := xml.bytes()
	mut in_head_tag := false
	mut in_attribute_key := false
	mut in_attribute_val := false
	mut attr_key := ""
	mut attr_val := ""
	mut in_string := false
	mut head_tag_str := ""
	mut tag_text := ""
	mut tag_attributes := []Attribute
	mut curr_node := &root

	for ch in chars {
		if in_head_tag {
			if ch == `>` {
				in_head_tag = false
				in_attribute_key = false
				in_attribute_val = false
				if head_tag_str.starts_with("/") { // closing head
					curr_node.text = tag_text
					curr_node.parent.childrens << *curr_node
					curr_node = curr_node.parent
					tag_text = ""
				} else {
					if (attr_key != "") {
						tag_attributes << Attribute{attr_key, attr_val}
					}
					attr_key = ""
					attr_val = ""
					curr_node = &Node{tag_attributes, head_tag_str, "", []Node, curr_node}
					tag_attributes = []
				}
			} else {
				if !in_string && ch == ` ` {
					in_attribute_key = true
					in_attribute_val = false
					if (attr_key != "") {
						tag_attributes << Attribute{attr_key, attr_val}
					}
					attr_key = ""
					attr_val = ""
				} else if in_attribute_key || in_attribute_val {
					if in_attribute_key {
						if ch == `=` {
							in_attribute_key = false
							in_attribute_val = true
						} else {
							attr_key = attr_key + ch.str()
						}
					} else if in_attribute_val {
						if ch == `"` || ch == `'` {
							in_string = !in_string
						} else {
							attr_val = attr_val + ch.str()
						}
					}
				} else {
					head_tag_str = head_tag_str + ch.str()
				}
			}
		} else {
			if ch == `<` {
				in_head_tag = true
				head_tag_str = ""
			} else {
				tag_text = tag_text + ch.str()
			}
		}
	}
	return root
}

pub fn (attr Attribute) str() string {
	return "Attribute{name=" + attr.name + ", value=" + attr.value + "}"
}

pub fn (node Node) str() string {
	return "Node{name=" + node.name + ", text=" + node.text + ", childrens=" + node.childrens.str() + ", attributes=" + node.attributes.str() + "}"
}
