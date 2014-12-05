/// HTMLパーサってないよね
module html;

import std.algorithm;
import std.array;
import std.ascii;
import std.range;
import std.utf;

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
        element._parent = this;
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

    protected HTMLElement _parent;
    /// 親を取得
    @property HTMLElement parent() {
        return _parent;
    }
    ///
    unittest {
        auto parent = new HTMLElement("div");
        auto child = new HTMLElement("div");

        parent.appendChild(child);

        assert(parent.parent is null);
        assert(child.parent is parent);
    }
}

/// パース時に発生する例外
class HTMLParseError : Exception {
    this(string msg, string file = __FILE__, uint line = __LINE__) {
        super(msg, file, line);
    }
}

/// パース
HTMLElement parseHTML(S)(S html) if (isInputRange!S && is(ElementType!S == dchar)) {
    HTMLElement root;
    HTMLElement p;

    auto parseTagName() {
        auto c = html.front;
        auto name = appender!(ElementType!S[]);
        while (c.isAlphaNum) {
            name.put(c);
            html.popFront();
            c = html.front;
        }
        return name.data.toUTF8();
    }

    while (!html.empty) {
        if (html.front == '<') { // タグ or コメント開始
            html.popFront();

            if (html.front.isAlphaNum) { // タグ名
                auto tagName = parseTagName();

                if (html.front.isWhite) { // 属性あり？
                    assert(0);
                } else {
                    auto element = new HTMLElement(tagName);
                    if (root is null) {
                        root = element;
                    }
                    if (p !is null) {
                        p.appendChild(element);
                    }
                    p = element;
                }
            } else if (html.front == '/') {  // 終了タグ
                html.popFront();

                auto tagName = parseTagName();

                while (html.front.isWhite) {
                    html.popFront();
                }

                if (html.front != '>') {    // ">" が必要
                    throw new HTMLParseError((`Unexcepted character: "` ~ [html.front].toUTF8() ~ `" excepted ">"`).idup);
                }
            } else {
                throw new HTMLParseError(("Unexcepted character: " ~ [html.front].toUTF8()).idup);
            }
        } else {
            throw new HTMLParseError(("Unexcepted character: " ~ [html.front].toUTF8()).idup);
        }

        html.popFront();
    }

    return root;
}
///
unittest {
    auto div = parseHTML("<div></div>");
    assert(div !is null);
    assert(equal(div.tag, "div"));
    assert(div.children.length == 0);
}
///
unittest {
    auto div = parseHTML("<div><div></div></div>");
    assert(div !is null);
    assert(div.children.length == 1);
    assert(equal(div.children[0].tag, "div"));
    assert(div.children[0].parent is div);
}
