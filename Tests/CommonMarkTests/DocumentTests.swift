import CommonMark
import XCTest

final class DocumentTests: XCTestCase {
    func testEquatable() {
        // given
        let a = Document("# Hello")
        let b = Document("Lorem *ipsum*")
        let c = a
        let d = Document("Lorem _ipsum_")

        // then
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(a, c)
        XCTAssertEqual(b, d)
    }

    func testLosslessConversion() {
        // given
        let text = "# __Hello__ *world*\n"

        // when
        let result = Document(text).description

        // then
        XCTAssertEqual("# **Hello** *world*\n", result)
    }

    func testEmptyDocument() {
        // given
        let content = ""

        // when
        let result = Document(content).blocks

        // then
        XCTAssertEqual([], result)
    }

    func testApplyTransform() {
        // given
        let text = """
        ## Try CommonMark

        You can try CommonMark here.  This dingus is powered by
        [commonmark.js](https://github.com/jgm/commonmark.js), the
        `JavaScript` reference implementation.

        ```swift
        let a = b
        ```

        1. item one
        2. item two
           - sublist
           - sublist
        """

        // when
        let result = Document(text).applyingTransform { text in
            text.uppercased()
        }

        // then
        XCTAssertEqual(
            Document(
                """
                ## TRY COMMONMARK

                YOU CAN TRY COMMONMARK HERE.  THIS DINGUS IS POWERED BY
                [COMMONMARK.JS](https://github.com/jgm/commonmark.js), THE
                `JavaScript` REFERENCE IMPLEMENTATION.

                ``` swift
                let a = b
                ```

                1.  ITEM ONE
                2.  ITEM TWO
                      - SUBLIST
                      - SUBLIST
                """
            ),
            result
        )
    }

    func testBlockQuote() {
        // given
        let text = """
          >Hello
          >>World
        """

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .blockQuote([
                    .paragraph([.text("Hello")]),
                    .blockQuote([
                        .paragraph([.text("World")]),
                    ]),
                ]),
            ],
            result
        )
    }

    func testList() {
        // given
        let text = """
           1. one
           1. two
              - nested 1
              - nested 2
        """

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .list(
                    List(
                        style: .ordered(start: 1),
                        items: [
                            Item(
                                blocks: [.paragraph([.text("one")])]
                            ),
                            Item(
                                blocks: [
                                    .paragraph([.text("two")]),
                                    .list(
                                        List(
                                            items: [
                                                Item(
                                                    blocks: [.paragraph([.text("nested 1")])]
                                                ),
                                                Item(
                                                    blocks: [.paragraph([.text("nested 2")])]
                                                ),
                                            ]
                                        )
                                    ),
                                ]
                            ),
                        ]
                    )
                ),
            ],
            result
        )
    }

    func testLooseList() {
        // given
        let text = """
           9. one

           1. two
              - nested 1
              - nested 2
        """

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .list(
                    List(
                        style: .ordered(start: 9),
                        spacing: .loose,
                        items: [
                            Item(
                                blocks: [.paragraph([.text("one")])]
                            ),
                            Item(
                                blocks: [
                                    .paragraph([.text("two")]),
                                    .list(
                                        List(
                                            items: [
                                                Item(
                                                    blocks: [.paragraph([.text("nested 1")])]
                                                ),
                                                Item(
                                                    blocks: [.paragraph([.text("nested 2")])]
                                                ),
                                            ]
                                        )
                                    ),
                                ]
                            ),
                        ]
                    )
                ),
            ],
            result
        )
    }

    func testCodeBlock() {
        // given
        let text = """
           ```swift
           let a = 5
           let b = 42
           ```
        """

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .code(
                    "let a = 5\nlet b = 42\n",
                    language: "swift"
                ),
            ],
            result
        )
    }

    func testHTML() {
        // given
        let text = "<p>Hello world!</p>"

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .html("<p>Hello world!</p>\n"),
            ],
            result
        )
    }

    func testParagraph() {
        // given
        let text = "Hello world!"

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([.text("Hello world!")]),
            ],
            result
        )
    }

    func testHeading() {
        // given
        let text = """
           # Hello
           ## World
        """

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .heading([.text("Hello")], level: 1),
                .heading([.text("World")], level: 2),
            ],
            result
        )
    }

    func testSoftBreak() {
        // given
        let text = """
           Hello
               World
        """

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([
                    .text("Hello"),
                    .softBreak,
                    .text("World"),
                ]),
            ],
            result
        )
    }

    func testLineBreak() {
        // given
        let text = "Hello  \n      World"

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([
                    .text("Hello"),
                    .lineBreak,
                    .text("World"),
                ]),
            ],
            result
        )
    }

    func testCodeInline() {
        // given
        let text = "Returns `nil`."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([
                    .text("Returns "),
                    .code("nil"),
                    .text("."),
                ]),
            ],
            result
        )
    }

    func testHTMLInline() {
        // given
        let text = "Returns <code>nil</code>."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([
                    .text("Returns "),
                    .html("<code>"),
                    .text("nil"),
                    .html("</code>"),
                    .text("."),
                ]),
            ],
            result
        )
    }

    func testEmphasis() {
        // given
        let text = "Hello _world_."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([
                    .text("Hello "),
                    .emphasis([.text("world")]),
                    .text("."),
                ]),
            ],
            result
        )
    }

    func testStrong() {
        // given
        let text = "Hello __world__."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([
                    .text("Hello "),
                    .strong([.text("world")]),
                    .text("."),
                ]),
            ],
            result
        )
    }

    func testLink() {
        // given
        let text = "Hello [world](https://example.com)."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([
                    .text("Hello "),
                    .link([.text("world")], url: "https://example.com"),
                    .text("."),
                ]),
            ],
            result
        )
    }

    func testImage() {
        // given
        let text = "Hello ![world](https://example.com/world.jpg)."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([
                    .text("Hello "),
                    .image([.text("world")], url: "https://example.com/world.jpg"),
                    .text("."),
                ]),
            ],
            result
        )
    }

    func testImageURLs() {
        // given
        let text = """
        # Heading ![](image1.jpg)
        Paragraph ![](image2.jpg)
        > Blockquote ![](image3.jpg)
        - List ![](image4.jpg)
        ---
        Emphasis *![](image5.jpg)* and strong **![](image6.jpg)**\
        Repeated ![](image3.jpg)
        [![](image7.jpg)](https://example.com)
        """

        // when
        let result = Document(text).imageURLs

        // then
        XCTAssertEqual(
            [
                "image1.jpg", "image2.jpg", "image3.jpg",
                "image4.jpg", "image5.jpg", "image6.jpg",
                "image7.jpg",
            ],
            result
        )
    }
}

