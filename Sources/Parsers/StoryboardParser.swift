//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

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

struct Storyboard {
  struct Scene {
    let sceneID: String
    let identifier: String
    let tag: String
    let customClass: String?
    let customModule: String?
    let segues: Set<Segue>

    init(with object: Kanna.XMLElement) {
      sceneID = object[XML.Scene.sceneIDAttribute] ?? ""
      identifier = object[XML.Scene.storyboardIdentifierAttribute] ?? ""
      tag = object.tagName ?? ""
      customClass = object[XML.Scene.customClassAttribute]
      customModule = object[XML.Scene.customModuleAttribute]
      segues = Set(object.xpath(XML.Scene.sceneSegueXPath).map {
        Segue(with: $0)
      })
    }
  }

  struct ScenePlaceholder {
    let sceneID: String
    let storyboardName: String
    let referencedIdentifier: String?

    init(with object: Kanna.XMLElement, storyboard: String) {
      sceneID = object[XML.Scene.sceneIDAttribute] ?? ""
      storyboardName = object[XML.Scene.storyboardNameAttribute] ?? storyboard
      referencedIdentifier = object[XML.Scene.referencedIdentifierAttribute]
    }
  }

  struct Segue {
    let identifier: String
    let customClass: String?
    let customModule: String?
    let destination: String

    init(with object: Kanna.XMLElement) {
      identifier = object[XML.Segue.identifierAttribute] ?? ""
      customClass = object[XML.Segue.customClassAttribute]
      customModule = object[XML.Segue.customModuleAttribute]
      destination = object[XML.Segue.destinationAttribute] ?? ""
    }
  }

  let name: String
  let platform: String
  let initialScene: Scene?
  let scenes: Set<Scene>
  let segues: Set<Segue>
  let placeholders: Set<ScenePlaceholder>
}

public final class StoryboardParser: Parser {
  var storyboards = [Storyboard]()
  public var warningHandler: Parser.MessageHandler?

  public init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }

  public func parse(path: Path) throws {
    if path.extension == "storyboard" {
      try addStoryboard(at: path)
    } else {
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])

      for file in dirChildren where file.extension == "storyboard" {
        try addStoryboard(at: file)
      }
    }
  }

  func addStoryboard(at path: Path) throws {
    guard let document = Kanna.XML(xml: try path.read(), encoding: .utf8) else {
      throw ColorsParserError.invalidFile(path: path, reason: "Unknown XML parser error.")
    }
    let name = path.lastComponentWithoutExtension

    // Initial VC
    let initialSceneID = document.at_xpath(XML.Scene.initialVCXPath)?.text ?? ""
    var initialScene: Storyboard.Scene? = nil
    if let object = document.at_xpath(XML.Scene.initialSceneXPath(identifier: initialSceneID)) {
      initialScene = Storyboard.Scene(with: object)
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

    // Segues
    let segues = Set<Storyboard.Segue>(document.xpath(XML.Segue.segueXPath).map {
      Storyboard.Segue(with: $0)
    })

    // TargetRuntime
    let mapping = [
      "AppleTV": "tvOS",
      "iOS.CocoaTouch": "iOS",
      "MacOSX.Cocoa": "macOS",
      "watchKit": "watchOS"
    ]
    let targetRuntime = document.at_xpath(XML.Scene.targetRuntimeXPath)?.text ?? ""
    let platform = mapping[targetRuntime] ?? targetRuntime

    storyboards += [Storyboard(name: name,
                               platform: platform,
                               initialScene: initialScene,
                               scenes: scenes,
                               segues: segues,
                               placeholders: placeholders)]
  }

  var modules: Set<String> {
    return Set<String>(storyboards.flatMap(collectModules(from:)))
  }

  private func collectModules(from storyboard: Storyboard) -> [String] {
    var result: [String] = storyboard.scenes.flatMap { $0.customModule } +
      storyboard.segues.flatMap { $0.customModule }

    if let module = storyboard.initialScene?.customModule {
      result += [module]
    }

    return result
  }

  var platform: String? {
    let platforms = Set<String>(storyboards.map { $0.platform })

    if platforms.count > 1 {
      return nil
    } else {
      return platforms.first
    }
  }

  func destination(for sceneID: String, in storyboard: Storyboard) -> Storyboard.Scene? {
	// directly to a scene
    if let scene = storyboard.scenes.first(where: { $0.sceneID == sceneID }) {
      return scene
    }

    // to a scene placeholder
    if let placeholder = storyboard.placeholders.first(where: { $0.sceneID == sceneID }),
      let storyboard = storyboards.first(where: { $0.name == placeholder.storyboardName }) {

      // can be either a scene by identifier, or the initial scene
      if let referencedIdentifier = placeholder.referencedIdentifier,
        let scene = storyboard.scenes.first(where: { $0.identifier == referencedIdentifier }) {
        return scene
      } else if placeholder.referencedIdentifier == nil {
        return storyboard.initialScene
      }
    }

    return nil
  }
}

extension Storyboard.Scene: Equatable { }
func == (lhs: Storyboard.Scene, rhs: Storyboard.Scene) -> Bool {
  return lhs.sceneID == rhs.sceneID
}

extension Storyboard.Scene: Hashable {
  var hashValue: Int {
    return sceneID.hashValue
  }
}

extension Storyboard.ScenePlaceholder: Equatable { }
func == (lhs: Storyboard.ScenePlaceholder, rhs: Storyboard.ScenePlaceholder) -> Bool {
  return lhs.sceneID == rhs.sceneID
}

extension Storyboard.ScenePlaceholder: Hashable {
  var hashValue: Int {
    return sceneID.hashValue
  }
}

extension Storyboard.Segue: Equatable { }
func == (lhs: Storyboard.Segue, rhs: Storyboard.Segue) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.customClass == rhs.customClass &&
    lhs.customModule == rhs.customModule
}

extension Storyboard.Segue: Hashable {
  var hashValue: Int {
    return identifier.hashValue ^ (customModule?.hashValue ?? 0) ^ (customClass?.hashValue ?? 0)
  }
}
