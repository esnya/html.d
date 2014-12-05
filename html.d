/// HTMLパーサってないよね
module html;

import std.algorithm;

/// 
class HTMLElement {
    /// 
    string tag;

    /// 
    string[string] attributes;

    /// tagとattributesからエレメントを生成
    this(string tag, string[string] attributes = null) {
        this.tag = tag;
        this.attributes = attributes;
    }
}

///
unittest {
    auto e1 = new HTMLElement("div");
    assert(equal(e1.tag, "div"));

    string[string] attributes;
    attributes["id"] = "id";
    attributes["href"] = "#";

    auto e2 = new HTMLElement("a", attributes);
    assert(equal(e2.attributes.keys, attributes.keys));
    assert(equal(e2.attributes.values, attributes.values));
}
