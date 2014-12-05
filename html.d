/// HTMLパーサってないよね
module html;

import std.algorithm;

/// 
class HTMLElement {
    /// 
    string tag;

    /// 
    string[string] attributes;

    ///
    string text;

    /// エレメントを生成
    this(string tag, string[string] attributes = null) {
        this.tag = tag;
        this.attributes = attributes;
    }
    /// ditto
    this(string tag, string text, string[string] attributes = null) {
        this(tag, attributes);
        this.text = text;
    }
    ///
    unittest {
        /// create
        auto e1 = new HTMLElement("div");
        assert(equal(e1.tag, "div"));

        string[string] attributes;
        attributes["id"] = "id";
        attributes["href"] = "#";

        /// with attributes
        auto e2 = new HTMLElement("a", attributes);
        assert(equal(e2.attributes.keys, attributes.keys));
        assert(equal(e2.attributes.values, attributes.values));

        // with text
        auto e3 = new HTMLElement("span", "text");
        assert(equal(e3.text, "text"));
    }
}
