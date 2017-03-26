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
  
  enum XML {
    static let scenePath = "/document/scenes/scene/objects/*[@sceneMemberID=\"viewController\"]"
    static let seguePath = "/document/scenes/scene//connections/segue[string(@identifier)]"
  }

  var initialScenes = [String: InitialScene]()
  var storyboardsScenes = [String: Set<Scene>]()
  var storyboardsSegues = [String: Set<Segue>]()
  var modules = Set<String>()

  public init() {}

  public func addStoryboard(at path: Path) throws {
    let document = try Fuzi.XMLDocument(string: try path.read())

    let storyboardName = path.lastComponentWithoutExtension
    let initialSceneID = document.root?["initialViewController"]
    var initialScene: InitialScene? = nil
    var scenes = Set<Scene>()
    var segues = Set<Segue>()

    for scene in document.xpath(XML.scenePath) {
      guard scene.tag != "viewControllerPlaceholder" else { continue }

      let customClass = scene["customClass"]
      let customModule = scene["customModule"]

      if scene["id"] == initialSceneID {
        initialScene = InitialScene(tag: scene.tag ?? "",
                                    customClass: customClass,
                                    customModule: customModule)
      }
      if let id = scene["storyboardIdentifier"] {
        scenes.insert(Scene(storyboardID: id,
                            tag: scene.tag ?? "",
                            customClass: customClass,
                            customModule: customModule))
      }
    }

    for segue in document.xpath(XML.seguePath) {
      let id = segue["identifier"] ?? ""
      let customClass = segue["customClass"]
      let customModule = segue["customModule"]

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
