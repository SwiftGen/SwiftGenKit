//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

protocol Typable {
  var platform: StoryboardParser.Platform { get }
  var tag: String { get }
  var customClass: String? { get }
  var customModule: String? { get }
  var klass: String { get }
}

extension Typable {
  var module: String {
    let defaultModule: String
    switch platform {
    case .iOS:
      defaultModule = "UIKit"
    case .macOS:
      defaultModule = "Cocoa"
    }
    return customModule ?? defaultModule
  }

  var type: String {
    return "\(module).\(klass)"
  }
}

protocol Element {
  associatedtype ElementType: Typable
  var identifier: String { get }
  var storyboardId: String { get }
  var type: ElementType { get }
}
