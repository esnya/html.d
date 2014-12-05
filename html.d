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
        auto div = new HTMLElement("div");
        assert(equal(div.tag, "div"));
    }
    ///
    unittest {
        string[string] attributes;
        attributes["id"] = "id";
        attributes["href"] = "#";

        auto a = new HTMLElement("a", attributes);
        assert(equal(a.attributes.keys, attributes.keys));
        assert(equal(a.attributes.values, attributes.values));
    }
    ///
    unittest {
        auto span = new HTMLElement("span", "text");
        assert(equal(span.text, "text"));
    }
}
