import CommonMark
import XCTest

final class BlockBuilderTests: XCTestCase {
    func testBuildBlock() {
        // given
        @BlockBuilder func build() -> [Block] {
            "Hello"
            "world!"
        }

        // when
        let result = build()

        // then
        XCTAssertEqual(
            [
                .paragraph([.text("Hello")]),
                .paragraph([.text("world!")]),
            ],
            result
        )
    }

    func testBuildArray() {
        // given
        @BlockBuilder func build() -> [Block] {
            for i in 0 ... 3 {
                "\(i)"
            }
        }

        // when
        let result = build()

        // then
        XCTAssertEqual(
            [
                .paragraph([.text("0")]),
                .paragraph([.text("1")]),
                .paragraph([.text("2")]),
                .paragraph([.text("3")]),
            ],
            result
        )
    }

    func testBuildOptional() {
        @BlockBuilder func build() -> [Block] {
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
                .paragraph([.text("Something is:")]),
                .blockQuote(
                    [.paragraph([.text("true")])]
                ),
            ],
            result
        )
    }

    func testBuildEither() {
        @BlockBuilder func build(_ value: Bool) -> [Block] {
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
                .paragraph([.text("Something is:")]),
                .blockQuote(
                    [.paragraph([.text("true")])]
                ),
            ],
            result1
        )
        XCTAssertEqual(
            [
                .paragraph([.text("Something is:")]),
                .paragraph([.text("false")]),
            ],
            result2
        )
    }
}
