//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

private func uppercaseFirst(_ string: String) -> String {
  guard let first = string.characters.first else {
    return string
  }
  return String(first).uppercased() + String(string.characters.dropFirst())
}

/*
 - `sceneEnumName`: `String`
 - `segueEnumName`: `String`
 - `modules`: `Array` of `String`
 - `storyboards`: `Array` of:
    - `name`: `String`
    - `initialScene`: `Dictionary` (absent if not specified)
       - `customClass`: `String` (absent if generic UIViewController/NSViewController)
       - `isBaseViewController`: `Bool`, indicate if the baseType is 'viewController' or anything else
       - `baseType`: `String` (absent if class is a custom class).
          The base class type on which the initial scene is base.
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `scenes`: `Array` (absent if empty)
       - `identifier`: `String`
       - `customClass`: `String` (absent if generic UIViewController/NSViewController)
       - `isBaseViewController`: `Bool`, indicate if the baseType is 'ViewController' or anything else
       - `baseType`: `String` (absent if class is a custom class). The base class type on which a scene is base.
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `segues`: `Array` (absent if empty)
       - `identifier`: `String`
       - `class`: `String` (absent if generic UIStoryboardSegue)
*/
extension StoryboardParser {
  public func stencilContext(sceneEnumName: String = "StoryboardScene",
                             segueEnumName: String = "StoryboardSegue") -> [String: Any] {
    let storyboards = Set(storyboardsScenes.keys).union(storyboardsSegues.keys).sorted(by: <)
    let storyboardsMap = storyboards.map { (storyboardName: String) -> [String:Any] in
      var sbMap: [String:Any] = ["name": storyboardName]
      // Initial Scene
      if let initialScene = initialScenes[storyboardName] {
        sbMap["initialScene"] = map(initialScene: initialScene)
      }
      // All Scenes
      if let scenes = storyboardsScenes[storyboardName] {
        sbMap["scenes"] = scenes
          .sorted(by: {$0.storyboardID < $1.storyboardID})
          .map(map(scene:))
      }
      // All Segues
      if let segues = storyboardsSegues[storyboardName] {
        sbMap["segues"] = segues
          .sorted(by: {$0.identifier < $1.identifier})
          .map(map(segue:))
      }
      return sbMap
    }
    return [
      "storyboards": storyboardsMap,
      "modules": modules.sorted(),
      "param": [
        "sceneEnumName": sceneEnumName,
        "segueEnumName": segueEnumName
      ],

      // NOTE: This is a deprecated variable
      "extraImports": modules.sorted(),
      "sceneEnumName": sceneEnumName,
      "segueEnumName": segueEnumName
    ]
  }

  private func map(initialScene scene: InitialScene) -> [String: Any] {
    if let customClass = scene.customClass {
      return [
        "customClass": customClass,
        "customModule": scene.customModule ?? ""
      ]
    } else {
      return [
        "baseType": uppercaseFirst(scene.tag),

        // NOTE: This is a deprecated variable
        "isBaseViewController": scene.tag == "viewController"
      ]
    }
  }

  private func map(scene: Scene) -> [String: Any] {
    if let customClass = scene.customClass {
      return [
        "identifier": scene.storyboardID,
        "customClass": customClass,
        "customModule": scene.customModule ?? ""
      ]
    } else if scene.tag == "viewController" {
      return [
        "identifier": scene.storyboardID,
        "baseType": uppercaseFirst(scene.tag),

        // NOTE: This is a deprecated variable
        "isBaseViewController": scene.tag == "viewController"
      ]
    } else {
      return [
        "identifier": scene.storyboardID,
        "baseType": uppercaseFirst(scene.tag)
      ]
    }
  }

  private func map(segue: Segue) -> [String: Any] {
    return [
      "identifier": segue.identifier,
      "customClass": segue.customClass ?? ""
    ]
  }
}
