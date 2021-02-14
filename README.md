# SwiftCommonMark
[![CI](https://github.com/gonzalezreal/SwiftCommonMark/workflows/CI/badge.svg)](https://github.com/gonzalezreal/SwiftCommonMark/actions?query=workflow%3ACI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalezreal%2FSwiftCommonMark%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/gonzalezreal/SwiftCommonMark)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalezreal%2FSwiftCommonMark%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/gonzalezreal/SwiftCommonMark)
[![contact: @gonzalezreal](https://img.shields.io/badge/contact-@gonzalezreal-blue.svg?style=flat)](https://twitter.com/gonzalezreal)

SwiftCommonMark is a library for parsing and creating Markdown documents in Swift, fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/). 

## Usage

You can create a `Document` by providing a CommonMark string.

```swift
let document = Document(
    #"""
    It's very easy to make some words **bold** and other words *italic* with Markdown.

    **Want to experiment with Markdown?** Play with the [reference CommonMark
    implementation](https://spec.commonmark.org/dingus/).
    """#
)
```

And access its abstract syntax tree via the `blocks` property.

```swift
for block in document.blocks {
    switch block {
    case let .blockQuote(blocks):
        // Inspect the nested blocks
    case let .list(list):
        print(list.style) // bullet or ordered
        print(list.spacing) // loose or tight
        for item in list.items {
            // Inspect item.blocks
        }
    case let .code(text, language):
        // A code block
    case let .html(content):
        // An HTML block
    case let .paragraph(inlines):
        // Inspect nested inlines
        for inline in inlines {
            switch inline {
            case let .text(text):
                // Plain text
            case .softBreak:
                // A soft break is usually replaced by a space
            case .lineBreak:
                // A line break
            case let .code(text):
                // Inline code
            case let .html(text):
                // Inline HTML
            case let .emphasis(inlines):
                // Emphasized inlines
            case let .strong(inlines):
                // Strong inlines
            case let .link(inlines, url, title):
                // A link
            case let .image(inlines, url, title):
                // An image
            }
        }
    case let .heading(inlines, level):
        // A heading with the specified level
    case .thematicBreak:
        // A thematic break
    }
}
```

The [MarkdownUI](https://github.com/gonzalezreal/MarkdownUI) library uses this technique to render a CommonMark `Document` into an `NSAttributedString`.

From Swift 5.4 onwards, you can create a `Document` in a type-safe manner using an embedded DSL.

```swift
let document = Document {
    Heading(level: 2) {
        "Markdown lists"
    }
    "Sometimes you want numbered lists:"
    List(start: 1) {
        "One"
        "Two"
        "Three"
    }
    "Sometimes you want bullet points:"
    List {
        "Start a line with a star"
        "Profit!"
        Item {
            "And you can have sub points:"
            List {
                "Like this"
                "And this"
            }
        }
    }
}
```

You can always get the CommonMark syntax of a document by accessing its `description`. For instance, calling `description` in the previous document:

```swift
print(document.description)
```

Produces the following output:

```
## Markdown lists

Sometimes you want numbered lists:

1.  One
2.  Two
3.  Three

Sometimes you want bullet points:

  - Start a line with a star
  - Profit\!
  - And you can have sub points:
      - Like this
      - And this

```

## Installation
You can add SwiftCommonMark to an Xcode project by adding it as a package dependency.
1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
1. Enter `https://github.com/gonzalezreal/SwiftCommonMark` into the package repository URL text field
1. Link **CommonMark** to your application target

## Other Libraries
- [SwiftDocOrg/CommonMark](https://github.com/SwiftDocOrg/CommonMark)
