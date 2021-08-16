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
                List(start: 1) {
                    Item { "One" }
                    Item {
                        "Two"
                        List(tight: false) {
                            "Two 1"
                            "Two 2"
                        }
                    }
                }
                // The tight parameter should be ignored because there are items with multiple paragraphs
                List(tight: true) {
                    Item {
                        "First paragraph."
                        "Second paragraph."
                    }
                    Item {
                        "Two"
                        List {
                            "Two 1"
                            "Two 2"
                        }
                    }
                }
                Code(language: "swift") {
                    """
                    let a = 5
                    let b = 42
                    """
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
                    .paragraph(text: [.text("This is the first paragraph.")]),
                    .paragraph(
                        text: [
                            .text("This is the "),
                            .strong(children: [.text("second")]),
                            .text(" paragraph."),
                        ]
                    ),
                    .blockQuote(
                        items: [
                            .paragraph(text: [.text("You say hello.")]),
                            .blockQuote(
                                items: [
                                    .paragraph(text: [.text("I say goodbye.")]),
                                ]
                            ),
                        ]
                    ),
                    .list(
                        items: [
                            [.paragraph(text: [.text("One")])],
                            [
                                .paragraph(text: [.text("Two")]),
                                .list(
                                    items: [
                                        [.paragraph(text: [.text("Two 1")])],
                                        [.paragraph(text: [.text("Two 2")])],
                                    ],
                                    tight: false
                                ),
                            ],
                        ],
                        type: .ordered(start: 1)
                    ),
                    .list(
                        items: [
                            [
                                .paragraph(text: [.text("First paragraph.")]),
                                .paragraph(text: [.text("Second paragraph.")]),
                            ],
                            [
                                .paragraph(text: [.text("Two")]),
                                .list(
                                    items: [
                                        [.paragraph(text: [.text("Two 1")])],
                                        [.paragraph(text: [.text("Two 2")])],
                                    ]
                                ),
                            ],
                        ],
                        tight: false
                    ),
                    .code(
                        text: "let a = 5\nlet b = 42\n",
                        info: "swift"
                    ),
                    .heading(text: [.text("Chapter 1")], level: 2),
                    .thematicBreak,
                ],
                result
            )
        }

        func testForLoops() {
            // given
            @BlockArrayBuilder func build() -> [Block] {
                for i in 0 ... 3 {
                    "\(i)"
                }
            }

            // when
            let result = build()

            // then
            XCTAssertEqual(
                [
                    .paragraph(text: [.text("0")]),
                    .paragraph(text: [.text("1")]),
                    .paragraph(text: [.text("2")]),
                    .paragraph(text: [.text("3")]),
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
                    .paragraph(text: [.text("Something is:")]),
                    .blockQuote(
                        items: [.paragraph(text: [.text("true")])]
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
                    .paragraph(text: [.text("Something is:")]),
                    .blockQuote(
                        items: [.paragraph(text: [.text("true")])]
                    ),
                ],
                result1
            )
            XCTAssertEqual(
                [
                    .paragraph(text: [.text("Something is:")]),
                    .paragraph(text: [.text("false")]),
                ],
                result2
            )
        }
    }
#endif