#if swift(>=5.4)
    extension DocumentTests {
        func testBuildEmptyDocument() {
            // when
            let result = Document {}

            // then
            XCTAssertEqual(Document(""), result)
        }

        func testBuildBlockQuoute() {
            // when
            let result = Document {
                BlockQuote {
                    Paragraph("Hello")
                    BlockQuote {
                        Paragraph("World")
                    }
                }
            }

            // then
            XCTAssertEqual(
                Document(
                    """
                      >Hello
                      >>World
                    """
                ),
                result
            )
        }

        func testBuildList() {
            // when
            let result = Document {
                List(start: 1) {
                    Item {
                        "one"
                    }
                    Item {
                        "two"
                        List {
                            "nested 1"
                            "nested 2"
                        }
                    }
                }
            }

            // then
            XCTAssertEqual(
                Document(
                    """
                       1. one
                       1. two
                          - nested 1
                          - nested 2
                    """
                ),
                result
            )
        }

        func testBuildLooseList() {
            // when
            let result = Document {
                List(start: 9, spacing: .loose) {
                    Item {
                        "one"
                    }
                    Item {
                        "two"
                        List {
                            "nested 1"
                            "nested 2"
                        }
                    }
                }
            }

            // then
            XCTAssertEqual(
                Document(
                    """
                       9. one

                       1. two
                          - nested 1
                          - nested 2
                    """
                ),
                result
            )
        }

        func testBuildMultiParagraphList() {
            // when
            let result = Document {
                List {
                    Item {
                        "one"
                        "2nd paragraph"
                    }
                    Item {
                        "two"
                        List {
                            "nested 1"
                            "nested 2"
                        }
                    }
                }
            }

            // then
            XCTAssertEqual(
                Document(
                    """
                       - one

                         2nd paragraph

                       - two
                         - nested 1
                         - nested 2
                    """
                ),
                result
            )
        }

        func testBuildCodeBlock() {
            // when
            let result = Document {
                CodeBlock(language: "swift") {
                    """
                    let a = 5
                    let b = 42
                    """
                }
            }

            // then
            XCTAssertEqual(
                Document(
                    """
                       ```swift
                       let a = 5
                       let b = 42
                       ```
                    """
                ),
                result
            )
        }

        func testBuildParagraph() {
            // when
            let result = Document {
                "Hello world!"
            }

            // then
            XCTAssertEqual(Document("Hello world!"), result)
        }

        func testBuildHeading() {
            // when
            let result = Document {
                Heading {
                    "Hello"
                }
                Heading(level: 2) {
                    "World"
                }
            }

            // then
            XCTAssertEqual(
                Document(
                    """
                       # Hello
                       ## World
                    """
                ),
                result
            )
        }

        func testBuildCodeInline() {
            // when
            let result = Document {
                Paragraph {
                    "Returns "
                    Code("nil")
                    "."
                }
            }

            // then
            XCTAssertEqual(
                Document("Returns `nil`."),
                result
            )
        }

        func testBuildEmphasis() {
            // when
            let result = Document {
                Paragraph {
                    "Hello "
                    Emphasis("world")
                    "."
                }
            }

            // then
            XCTAssertEqual(
                Document("Hello _world_."),
                result
            )
        }

        func testBuildStrong() {
            // when
            let result = Document {
                Paragraph {
                    "Hello "
                    Strong("world")
                    "."
                }
            }

            // then
            XCTAssertEqual(
                Document("Hello __world__."),
                result
            )
        }

        func testBuildLink() {
            // when
            let result = Document {
                Paragraph {
                    "Hello "
                    Link(url: "https://example.com") {
                        "world"
                    }
                    "."
                }
            }

            // then
            XCTAssertEqual(
                Document("Hello [world](https://example.com)."),
                result
            )
        }

        func testBuildImage() {
            // when
            let result = Document {
                Paragraph {
                    "Hello "
                    Image(url: "https://example.com/world.jpg") {
                        "world"
                    }
                    "."
                }
            }

            // then
            XCTAssertEqual(
                Document("Hello ![world](https://example.com/world.jpg)."),
                result
            )
        }
    }
#endif

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        guard let url = URL(string: "\(value)") else {
            fatalError("Invalid URL: \(value)")
        }
        self = url
    }
}
