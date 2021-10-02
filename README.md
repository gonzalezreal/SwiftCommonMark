# SwiftCommonMark
[![CI](https://github.com/gonzalezreal/SwiftCommonMark/workflows/CI/badge.svg)](https://github.com/gonzalezreal/SwiftCommonMark/actions?query=workflow%3ACI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalezreal%2FSwiftCommonMark%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/gonzalezreal/SwiftCommonMark)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fgonzalezreal%2FSwiftCommonMark%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/gonzalezreal/SwiftCommonMark)
[![contact: @gonzalezreal](https://img.shields.io/badge/contact-@gonzalezreal-blue.svg?style=flat)](https://twitter.com/gonzalezreal)

SwiftCommonMark is a library for parsing and creating Markdown documents in Swift, fully compliant with the [CommonMark Spec](https://spec.commonmark.org/current/). 

## Usage

A CommonMark `Document` consists of a sequence of blocks—structural elements like paragraphs,
block quotations, lists, headings, rules, and code blocks. Some blocks, like blockquotes and
list items, contain other blocks; others, like headings and paragraphs, contain inline text,
links, emphasized text, images, code spans, etc.

You can create a `Document` by passing a CommonMark-formatted `String` or `Data` instance to
initializers like `init(markdown:options:)`.

You can create a `Document` by providing a CommonMark string.

```swift
do {
  let document = try Document(
    markdown: "You can try **CommonMark** [here](https://spec.commonmark.org/dingus/)."
  )
} catch {
  print("Couldn't parse document.")
}
```

From Swift 5.4 onwards, you can create a `Document` by passing an array of `Block`s 
constructed with a `BlockArrayBuilder`.

```swift
let document = Document {
  Heading(level: 2) {
    "Markdown lists"
  }
  Paragraph {
    "Sometimes you want numbered lists:"
  }
  List(start: 1) {
    "One"
    "Two"
    "Three"
  }
  Paragraph {
    "Sometimes you want bullet points:"
  }
  List {
    Item {
      Paragraph {
        "Start a line with a "
        Strong("star")
      }
    }
    Item {
      "Profit!"
    }
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

You can inspect the elements of a `Document` by accessing its `blocks` property.

```swift
document.blocks.forEach { block in
  switch block {
  case .blockQuote(let items):
    items.forEach { block in
      // Inspect blockQuote's blocks
    }
  case .list(let items, let type, let tight):
    print(type)  // `.bullet` or `.ordered(Int)`
    print("is tight: \(tight)")  // `false` for loose lists
    items.forEach { blocks in
      // Inspect each item's block sequence
    }
  case .code(let text, let info):
    print(text)  // The code block text
    print(info ?? "")  // Typically used to specify the language of the code block
  case .html(let text):
    print(text)  // Raw HTML
  case .paragraph(let text):
    text.forEach { inline in
      // Inspect the paragraph's inlines
      switch inline {
      case .text(let text):
        print(text)  // Plain text
      case .softBreak:
        print("Soft line break")
      case .lineBreak:
        print("Hard line break")
      case .code(let text):
        print(text)  // Code span
      case .html(let text):
        print(text)  // Inline HTML
      case .emphasis(let children):
        children.forEach { inline in
          // Inspect emphasized inlines
        }
      case .strong(let children):
        children.forEach { inline in
          // Inspect strong emphasized inlines
        }
      case .link(let children, let url, let title):
        print(url?.absoluteString ?? "")  // The link URL
        print(title ?? "")  // Optional link title
        children.forEach { inline in
          // Inspect the link contents
        }
      case .image(let children, let url, let title):
        print(url?.absoluteString ?? "")  // The image URL
        print(title ?? "")  // Optional image title
      }
    }
  case .heading(let text, let level):
    print(level)  // The heading level
    text.forEach { inline in
      // Inspect the header's inlines
    }
  case .thematicBreak:
    print("A thematic break")
  }
}
```

You can get back the CommonMark formatted text for a `Document` or render it as HTML.

```swift
let markdown = document.renderCommonMark()
let html = document.renderHTML()
```

## Installation
You can add SwiftCommonMark to an Xcode project by adding it as a package dependency.
1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
1. Enter `https://github.com/gonzalezreal/SwiftCommonMark` into the package repository URL text field
1. Link **CommonMark** to your application target

## Other Libraries
- [SwiftDocOrg/CommonMark](https://github.com/SwiftDocOrg/CommonMark)
