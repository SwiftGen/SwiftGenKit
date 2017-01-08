//
//  FontsTests.swift
//  SwiftGenKit
//
//  Created by Derek Ostrander on 3/8/16.
//  Copyright © 2017 AliSoftware. All rights reserved.
//

import XCTest
import SwiftGenKit
import AppKit.NSFont

class FontsTests: XCTestCase {
  static let fonts: [[String: Any]] = [
    ["name": ".SF NS Display", "fonts": [["style": "Black", "fontName": ".SFNSDisplay-Black"], ["style": "Bold", "fontName": ".SFNSDisplay-Bold"], ["style": "Heavy", "fontName": ".SFNSDisplay-Heavy"], ["style": "Regular", "fontName": ".SFNSDisplay-Regular"]]],
    ["name": ".SF NS Text", "fonts": [["style": "Bold", "fontName": ".SFNSText-Bold"], ["style": "Heavy", "fontName": ".SFNSText-Heavy"], ["style": "Regular", "fontName": ".SFNSText-Regular"]]],
    ["name": "Avenir", "fonts": [["style": "Black", "fontName": "Avenir-Black"], ["style": "Black Oblique", "fontName": "Avenir-BlackOblique"], ["style": "Book", "fontName": "Avenir-Book"], ["style": "Book Oblique", "fontName": "Avenir-BookOblique"], ["style": "Heavy", "fontName": "Avenir-Heavy"], ["style": "Heavy Oblique", "fontName": "Avenir-HeavyOblique"], ["style": "Light", "fontName": "Avenir-Light"], ["style": "Light Oblique", "fontName": "Avenir-LightOblique"], ["style": "Medium", "fontName": "Avenir-Medium"], ["style": "Medium Oblique", "fontName": "Avenir-MediumOblique"], ["style": "Oblique", "fontName": "Avenir-Oblique"], ["style": "Roman", "fontName": "Avenir-Roman"]]],
    ["name": "Zapf Dingbats", "fonts": [["style": "Regular", "fontName": "ZapfDingbatsITC"]]]
  ]
  
  func testEmpty() {
    let parser = FontsFileParser()
    
    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "FontFamily",
      "families": [[String: Any]]()
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testDefaults() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory())

    let result = parser.stencilContext()
    let expected: [String: Any] = [
      "enumName": "FontFamily",
      "families": FontsTests.fonts
    ]
    
    XCTDiffContexts(result, expected)
  }

  func testCustomName() {
    let parser = FontsFileParser()
    parser.parseFile(at: Fixtures.directory())

    let result = parser.stencilContext(enumName: "CustomFamily")
    let expected: [String: Any] = [
      "enumName": "CustomFamily",
      "families": FontsTests.fonts
    ]
    
    XCTDiffContexts(result, expected)
  }
}
