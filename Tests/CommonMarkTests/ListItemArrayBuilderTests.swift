#if swift(>=5.4)
  import CommonMark
  import XCTest

  final class ListItemArrayBuilderTests: XCTestCase {
    func testExpressions() {
      // given
      @ListItemArrayBuilder func build() -> [ListItem] {
        "Flour"
        ListItem {
          "Cheese"
        }
        ListItem {
          Paragraph {
            "Tomatoes"
          }
        }
      }

      // when
      let result = build()

      // then
      XCTAssertEqual(
        [
          .init(blocks: [.paragraph(.init(text: [.text("Flour")]))]),
          .init(blocks: [.paragraph(.init(text: [.text("Cheese")]))]),
          .init(blocks: [.paragraph(.init(text: [.text("Tomatoes")]))]),
        ],
        result
      )
    }

    func testForLoops() {
      // given
      @ListItemArrayBuilder func build() -> [ListItem] {
        for i in 0...3 {
          "\(i)"
        }
      }

      // when
      let result = build()

      // then
      XCTAssertEqual(
        [
          .init(blocks: [.paragraph(.init(text: [.text("0")]))]),
          .init(blocks: [.paragraph(.init(text: [.text("1")]))]),
          .init(blocks: [.paragraph(.init(text: [.text("2")]))]),
          .init(blocks: [.paragraph(.init(text: [.text("3")]))]),
        ],
        result
      )
    }

    func testIf() {
      @ListItemArrayBuilder func build() -> [ListItem] {
        "Something is:"
        if true {
          ListItem {
            BlockQuote {
              "true"
            }
          }
        }
      }

      // when
      let result = build()

      // then
      XCTAssertEqual(
        [
          .init(blocks: [.paragraph(.init(text: [.text("Something is:")]))]),
          .init(
            blocks: [
              .blockQuote(
                .init(
                  items: [.paragraph(.init(text: [.text("true")]))]
                )
              )
            ]
          ),
        ],
        result
      )
    }

    func testIfElse() {
      @ListItemArrayBuilder func build(_ value: Bool) -> [ListItem] {
        "Something is:"
        if value {
          ListItem {
            BlockQuote {
              "true"
            }
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
          .init(blocks: [.paragraph(.init(text: [.text("Something is:")]))]),
          .init(
            blocks: [
              .blockQuote(
                .init(
                  items: [.paragraph(.init(text: [.text("true")]))]
                )
              )
            ]
          ),
        ],
        result1
      )
      XCTAssertEqual(
        [
          .init(blocks: [.paragraph(.init(text: [.text("Something is:")]))]),
          .init(blocks: [.paragraph(.init(text: [.text("false")]))]),
        ],
        result2
      )
    }
  }
#endif
