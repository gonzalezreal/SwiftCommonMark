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
        .blockQuote(
          .init(
            items: [
              .paragraph(.init(text: [.text("Hello")])),
              .blockQuote(
                .init(
                  items: [
                    .paragraph(.init(text: [.text("World")]))
                  ]
                )
              ),
            ]
          )
        )
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
        .orderedList(
          .init(
            items: [
              .init(blocks: [.paragraph(.init(text: [.text("one")]))]),
              .init(
                blocks: [
                  .paragraph(.init(text: [.text("two")])),
                  .bulletList(
                    .init(
                      items: [
                        .init(blocks: [.paragraph(.init(text: [.text("nested 1")]))]),
                        .init(blocks: [.paragraph(.init(text: [.text("nested 2")]))]),
                      ],
                      tight: true
                    )
                  ),
                ]
              ),
            ],
            start: 1,
            tight: true
          )
        )
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
        .orderedList(
          .init(
            items: [
              .init(blocks: [.paragraph(.init(text: [.text("one")]))]),
              .init(
                blocks: [
                  .paragraph(.init(text: [.text("two")])),
                  .bulletList(
                    .init(
                      items: [
                        .init(blocks: [.paragraph(.init(text: [.text("nested 1")]))]),
                        .init(blocks: [.paragraph(.init(text: [.text("nested 2")]))]),
                      ],
                      tight: true
                    )
                  ),
                ]
              ),
            ],
            start: 9,
            tight: false
          )
        )
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
        .code(.init(language: "swift", code: { "let a = 5\nlet b = 42\n" }))
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
        .html(.init(html: "<p>Hello world!</p>\n"))
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
        .paragraph(.init(text: [.text("Hello world!")]))
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
        .heading(.init(text: [.text("Hello")], level: 1)),
        .heading(.init(text: [.text("World")], level: 2)),
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
        .paragraph(
          .init(
            text: [
              .text("Hello"),
              .softBreak,
              .text("World"),
            ]
          )
        )
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
        .paragraph(
          .init(
            text: [
              .text("Hello"),
              .lineBreak,
              .text("World"),
            ]
          )
        )
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
        .paragraph(
          .init(
            text: [
              .text("Returns "),
              .code(.init("nil")),
              .text("."),
            ]
          )
        )
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
        .paragraph(
          .init(
            text: [
              .text("Returns "),
              .html(.init("<code>")),
              .text("nil"),
              .html(.init("</code>")),
              .text("."),
            ]
          )
        )
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
        .paragraph(
          .init(
            text: [
              .text("Hello "),
              .emphasis(.init(children: [.text("world")])),
              .text("."),
            ]
          )
        )
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
        .paragraph(
          .init(
            text: [
              .text("Hello "),
              .strong(.init(children: [.text("world")])),
              .text("."),
            ]
          )
        )
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
        .paragraph(
          .init(
            text: [
              .text("Hello "),
              .link(
                .init(
                  children: [.text("world")],
                  url: URL(string: "https://example.com")
                )
              ),
              .text("."),
            ]
          )
        )
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
        .paragraph(
          .init(
            text: [
              .text("Hello "),
              .image(.init("https://example.com/world.jpg", alt: "world")),
              .text("."),
            ]
          )
        )
      ],
      result
    )
  }

  func testCodable() throws {
    struct Model: Codable, Equatable {
      let markdownText: Document
    }

    // given
    let json = ##"{"markdownText":"# Hello *world*\n"}"##.data(using: .utf8)!
    let model = Model(
      markdownText: Document(
        blocks: [
          .heading(
            .init(
              text: [
                .text("Hello "),
                .emphasis(.init(children: [.text("world")])),
              ],
              level: 1
            )
          )
        ]
      )
    )

    // when
    let decoded = try JSONDecoder().decode(Model.self, from: json)
    let encoded = try JSONEncoder().encode(decoded)

    // then
    XCTAssertEqual(model, decoded)
    XCTAssertEqual(json, encoded)
  }
}

