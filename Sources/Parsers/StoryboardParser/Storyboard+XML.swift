//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna

private enum XML {
  enum Scene {
    static let initialVCXPath = "/*/@initialViewController"
    static let targetRuntimeXPath = "/*/@targetRuntime"
    static func initialSceneXPath(identifier: String) -> String {
      return "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\" and @id=\"\(identifier)\"]"
    }
    static let sceneXPath = "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\"]"
    static let sceneSegueXPath = "//connections/segue"
    static let placeholderTag = "viewControllerPlaceholder"
    static let sceneIDAttribute = "id"
    static let customClassAttribute = "customClass"
    static let customModuleAttribute = "customModule"
    static let storyboardIdentifierAttribute = "storyboardIdentifier"
    static let storyboardNameAttribute = "storyboardName"
    static let referencedIdentifierAttribute = "referencedIdentifier"
  }
  enum Segue {
    static let segueXPath = "/document/scenes/scene//connections/segue[string(@identifier)]"
    static let identifierAttribute = "identifier"
    static let customClassAttribute = "customClass"
    static let customModuleAttribute = "customModule"
    static let destinationAttribute = "destination"
  }
}

extension Storyboard.Scene {
  init(with object: Kanna.XMLElement) {
    sceneID = object[XML.Scene.sceneIDAttribute] ?? ""
    identifier = object[XML.Scene.storyboardIdentifierAttribute] ?? ""
    tag = object.tagName ?? ""
    customClass = object[XML.Scene.customClassAttribute]
    customModule = object[XML.Scene.customModuleAttribute]
    segues = Set(object.xpath(XML.Scene.sceneSegueXPath).map {
      Storyboard.Segue(with: $0)
    })
  }
}

extension Storyboard.ScenePlaceholder {
  init(with object: Kanna.XMLElement, storyboard: String) {
    sceneID = object[XML.Scene.sceneIDAttribute] ?? ""
    storyboardName = object[XML.Scene.storyboardNameAttribute] ?? storyboard
    referencedIdentifier = object[XML.Scene.referencedIdentifierAttribute]
  }
}

extension Storyboard.Segue {
  init(with object: Kanna.XMLElement) {
    identifier = object[XML.Segue.identifierAttribute] ?? ""
    customClass = object[XML.Segue.customClassAttribute]
    customModule = object[XML.Segue.customModuleAttribute]
    destination = object[XML.Segue.destinationAttribute] ?? ""
  }
}

extension Storyboard {
  private static let platformMapping = [
    "AppleTV": "tvOS",
    "iOS.CocoaTouch": "iOS",
    "MacOSX.Cocoa": "macOS",
    "watchKit": "watchOS"
  ]

  init(with document: Kanna.XMLDocument, name: String) {
    self.name = name

    // Initial VC
    let initialSceneID = document.at_xpath(XML.Scene.initialVCXPath)?.text ?? ""
    if let object = document.at_xpath(XML.Scene.initialSceneXPath(identifier: initialSceneID)) {
      initialScene = Storyboard.Scene(with: object)
    } else {
      initialScene = nil
    }

    // Scenes
    var scenes = Set<Storyboard.Scene>()
    var placeholders = Set<Storyboard.ScenePlaceholder>()
    for node in document.xpath(XML.Scene.sceneXPath) {
      if node.tagName != XML.Scene.placeholderTag {
        scenes.insert(Storyboard.Scene(with: node))
      } else {
        placeholders.insert(Storyboard.ScenePlaceholder(with: node, storyboard: name))
      }
    }
    self.scenes = scenes
    self.placeholders = placeholders

    // Segues
    segues = Set<Storyboard.Segue>(document.xpath(XML.Segue.segueXPath).map {
      Storyboard.Segue(with: $0)
    })

    // TargetRuntime
    let targetRuntime = document.at_xpath(XML.Scene.targetRuntimeXPath)?.text ?? ""
    platform = Storyboard.platformMapping[targetRuntime] ?? targetRuntime
  }
}
