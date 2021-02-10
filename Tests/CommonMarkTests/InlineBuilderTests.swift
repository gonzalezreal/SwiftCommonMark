import CommonMark
import XCTest

final class InlineBuilderTests: XCTestCase {
    func testBuildBlock() {
        // given
        @InlineBuilder func build() -> [Inline] {
            "Hello "
            Strong { "world!" }
        }

        // when
        let result = build()

        // then
        XCTAssertEqual(
            [
                .text("Hello "),
                .strong(
                    [.text("world!")]
                ),
            ],
            result
        )
    }

    func testBuildArray() {
        // given
        @InlineBuilder func build() -> [Inline] {
            for i in 0 ... 3 {
                "\(i) "
            }
        }

        // when
        let result = build()

        // then
        XCTAssertEqual(
            [
                .text("0 "),
                .text("1 "),
                .text("2 "),
                .text("3 "),
            ],
            result
        )
    }

    func testBuildOptional() {
        @InlineBuilder func build() -> [Inline] {
            "Something is "
            if true {
                Emphasis {
                    "true"
                }
            }
        }

        // when
        let result = build()

        // then
        XCTAssertEqual(
            [
                .text("Something is "),
                .emphasis(
                    [.text("true")]
                ),
            ],
            result
        )
    }

    func testBuildEither() {
        @InlineBuilder func build(_ value: Bool) -> [Inline] {
            "Something is "
            if value {
                Emphasis {
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
                .text("Something is "),
                .emphasis(
                    [.text("true")]
                ),
            ],
            result1
        )
        XCTAssertEqual(
            [
                .text("Something is "),
                .text("false"),
            ],
            result2
        )
    }
}
