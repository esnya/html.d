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

    ///
    HTMLElement[] children;

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

    /// 子要素を追加
    void appendChild(HTMLElement element) {
        children ~= element;
    }
    ///
    unittest {
        auto ol = new HTMLElement("ol");

        auto i1 = new HTMLElement("li");
        auto a1 = new HTMLElement("a", "link1");

        auto i2 = new HTMLElement("li");
        auto a2 = new HTMLElement("a", "link2");

        ol.appendChild(i1);
        i1.appendChild(a1);

        i2.appendChild(a2);
        ol.appendChild(i2);

        assert(equal(ol.children, [i1, i2]));
        assert(equal(i1.children, [a1]));
        assert(equal(i2.children, [a2]));
    }
}
