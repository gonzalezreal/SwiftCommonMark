#if swift(>=5.4)
  import CommonMark
  import XCTest

  final class ItemArrayBuilderTests: XCTestCase {
    func testExpressions() {
      // given
      @ItemArrayBuilder func build() -> [[Block]] {
        "Flour"
        Item {
          "Cheese"
        }
        Item {
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
          [.paragraph(text: [.text("Flour")])],
          [.paragraph(text: [.text("Cheese")])],
          [.paragraph(text: [.text("Tomatoes")])],
        ],
        result
      )
    }

    func testForLoops() {
      // given
      @ItemArrayBuilder func build() -> [[Block]] {
        for i in 0...3 {
          "\(i)"
        }
      }

      // when
      let result = build()

      // then
      XCTAssertEqual(
        [
          [.paragraph(text: [.text("0")])],
          [.paragraph(text: [.text("1")])],
          [.paragraph(text: [.text("2")])],
          [.paragraph(text: [.text("3")])],
        ],
        result
      )
    }

    func testIf() {
      @ItemArrayBuilder func build() -> [[Block]] {
        "Something is:"
        if true {
          Item {
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
          [.paragraph(text: [.text("Something is:")])],
          [
            .blockQuote(
              items: [.paragraph(text: [.text("true")])]
            )
          ],
        ],
        result
      )
    }

    func testIfElse() {
      @ItemArrayBuilder func build(_ value: Bool) -> [[Block]] {
        "Something is:"
        if value {
          Item {
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
          [.paragraph(text: [.text("Something is:")])],
          [
            .blockQuote(
              items: [.paragraph(text: [.text("true")])]
            )
          ],
        ],
        result1
      )
      XCTAssertEqual(
        [
          [.paragraph(text: [.text("Something is:")])],
          [.paragraph(text: [.text("false")])],
        ],
        result2
      )
    }
  }
#endif
