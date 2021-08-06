import CommonMark
import XCTest

final class DocumentTests: XCTestCase {
    func testEquatable() throws {
        // given
        let a = try Document(markdown: "# Hello")
        let b = try Document(markdown: "Lorem *ipsum*")
        let c = a
        let d = try Document(markdown: "Lorem _ipsum_")

        // then
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(a, c)
        XCTAssertEqual(b, d)
    }

    func testEmptyDocument() throws {
        // given
        let content = ""

        // when
        let result = try Document(markdown: content).blocks

        // then
        XCTAssertEqual([], result)
    }

    func testBlockQuote() throws {
        // given
        let text = """
          >Hello
          >>World
        """

        // when
        let result = try Document(markdown: text).blocks

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

    func testList() throws {
        // given
        let text = """
           1. one
           1. two
              - nested 1
              - nested 2
        """

        // when
        let result = try Document(markdown: text).blocks

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

    func testLooseList() throws {
        // given
        let text = """
           9. one

           1. two
              - nested 1
              - nested 2
        """

        // when
        let result = try Document(markdown: text).blocks

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

    func testCodeBlock() throws {
        // given
        let text = """
           ```swift
           let a = 5
           let b = 42
           ```
        """

        // when
        let result = try Document(markdown: text).blocks

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

    func testHTML() throws {
        // given
        let text = "<p>Hello world!</p>"

        // when
        let result = try Document(markdown: text).blocks

        // then
        XCTAssertEqual(
            [
                .html("<p>Hello world!</p>\n"),
            ],
            result
        )
    }

    func testParagraph() throws {
        // given
        let text = "Hello world!"

        // when
        let result = try Document(markdown: text).blocks

        // then
        XCTAssertEqual(
            [
                .paragraph([.text("Hello world!")]),
            ],
            result
        )
    }

    func testHeading() throws {
        // given
        let text = """
           # Hello
           ## World
        """

        // when
        let result = try Document(markdown: text).blocks

        // then
        XCTAssertEqual(
            [
                .heading([.text("Hello")], level: 1),
                .heading([.text("World")], level: 2),
            ],
            result
        )
    }

    func testSoftBreak() throws {
        // given
        let text = """
           Hello
               World
        """

        // when
        let result = try Document(markdown: text).blocks

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

    func testLineBreak() throws {
        // given
        let text = "Hello  \n      World"

        // when
        let result = try Document(markdown: text).blocks

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

    func testCodeInline() throws {
        // given
        let text = "Returns `nil`."

        // when
        let result = try Document(markdown: text).blocks

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

    func testHTMLInline() throws {
        // given
        let text = "Returns <code>nil</code>."

        // when
        let result = try Document(markdown: text).blocks

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

    func testEmphasis() throws {
        // given
        let text = "Hello _world_."

        // when
        let result = try Document(markdown: text).blocks

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

    func testStrong() throws {
        // given
        let text = "Hello __world__."

        // when
        let result = try Document(markdown: text).blocks

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

    func testLink() throws {
        // given
        let text = "Hello [world](https://example.com)."

        // when
        let result = try Document(markdown: text).blocks

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

    func testImage() throws {
        // given
        let text = "Hello ![world](https://example.com/world.jpg)."

        // when
        let result = try Document(markdown: text).blocks

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
}

#if swift(>=5.4)
    extension DocumentTests {
        func testBuildEmptyDocument() throws {
            // when
            let result = Document {}

            // then
            XCTAssertEqual(try Document(markdown: ""), result)
        }

        func testBuildBlockQuoute() throws {
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
                try Document(
                    markdown: """
                      >Hello
                      >>World
                    """
                ),
                result
            )
        }

        func testBuildList() throws {
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
                try Document(
                    markdown: """
                       1. one
                       1. two
                          - nested 1
                          - nested 2
                    """
                ),
                result
            )
        }

        func testBuildLooseList() throws {
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
                try Document(
                    markdown: """
                       9. one

                       1. two
                          - nested 1
                          - nested 2
                    """
                ),
                result
            )
        }

        func testBuildMultiParagraphList() throws {
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
                try Document(
                    markdown: """
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

        func testBuildCodeBlock() throws {
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
                try Document(
                    markdown: """
                       ```swift
                       let a = 5
                       let b = 42
                       ```
                    """
                ),
                result
            )
        }

        func testBuildParagraph() throws {
            // when
            let result = Document {
                "Hello world!"
            }

            // then
            XCTAssertEqual(try Document(markdown: "Hello world!"), result)
        }

        func testBuildHeading() throws {
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
                try Document(
                    markdown: """
                       # Hello
                       ## World
                    """
                ),
                result
            )
        }

        func testBuildCodeInline() throws {
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
                try Document(markdown: "Returns `nil`."),
                result
            )
        }

        func testBuildEmphasis() throws {
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
                try Document(markdown: "Hello _world_."),
                result
            )
        }

        func testBuildStrong() throws {
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
                try Document(markdown: "Hello __world__."),
                result
            )
        }

        func testBuildLink() throws {
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
                try Document(markdown: "Hello [world](https://example.com)."),
                result
            )
        }

        func testBuildImage() throws {
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
                try Document(markdown: "Hello ![world](https://example.com/world.jpg)."),
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
