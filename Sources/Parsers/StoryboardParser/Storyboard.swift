//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

struct Storyboard {
  struct Scene {
    let sceneID: String
    let identifier: String
    let tag: String
    let customClass: String?
    let customModule: String?
    let segues: Set<Segue>
  }

  struct ScenePlaceholder {
    let sceneID: String
    let storyboardName: String
    let referencedIdentifier: String?
  }

  struct Segue {
    let identifier: String
    let customClass: String?
    let customModule: String?
    let destination: String
  }

  let name: String
  let platform: String
  let initialScene: Scene?
  let scenes: Set<Scene>
  let segues: Set<Segue>
  let placeholders: Set<ScenePlaceholder>
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
