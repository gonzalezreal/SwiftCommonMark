default: test build_watchOS

test:
	swift test

build_watchOS:
	xcodebuild \
			-scheme SwiftCommonMark-watchOS \
			-destination 'generic/platform=watchOS'

format:
	swift format --in-place --recursive .

.PHONY: format
