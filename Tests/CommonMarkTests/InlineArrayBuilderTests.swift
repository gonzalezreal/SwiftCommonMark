#if swift(>=5.4)
    import CommonMark
    import XCTest

    final class InlineArrayBuilderTests: XCTestCase {
        func testExpressions() {
            // given
            @InlineArrayBuilder func build() -> [Inline] {
                "Hello"
                SoftBreak()
                "world!"
                LineBreak()
                Code("let a = b")
                Strong {
                    "Everyone "
                    Emphasis("must")
                    " attend the meeting at 5 o’clock today."
                }
                Link("https://w.wiki/qYn") {
                    "Hurricane"
                }
                " Erika was the strongest and longest-lasting tropical cyclone in the 1997 Atlantic "
                Link("https://w.wiki/qYn") {
                    "hurricane"
                }
                " season."
                Image("https://commonmark.org/help/images/favicon.png", alt: "CommonMark")
            }

            // when
            let result = build()

            // then
            XCTAssertEqual(
                [
                    .text("Hello"),
                    .softBreak,
                    .text("world!"),
                    .lineBreak,
                    .code("let a = b"),
                    .strong(
                        children: [
                            .text("Everyone "),
                            .emphasis(
                                children: [
                                    .text("must"),
                                ]
                            ),
                            .text(" attend the meeting at 5 o’clock today."),
                        ]
                    ),
                    .link(children: [.text("Hurricane")], url: URL(string: "https://w.wiki/qYn")!),
                    .text(" Erika was the strongest and longest-lasting tropical cyclone in the 1997 Atlantic "),
                    .link(children: [.text("hurricane")], url: URL(string: "https://w.wiki/qYn")!),
                    .text(" season."),
                    .image(
                        children: [.text("CommonMark")],
                        url: URL(string: "https://commonmark.org/help/images/favicon.png")!
                    ),
                ],
                result
            )
        }

        func testForLoops() {
            // given
            @InlineArrayBuilder func build() -> [Inline] {
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

        func testIf() {
            @InlineArrayBuilder func build() -> [Inline] {
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
                        children: [.text("true")]
                    ),
                ],
                result
            )
        }

        func testIfElse() {
            @InlineArrayBuilder func build(_ value: Bool) -> [Inline] {
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
                        children: [.text("true")]
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
#endif
