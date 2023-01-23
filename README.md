> **Warning**
>
> **This repo has been archived.**
>
> Consider using https://github.com/apple/swift-markdown if you need to parse and transform Markdown using Swift or
> https://github.com/gonzalezreal/swift-markdown-ui if you need to render Markdown in SwiftUI.

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
  OrderedList {
    "One"
    "Two"
    "Three"
  }
  Paragraph {
    "Sometimes you want bullet points:"
  }
  BulletList {
    ListItem {
      Paragraph {
        "Start a line with a "
        Strong("star")
      }
    }
    ListItem {
      "Profit!"
    }
    ListItem {
      "And you can have sub points:"
      BulletList {
        "Like this"
        "And this"
      }
    }
  }
}
```

You can inspect the elements of a `Document` by accessing its `blocks` property.

```swift
for block in document.blocks {
  switch block {
  case .blockQuote(let blockQuote):
    for item in blockQuote.items {
      // Inspect the item
    }
  case .bulletList(let bulletList):
    for item in bulletList.items {
      // Inspect the list item
    }
  case .orderedList(let orderedList):
    for item in orderedList.items {
      // Inspect the list item
    }
  case .code(let codeBlock):
    print(codeBlock.language)
    print(codeBlock.code)
  case .html(let htmlBlock):
    print(htmlBlock.html)
  case .paragraph(let paragraph):
    for inline in paragraph.text {
      // Inspect the inline
    }
  case .heading(let heading):
    print(heading.level)
    for inline in heading.text {
      // Inspect the inline
    }
  case .thematicBreak:
    // A thematic break
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
