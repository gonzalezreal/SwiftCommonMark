#if swift(>=5.4)
    import CommonMark
    import XCTest

    final class ItemBuilderTests: XCTestCase {
        func testBuildItem() {
            // given
            @ItemBuilder func build() -> [Item] {
                "Hello"
                "world!"
            }

            // when
            let result = build()

            // then
            XCTAssertEqual(
                [
                    Item(
                        blocks: [
                            .paragraph(text: [.text("Hello")]),
                        ]
                    ),
                    Item(
                        blocks: [
                            .paragraph(text: [.text("world!")]),
                        ]
                    ),
                ],
                result
            )
        }

        func testBuildArray() {
            // given
            @ItemBuilder func build() -> [Item] {
                for i in 0 ... 3 {
                    "\(i)"
                }
            }

            // when
            let result = build()

            // then
            XCTAssertEqual(
                [
                    Item(
                        blocks: [
                            .paragraph(text: [.text("0")]),
                        ]
                    ),
                    Item(
                        blocks: [
                            .paragraph(text: [.text("1")]),
                        ]
                    ),
                    Item(
                        blocks: [
                            .paragraph(text: [.text("2")]),
                        ]
                    ),
                    Item(
                        blocks: [
                            .paragraph(text: [.text("3")]),
                        ]
                    ),
                ],
                result
            )
        }

        func testBuildOptional() {
            @ItemBuilder func build() -> [Item] {
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
                    Item(
                        blocks: [
                            .paragraph(text: [.text("Something is:")]),
                        ]
                    ),
                    Item(
                        blocks: [
                            .blockQuote(
                                items: [.paragraph(text: [.text("true")])]
                            ),
                        ]
                    ),
                ],
                result
            )
        }

        func testBuildEither() {
            @ItemBuilder func build(_ value: Bool) -> [Item] {
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
                    Item(
                        blocks: [
                            .paragraph(text: [.text("Something is:")]),
                        ]
                    ),
                    Item(
                        blocks: [
                            .blockQuote(
                                items: [.paragraph(text: [.text("true")])]
                            ),
                        ]
                    ),
                ],
                result1
            )
            XCTAssertEqual(
                [
                    Item(
                        blocks: [
                            .paragraph(text: [.text("Something is:")]),
                        ]
                    ),
                    Item(
                        blocks: [
                            .paragraph(text: [.text("false")]),
                        ]
                    ),
                ],
                result2
            )
        }
    }
#endif
