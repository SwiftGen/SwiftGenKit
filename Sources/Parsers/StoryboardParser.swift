//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Kanna
import PathKit

public final class StoryboardParser {
  struct InitialScene {
    let tag: String
    let customClass: String?
    let customModule: String?
  }

  struct Scene {
    let storyboardID: String
    let tag: String
    let customClass: String?
    let customModule: String?
  }

  struct Segue {
    let identifier: String
    let customClass: String?
    let customModule: String?
  }

  enum XMLScene {
    static let initialVCXPath = "/*/@initialViewController"
    static let sceneXPath = "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\"]"
    static let placeholderTag = "viewControllerPlaceholder"
    static let customClassAttribute = "customClass"
    static let customModuleAttribute = "customModule"
    static let idAttribute = "id"
    static let storyboardIdentifierAttribute = "storyboardIdentifier"
  }
  enum XMLSegue {
    static let segueXPath = "/document/scenes/scene//connections/segue[string(@identifier)]"
    static let identifierAttribute = "identifier"
    static let customClassAttribute = "customClass"
    static let customModuleAttribute = "customModule"
  }

  var initialScenes = [String: InitialScene]()
  var storyboardsScenes = [String: Set<Scene>]()
  var storyboardsSegues = [String: Set<Segue>]()
  var modules = Set<String>()

  public init() {}

  public func addStoryboard(at path: Path) throws {
    guard let document = Kanna.XML(xml: try path.read(), encoding: .utf8) else {
      throw ColorsParserError.invalidFile(reason: "Unknown XML parser error.")
    }

    let storyboardName = path.lastComponentWithoutExtension
    let initialSceneID = document.at_xpath(XMLScene.initialVCXPath)?.text
    var initialScene: InitialScene? = nil
    var scenes = Set<Scene>()
    var segues = Set<Segue>()

    for scene in document.xpath(XMLScene.sceneXPath) {
      guard scene.tagName != XMLScene.placeholderTag else { continue }

      let customClass = scene[XMLScene.customClassAttribute]
      let customModule = scene[XMLScene.customModuleAttribute]

      if scene[XMLScene.idAttribute] == initialSceneID {
        initialScene = InitialScene(tag: scene.tagName ?? "",
                                    customClass: customClass,
                                    customModule: customModule)
      }
      if let id = scene[XMLScene.storyboardIdentifierAttribute] {
        scenes.insert(Scene(storyboardID: id,
                            tag: scene.tagName ?? "",
                            customClass: customClass,
                            customModule: customModule))
      }
    }

    for segue in document.xpath(XMLSegue.segueXPath) {
      let id = segue[XMLSegue.identifierAttribute] ?? ""
      let customClass = segue[XMLSegue.customClassAttribute]
      let customModule = segue[XMLSegue.customModuleAttribute]

      segues.insert(Segue(identifier: id, customClass: customClass, customModule: customModule))
    }

    initialScenes[storyboardName] = initialScene
    storyboardsScenes[storyboardName] = scenes
    storyboardsSegues[storyboardName] = segues

    modules.formUnion(collectModules(initial: initialScene, scenes: scenes, segues: segues))
  }

  public func parseDirectory(at path: Path) throws {
    let iterator = path.makeIterator()

    while let subPath = iterator.next() {
      if subPath.extension == "storyboard" {
        try addStoryboard(at: subPath)
      }
    }
  }

  private func collectModules(initial: InitialScene?, scenes: Set<Scene>, segues: Set<Segue>) -> Set<String> {
    var result = Set<String>()

    if let module = initial?.customModule {
      result.insert(module)
    }
    result.formUnion(Set<String>(scenes.flatMap { $0.customModule }))
    result.formUnion(Set<String>(segues.flatMap { $0.customModule }))

    return result
  }
}

extension StoryboardParser.Scene: Equatable { }
func == (lhs: StoryboardParser.Scene, rhs: StoryboardParser.Scene) -> Bool {
  return lhs.storyboardID == rhs.storyboardID &&
    lhs.tag == rhs.tag &&
    lhs.customClass == rhs.customClass &&
    lhs.customModule == rhs.customModule
}

extension StoryboardParser.Scene: Hashable {
  var hashValue: Int {
    return storyboardID.hashValue ^ tag.hashValue ^ (customModule?.hashValue ?? 0) ^ (customClass?.hashValue ?? 0)
  }
}

extension StoryboardParser.Segue: Equatable { }
func == (lhs: StoryboardParser.Segue, rhs: StoryboardParser.Segue) -> Bool {
  return lhs.identifier == rhs.identifier &&
    lhs.customClass == rhs.customClass &&
    lhs.customModule == rhs.customModule
}

extension StoryboardParser.Segue: Hashable {
  var hashValue: Int {
    return identifier.hashValue ^ (customModule?.hashValue ?? 0) ^ (customClass?.hashValue ?? 0)
  }
}
