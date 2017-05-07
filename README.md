# SwiftGenKit

[![CircleCI](https://circleci.com/gh/SwiftGen/SwiftGenKit/tree/master.svg?style=svg)](https://circleci.com/gh/SwiftGen/SwiftGenKit/tree/master)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwiftGenKit.svg)](https://img.shields.io/cocoapods/v/SwiftGenKit.svg)
[![Platform](https://img.shields.io/cocoapods/p/SwiftGenKit.svg?style=flat)](http://cocoadocs.org/docsets/SwiftGenKit)
![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg)

This is the framework behind _SwiftGen_, responsible for parsing various resources and turning them into Stencil contexts.

## Context

This framework contains various resource parsers (especially parsers for images, Localizable strings files, fonts, color palettes, storyboards, …) which are responsible for providing a dictionary representation of those resources suitable to be used by a template engine like [Stencil](https://github.com/kylef/Stencil).

The goal of this framework is to be used by Code Generation tools like SwiftGen to turn those resources into some internal representation that can then be used to generate custom code from it.

## Documentation

Each parser provided by this framework has a corresponding documentation file explaining the expected input and the format of the generated output, so you can know how to exploit it:

* [Assets](Documentation/Assets.md)
* [Colors](Documentation/Colors.md)
* [Fonts](Documentation/Fonts.md)
* [Storyboards](Documentation/Storyboards.md)
* [Strings](Documentation/Strings.md) 
