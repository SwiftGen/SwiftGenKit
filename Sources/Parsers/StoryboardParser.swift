//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import Fuzi
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
    static let path = "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\"]"
    static let placeholderTag = "viewControllerPlaceholder"
    static let customClassAttribute = "customClass"
    static let customModuleAttribute = "customModule"
    static let idAttribute = "id"
    static let initialVCAttribute = "initialViewController"
    static let storyboardIdentifierAttribute = "storyboardIdentifier"
  }
  enum XMLSegue {
    static let path = "/document/scenes/scene//connections/segue[string(@identifier)]"
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
    let document = try Fuzi.XMLDocument(string: try path.read())

    let storyboardName = path.lastComponentWithoutExtension
    let initialSceneID = document.root?[XMLScene.initialVCAttribute]
    var initialScene: InitialScene? = nil
    var scenes = Set<Scene>()
    var segues = Set<Segue>()

    for scene in document.xpath(XMLScene.path) {
      guard scene.tag != XMLScene.placeholderTag else { continue }

      let customClass = scene[XMLScene.customClassAttribute]
      let customModule = scene[XMLScene.customModuleAttribute]

      if scene[XMLScene.idAttribute] == initialSceneID {
        initialScene = InitialScene(tag: scene.tag ?? "",
                                    customClass: customClass,
                                    customModule: customModule)
      }
      if let id = scene[XMLScene.storyboardIdentifierAttribute] {
        scenes.insert(Scene(storyboardID: id,
                            tag: scene.tag ?? "",
                            customClass: customClass,
                            customModule: customModule))
      }
    }

    for segue in document.xpath(XMLSegue.path) {
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