#if swift(>=5.4)
  extension DocumentTests {
    func testBuildEmptyDocument() {
      // when
      let result = Document {}

      // then
      XCTAssertEqual("\n", result.renderCommonMark())
      XCTAssertEqual("", result.renderHTML())
    }

    func testBuildDocument() {
      // when
      let result = Document {
        Heading {
          "Structured documents"
        }
        Paragraph {
          "Sometimes it's useful to have different levels of headings to structure your documents. "
          "Start lines with a "
          InlineCode("#")
          " to create headings. Multiple "
          InlineCode("##")
          " in a row denote smaller heading sizes."
        }
        Heading(level: 3) {
          "This is a third-tier heading"
        }
        Paragraph {
          "If you'd like to quote someone, use the > character before the line:"
        }
        BlockQuote {
          "Coffee. The finest organic suspension ever devised... I beat the Borg with it."
        }
        Paragraph {
          "It's very easy to make some words "
          Strong("bold")
          " and other words "
          Emphasis("italic")
          " with Markdown. You can even "
          Link("http://google.com") {
            "link to Google!"
          }
        }
        Paragraph {
          "Sometimes you want numbered lists:"
        }
        OrderedList(start: 1) {
          "One"
          "Two"
          "Three"
        }
        Paragraph {
          "Sometimes you want bullet points:"
        }
        BulletList {
          "Start a line with a star"
          "Profit!"
        }
        Paragraph {
          "If you want to embed images, this is how you do it:"
        }
        Paragraph {
          Image("https://octodex.github.com/images/yaktocat.png", alt: "Image of Yaktocat")
        }
        Paragraph {
          InlineHTML("<cite>")
          "The Scream"
          InlineHTML("</cite>")
          " by Edward Munch. Painted in 1893."
        }
        HTMLBlock {
          "<p>This is some text in a paragraph.</p>"
        }
      }

      // then
      XCTAssertEqual(
        #"""
        # Structured documents

        Sometimes it's useful to have different levels of headings to structure your documents. Start lines with a `#` to create headings. Multiple `##` in a row denote smaller heading sizes.

        ### This is a third-tier heading

        If you'd like to quote someone, use the \> character before the line:

        > Coffee. The finest organic suspension ever devised... I beat the Borg with it.

        It's very easy to make some words **bold** and other words *italic* with Markdown. You can even [link to Google\!](http://google.com)

        Sometimes you want numbered lists:

        1.  One
        2.  Two
        3.  Three

        Sometimes you want bullet points:

          - Start a line with a star
          - Profit\!

        If you want to embed images, this is how you do it:

        ![Image of Yaktocat](https://octodex.github.com/images/yaktocat.png)

        <cite>The Scream</cite> by Edward Munch. Painted in 1893.

        <p>This is some text in a paragraph.</p>

        """#,
        result.renderCommonMark()
      )
      XCTAssertEqual(
        #"""
        <h1>Structured documents</h1>
        <p>Sometimes it's useful to have different levels of headings to structure your documents. Start lines with a <code>#</code> to create headings. Multiple <code>##</code> in a row denote smaller heading sizes.</p>
        <h3>This is a third-tier heading</h3>
        <p>If you'd like to quote someone, use the &gt; character before the line:</p>
        <blockquote>
        <p>Coffee. The finest organic suspension ever devised... I beat the Borg with it.</p>
        </blockquote>
        <p>It's very easy to make some words <strong>bold</strong> and other words <em>italic</em> with Markdown. You can even <a href="http://google.com">link to Google!</a></p>
        <p>Sometimes you want numbered lists:</p>
        <ol>
        <li>One</li>
        <li>Two</li>
        <li>Three</li>
        </ol>
        <p>Sometimes you want bullet points:</p>
        <ul>
        <li>Start a line with a star</li>
        <li>Profit!</li>
        </ul>
        <p>If you want to embed images, this is how you do it:</p>
        <p><img src="https://octodex.github.com/images/yaktocat.png" alt="Image of Yaktocat" /></p>
        <p><cite>The Scream</cite> by Edward Munch. Painted in 1893.</p>
        <p>This is some text in a paragraph.</p>

        """#,
        result.renderHTML(options: .unsafe)
      )
    }
  }
#endif
