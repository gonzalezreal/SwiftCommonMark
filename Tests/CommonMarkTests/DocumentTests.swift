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

    func testBuildEmptyDocument() {
        // when
        let result = Document {}

        // then
        XCTAssertEqual(Document(""), result)
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
            BlockQuote {
                Paragraph("Hello")
                BlockQuote {
                    Paragraph("World")
                }
            }.asBlocks(),
            result
        )
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
            }.asBlocks(),
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
            }.asBlocks(),
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
            CodeBlock(language: "swift") {
                """
                let a = 5
                let b = 42

                """
            }.asBlocks(),
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
            Paragraph("Hello world!").asBlocks(),
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
            Paragraph {
                "Returns "
                Code("nil")
                "."
            }.asBlocks(),
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
            Paragraph {
                "Hello "
                Emphasis("world")
                "."
            }.asBlocks(),
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

    func testStrong() {
        // given
        let text = "Hello __world__."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            Paragraph {
                "Hello "
                Strong("world")
                "."
            }.asBlocks(),
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

    func testLink() {
        // given
        let text = "Hello [world](https://example.com)."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            Paragraph {
                "Hello "
                Link(url: "https://example.com") {
                    "world"
                }
                "."
            }.asBlocks(),
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

    func testImage() {
        // given
        let text = "Hello ![world](https://example.com/world.jpg)."

        // when
        let result = Document(text).blocks

        // then
        XCTAssertEqual(
            Paragraph {
                "Hello "
                Image(url: "https://example.com/world.jpg") {
                    "world"
                }
                "."
            }.asBlocks(),
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
        """

        // when
        let result = Document(text).imageURLs

        // then
        XCTAssertEqual(
            [
                "image1.jpg", "image2.jpg", "image3.jpg",
                "image4.jpg", "image5.jpg", "image6.jpg",
            ],
            result
        )
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: StaticString) {
        guard let url = URL(string: "\(value)") else {
            fatalError("Invalid URL: \(value)")
        }
        self = url
    }
}
