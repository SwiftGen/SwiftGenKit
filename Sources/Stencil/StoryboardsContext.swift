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
  // swiftlint:disable function_body_length
  public func stencilContext(sceneEnumName: String = "StoryboardScene",
                             segueEnumName: String = "StoryboardSegue") -> [String: Any] {
    let storyboards = Set(storyboardFiles.keys).sorted(by: <)
    let storyboardsMap = storyboards.map { (storyboardName: String) -> [String:Any] in

      let allScenes: Set<StoryboardParser.Scene> = storyboardFiles.values
        .reduce(Set<StoryboardParser.Scene>()) {
          return $0.union(Set<StoryboardParser.Scene>($1))
      }

      let sceneIdClassDict: [String:  String] = allScenes
        .reduce([String: String]()) { previous, next -> [String: String] in
          var dict: [String:String] = previous
          dict[next.identifier] = next.type.type
          return dict
      }

      var segueDestinationClasseDict: [String: String] = segueDestinationIds
        .reduce([String: String]()) { previous, next -> [String: String] in
          var dict: [String:String] = previous
          dict[next] = sceneIdClassDict[next]
          return dict
      }

      let dict = NSDictionary(dictionary: segueDestinationClasseDict)
      let success = dict.write(toFile: "/Users/carlos/Desktop/DeSwiftGenKit/salida.plist", atomically: true)
      print("success: \(success)")

      var sbMap: [String:Any] = ["name": storyboardName]
      // All Storyboards
      if let storyboard = storyboardFiles[storyboardName] {

        // Initial Scene
        if let initialScene = storyboard.first(where: { $0.isInitial == true }) {
          let initial: [String:Any]
          if let customClass = initialScene.type.customClass {
            initial = ["customClass": customClass, "customModule": initialScene.type.customModule ?? ""]
          } else {
            initial = [
              "baseType": uppercaseFirst(initialScene.type.tag),
              // NOTE: This is a deprecated variable
              "isBaseViewController": initialScene.type.tag == "viewController"
            ]
          }
          sbMap["initialScene"] = initial
        }

        // All Scenes
        sbMap["scenes"] = storyboard
          .filter { $0.storyboardId != "" }
          .sorted(by: {$0.storyboardId < $1.storyboardId})
          .map { (scene: Scene) -> [String:Any] in
            if let customClass = scene.type.customClass {
              return [
                "identifier": scene.storyboardId,
                "customClass": customClass,
                "customModule": scene.type.customModule ?? ""
              ]
            } else if scene.type.tag == "viewController" {
              return [
                "identifier": scene.storyboardId,
                "baseType": uppercaseFirst(scene.type.tag),

                // NOTE: This is a deprecated variable
                "isBaseViewController": scene.type.tag == "viewController"
              ]
            }
            return ["identifier": scene.storyboardId, "baseType": uppercaseFirst(scene.type.tag)]
        }

        // All Segues
        let allSegues = storyboard
          .map { (scene: Scene) -> Set<Segue> in scene.segues }
          .reduce(Set<Segue>()) { $0.union($1) }
          .filter { $0.storyboardId != "" }
          .reduce(Set<Segue>()) { (previous: Set<Segue>, next: Segue) -> Set<Segue> in
            let notInPrevious = previous
              .filter { $0.storyboardId == next.storyboardId }
              .isEmpty
            if notInPrevious {
              var previousSet = previous
              previousSet.insert(next)
              return previousSet
            }
            return previous
          }

        sbMap["segues"] = allSegues
          .sorted(by: {$0.storyboardId < $1.storyboardId})
          .map { (segue: Segue) -> [String:String] in
            ["identifier": segue.storyboardId, "customClass": segue.type.customClass ?? ""]
        }
      }

      return sbMap
    }

    return [
      "sceneEnumName": sceneEnumName,
      "segueEnumName": segueEnumName,
      "storyboards": storyboardsMap,
      "modules": modules.sorted(),

      // NOTE: This is a deprecated variable
      "extraImports": modules.sorted()
    ]
  }
  // swiftlint:enable function_body_length
}
