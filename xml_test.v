import xml
import os

fn test_static_xml() {
	node := xml.parse('<thing abc="test"><test>Hello</test></thing>')
	assert node.childrens[0].name == "thing"
}

fn test_file_xml() {
	data := os.read_file("file_test.xml") or {
		eprintln("Could not read 'file_test.xml'")
		exit(1)
	}
	doc := xml.parse(data)
	prj := doc.childrens[0]
	assert prj.name == "project"
	assert prj.childrens[0].name == "data"
	assert prj.childrens[0].attributes[0].name == "type"
	assert prj.childrens[0].attributes[0].value == "some data"
	assert prj.childrens[0].attributes[1].value == "2"
}
