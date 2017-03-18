//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum StoryboardParserError: Error, CustomStringConvertible {
  case popoverPresentationSegueWithoutAnchorView
  case unwindSegueWithoutUnwindAction
  case relationshipSegueWithoutRelationship

  public var description: String {
    switch self {
    case .popoverPresentationSegueWithoutAnchorView:
      return "Invalid storyboard file: A popoverPresentation type segue without "
    case .unwindSegueWithoutUnwindAction:
      return "Invalid strings file"
    case .relationshipSegueWithoutRelationship:
      return "Invalid strings file"
    }
  }
}

// swiftlint:disable type_body_length
public final class StoryboardParser {
  var storyboardFiles = [String: Set<Scene>]()
  var segueDestinationIds = Set<String>()
  var modules = Set<String>()

  public var storyboardFilesDict: [String:Any] {
    var dict = [String: Any]()
    for (key, value) in storyboardFiles {
      dict[key] = value.map { $0.dictionary }
    }
    return dict
  }

  public struct Scene: Element {
    let identifier: String
    let storyboardId: String
    let type: StoryboardParser.SceneElement
    let isInitial: Bool
    let reuseIdentifiers: Set<StoryboardParser.Cell>
    let segues: Set<StoryboardParser.Segue>
    var dictionary: [String: Any] {
      return [
        "identifier": identifier,
        "storyboardId": storyboardId,
        "tag": type.tag,
        "customClass": type.customClass ?? "",
        "customModule": type.customModule ?? "",
        "class": type.klass,
        "module": type.module,
        "type": type.type,
        "isInitial": isInitial,
        "reuseIdentifiers": reuseIdentifiers.map { $0.dictionary },
        "segues": segues.map { $0.dictionary }
      ]
    }
  }

  public struct Segue: Element {
    let identifier: String
    let storyboardId: String
    let type: StoryboardParser.SegueElement
    let destinationId: String
    let kind: SegueKind
    let popoverPresentationAnchorView: String?
    let unwindAction: String?
    let relationship: String?
    var dictionary: [String:Any] {
      return [
        "identifier": identifier,
        "storyboardId": storyboardId,
        "customClass": type.customClass ?? "",
        "customModule": type.customModule ?? "",
        "class": type.klass,
        "module": type.module,
        "type": type.type,
        "destinationId": destinationId,
        "kind": kind.rawValue
      ]
    }
  }

  public struct Cell: Element {
    let identifier: String
    let storyboardId: String
    let type: StoryboardParser.CellElement
    var cellType: StoryboardParser.CellType {
      return StoryboardParser.CellType(rawValue: type.tag)!
    }
    var dictionary: [String:Any] {
      return [
        "identifier": identifier,
        "storyboardId": storyboardId,
        "tag": type.tag,
        "customClass": type.customClass ?? "",
        "customModule": type.customModule ?? "",
        "class": type.klass,
        "module": type.module,
        "type": type.type
      ]
    }
  }

  public init() {}

