#if swift(>=5.4)
  import CommonMark
  import XCTest

  final class BlockArrayBuilderTests: XCTestCase {
    func testExpressions() {
      // given
      @BlockArrayBuilder func build() -> [Block] {
        "This is the first paragraph."
        Paragraph {
          "This is the "
          Strong("second")
          " paragraph."
        }
        BlockQuote {
          "You say hello."
          BlockQuote {
            "I say goodbye."
          }
        }
        OrderedList(start: 1) {
          ListItem { "One" }
          ListItem {
            "Two"
            BulletList(tight: false) {
              "Two 1"
              "Two 2"
            }
          }
        }
        // The tight parameter should be ignored because there are items with multiple paragraphs
        BulletList(tight: true) {
          ListItem {
            "First paragraph."
            "Second paragraph."
          }
          ListItem {
            "Two"
            BulletList {
              "Two 1"
              "Two 2"
            }
          }
        }
        CodeBlock(language: "swift") {
          """
          let a = 5
          let b = 42
          """
        }
        HTMLBlock {
          "<p>Hello world!</p>"
        }
        Heading(level: 2) {
          "Chapter 1"
        }
        ThematicBreak()
      }

      // when
      let result = build()

      // then
      XCTAssertEqual(
        [
          .paragraph(.init(text: [.text("This is the first paragraph.")])),
          .paragraph(
            .init(
              text: [
                .text("This is the "),
                .strong(.init(children: [.text("second")])),
                .text(" paragraph."),
              ]
            )
          ),
          .blockQuote(
            .init(
              items: [
                .paragraph(.init(text: [.text("You say hello.")])),
                .blockQuote(
                  .init(
                    items: [
                      .paragraph(.init(text: [.text("I say goodbye.")]))
                    ]
                  )
                ),
              ]
            )
          ),
          .orderedList(
            .init(
              items: [
                .init(blocks: [.paragraph(.init(text: [.text("One")]))]),
                .init(
                  blocks: [
                    .paragraph(.init(text: [.text("Two")])),
                    .bulletList(
                      .init(
                        items: [
                          .init(blocks: [.paragraph(.init(text: [.text("Two 1")]))]),
                          .init(blocks: [.paragraph(.init(text: [.text("Two 2")]))]),
                        ],
                        tight: false
                      )
                    ),
                  ]
                ),
              ],
              start: 1,
              tight: true
            )
          ),
          .bulletList(
            .init(
              items: [
                .init(
                  blocks: [
                    .paragraph(.init(text: [.text("First paragraph.")])),
                    .paragraph(.init(text: [.text("Second paragraph.")])),
                  ]
                ),
                .init(
                  blocks: [
                    .paragraph(.init(text: [.text("Two")])),
                    .bulletList(
                      .init(
                        items: [
                          .init(blocks: [.paragraph(.init(text: [.text("Two 1")]))]),
                          .init(blocks: [.paragraph(.init(text: [.text("Two 2")]))]),
                        ],
                        tight: true
                      )
                    ),
                  ]
                ),
              ],
              tight: false
            )
          ),
          .code(.init(language: "swift", code: { "let a = 5\nlet b = 42" })),
          .html(.init(html: "<p>Hello world!</p>")),
          .heading(.init(text: [.text("Chapter 1")], level: 2)),
          .thematicBreak,
        ],
        result
      )
    }

    func testForLoops() {
      // given
      @BlockArrayBuilder func build() -> [Block] {
        for i in 0...3 {
          "\(i)"
        }
      }

      // when
      let result = build()

      // then
      XCTAssertEqual(
        [
          .paragraph(.init(text: [.text("0")])),
          .paragraph(.init(text: [.text("1")])),
          .paragraph(.init(text: [.text("2")])),
          .paragraph(.init(text: [.text("3")])),
        ],
        result
      )
    }

    func testIf() {
      @BlockArrayBuilder func build() -> [Block] {
        "Something is:"
        if true {
          BlockQuote {
            "true"
          }
        }
      }

      // when
      let result = build()

      // then
      XCTAssertEqual(
        [
          .paragraph(.init(text: [.text("Something is:")])),
          .blockQuote(
            .init(
              items: [.paragraph(.init(text: [.text("true")]))]
            )
          ),
        ],
        result
      )
    }

    func testIfElse() {
      @BlockArrayBuilder func build(_ value: Bool) -> [Block] {
        "Something is:"
        if value {
          BlockQuote {
            "true"
          }
        } else {
          "false"
        }
      }

      // when
      let result1 = build(true)
      let result2 = build(false)

      // then
      XCTAssertEqual(
        [
          .paragraph(.init(text: [.text("Something is:")])),
          .blockQuote(
            .init(
              items: [.paragraph(.init(text: [.text("true")]))]
            )
          ),
        ],
        result1
      )
      XCTAssertEqual(
        [
          .paragraph(.init(text: [.text("Something is:")])),
          .paragraph(.init(text: [.text("false")])),
        ],
        result2
      )
    }
  }
#endif