  private class ParserDelegate: NSObject, XMLParserDelegate {
    private var initialViewControllerObjectID: String?
    private var storyboardPlatform: StoryboardParser.Platform = .iOS
    var scenes = Set<Scene>()
    var segueDestinationIds = Set<String>()
    var modules = Set<String>()
    private var inScene = false
    private var readyForFirstObject = false
    private var readyForConnections = false
    private var readyForTableView = false
    private var readyForCollectionView = false
    private var sceneIdentifier: String?
    private var sceneTag: String?
    private var sceneStoryboardID: String?
    private var sceneClass: String?
    private var sceneModule: String?
    private var sceneIsInitial = false
    private var sceneCells = Set<Cell>()
    private var sceneSegues = Set<Segue>()
    private func resetScene() {
      sceneIdentifier = nil
      sceneTag = nil
      sceneStoryboardID = nil
      sceneClass = nil
      sceneModule = nil
      sceneIsInitial = false
      sceneCells = Set<Cell>()
      sceneSegues = Set<Segue>()
    }

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    @objc func parser(_ parser: XMLParser, didStartElement elementName: String,
                      namespaceURI: String?, qualifiedName qName: String?,
                      attributes attributeDict: [String: String]) {
      // swiftlint:enable function_body_length

      switch elementName {
      case "document":
        initialViewControllerObjectID = attributeDict["initialViewController"]
        storyboardPlatform = Platform(rawValue: attributeDict["targetRuntime"]!)!
      case "scene":
        inScene = true
      case "objects" where inScene:
        readyForFirstObject = true
      case let tag where (readyForFirstObject && tag != "viewControllerPlaceholder"):
        if
          let objectID = attributeDict["id"]
        {
          sceneIdentifier = objectID
          sceneTag = tag
          sceneStoryboardID = attributeDict["storyboardIdentifier"]
          sceneClass = attributeDict["customClass"]
          sceneModule = attributeDict["customModule"]
          if let module = sceneModule {
            modules.insert(module)
          }
          sceneIsInitial = initialViewControllerObjectID != nil && sceneIdentifier == initialViewControllerObjectID
          readyForFirstObject = false
        }
      case "tableView" where inScene:
        readyForTableView = true
      case "tableViewCell" where readyForTableView:
        if let reuseIdentifier = attributeDict["reuseIdentifier"] {
          sceneCells.insert(
            Cell(identifier: attributeDict["id"]!,
                 reuseIdentifier: reuseIdentifier,
                 platform: storyboardPlatform,
                 customClass: attributeDict["customClass"],
                 customModule: attributeDict["customModule"],
                 cellType: .tableViewCell)
          )
          if let module = attributeDict["customModule"] {
            modules.insert(module)
          }
        }
      case "collectionView" where inScene:
        readyForCollectionView = true
      case "collectionViewCell" where readyForCollectionView:
        if let reuseIdentifier = attributeDict["reuseIdentifier"] {
          sceneCells.insert(
            Cell(identifier: attributeDict["id"]!,
                 reuseIdentifier: reuseIdentifier,
                 platform: storyboardPlatform,
                 customClass: attributeDict["customClass"],
                 customModule: attributeDict["customModule"],
                 cellType: .collectionViewCell)
          )
          if let module = attributeDict["customModule"] {
            modules.insert(module)
          }
        }
      case "connections" where inScene:
        readyForConnections = true
      case "segue" where readyForConnections:
        if attributeDict["identifier"] != nil {
          if let segue = Segue(platform: storyboardPlatform, attributes: attributeDict) {
            sceneSegues.insert(segue)
            if segue.kind != .unwind {
              segueDestinationIds.insert(segue.destinationId)
            }
            if let module = attributeDict["customModule"] {
              modules.insert(module)
            }
          }
        }
      default:
        break
      }

    }
    // swiftlint:enable cyclomatic_complexity

    @objc func parser(_ parser: XMLParser, didEndElement elementName: String,
                      namespaceURI: String?, qualifiedName qName: String?) {
      switch elementName {
      case "scene":
        inScene = false
        defer {
          resetScene()
        }
        guard
          let sceneId = sceneIdentifier,
          let tag = sceneTag
          else {
            break
        }

        scenes.insert(
          Scene(identifier: sceneId,
                storyboardId: sceneStoryboardID,
                platform: storyboardPlatform,
                tag: tag,
                customClass: sceneClass,
                customModule: sceneModule,
                isInitial: sceneIsInitial,
                reuseIdentifiers: sceneCells,
                segues: sceneSegues)
        )
      case "objects" where inScene:
        readyForFirstObject = false
      case "tableView":
        readyForTableView = false
      case "collectionView":
        readyForCollectionView = false
      case "connections":
        readyForConnections = false
      default:
        break
      }
    }
  }

  public func addStoryboard(at path: Path) throws {
    let parser = XMLParser(data: try path.read())

    let delegate = ParserDelegate()
    parser.delegate = delegate
    parser.parse()

    let storyboardName = path.lastComponentWithoutExtension
    storyboardFiles[storyboardName] = delegate.scenes
    segueDestinationIds.formUnion(delegate.segueDestinationIds)
    modules.formUnion(delegate.modules)
  }

  public func parseDirectory(at path: Path) throws {
    let iterator = path.makeIterator()

    while let subPath = iterator.next() {
      if subPath.extension == "storyboard" {
        try addStoryboard(at: subPath)
      }
    }
  }
}
// swiftlint:enable type_body_length

extension StoryboardParser.Scene: Hashable, Equatable {
  public var hashValue: Int {
    return (identifier.hashValue ^
      storyboardId.hashValue ^
      type.hashValue ^
      isInitial.hashValue ^
      reuseIdentifiers.hashValue ^
      segues.hashValue)
  }
}

extension StoryboardParser.Segue: Hashable, Equatable {
  public var hashValue: Int {
    return (identifier.hashValue ^
      storyboardId.hashValue ^
      type.hashValue ^
      destinationId.hashValue ^
      kind.hashValue ^
      (popoverPresentationAnchorView?.hashValue ?? 0) ^
      (unwindAction?.hashValue ?? 0) ^
      (relationship?.hashValue ?? 0)
    )
  }
}

// MARK: - Extensions

extension String {
  var capitalizedFirstLetter: String {
    let first = String(characters.prefix(1)).capitalized
    let other = String(characters.dropFirst())
    return first + other
  }
}

// swiftlint:enable file_length
