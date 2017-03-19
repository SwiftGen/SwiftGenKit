//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

extension StoryboardParser {
  public struct SegueElement: Typable {
    let platform: StoryboardParser.Platform
    let tag: String
    let customClass: String?
    let customModule: String?
    var klass: String {
      let defaultClass: String
      switch platform {
      case .iOS:
        defaultClass = "UIStoryboardSegue"
      case .macOS:
        defaultClass = "NSStoryboardSegue"
      }
      return customClass ?? defaultClass
    }
  }
}

extension StoryboardParser.SegueElement {
  public init(platform: StoryboardParser.Platform, customClass: String?, customModule: String?) {
    self.platform = platform
    self.tag = "segue"
    self.customClass = customClass
    self.customModule = customModule
  }
}

extension StoryboardParser.SegueElement: Hashable, Equatable {
  public var hashValue: Int {
    return (platform.hashValue ^ tag.hashValue ^ klass.hashValue)
  }
}

public func == (lhs: StoryboardParser.SegueElement, rhs: StoryboardParser.SegueElement) -> Bool {
  return lhs.platform == rhs.platform &&
    lhs.tag == rhs.tag &&
    lhs.klass == rhs.klass
}

public func == (lhs: StoryboardParser.Segue, rhs: StoryboardParser.Segue) -> Bool {
  return (lhs.identifier == rhs.identifier &&
    lhs.storyboardId == rhs.storyboardId &&
    lhs.type == rhs.type &&
    lhs.destinationId == rhs.destinationId &&
    lhs.kind == rhs.kind &&
    lhs.popoverPresentationAnchorView == rhs.popoverPresentationAnchorView &&
    lhs.unwindAction == rhs.unwindAction &&
    lhs.relationship == rhs.relationship)
}

extension StoryboardParser.Segue {
  public init?(platform: StoryboardParser.Platform,
               attributes attributeDict: [String: String]) {
    guard
      let identifier = attributeDict["id"],
      let segueID = attributeDict["identifier"],
      let destinationId = attributeDict["destination"],
      let kind = StoryboardParser.SegueKind(rawValue: attributeDict["kind"]!)
      else {
        return nil
    }

    try? self.init(identifier: identifier,
                   segueID: segueID,
                   platform: platform,
                   customClass: attributeDict["customClass"],
                   customModule: attributeDict["customModule"],
                   destinationId: destinationId,
                   kind: kind,
                   popoverPresentationAnchorView: attributeDict["popoverAnchorView"],
                   unwindAction: attributeDict["unwindAction"],
                   relationship: attributeDict["relationship"])
  }
}

extension StoryboardParser.Segue {
  public init(identifier: String,
              segueID: String,
              platform: StoryboardParser.Platform,
              customClass: String?,
              customModule: String?,
              destinationId: String,
              kind: StoryboardParser.SegueKind,
              popoverPresentationAnchorView: String? = nil,
              unwindAction: String? = nil,
              relationship: String? = nil) throws {

    switch kind {
    case .popoverPresentation:
      if popoverPresentationAnchorView == nil {
        throw StoryboardParserError.popoverPresentationSegueWithoutAnchorView
      }
    case .unwind:
      if unwindAction == nil {
        throw StoryboardParserError.unwindSegueWithoutUnwindAction
      }
    case .relationship:
      if relationship == nil {
        throw StoryboardParserError.relationshipSegueWithoutRelationship
      }
    default:
      break
    }

    self.identifier = identifier
    self.storyboardId = segueID
    self.type = StoryboardParser.SegueElement(platform: platform,
                                             customClass: customClass,
                                             customModule: customModule)
    self.destinationId = destinationId
    self.kind = kind
    self.popoverPresentationAnchorView = popoverPresentationAnchorView
    self.unwindAction = unwindAction
    self.relationship = relationship
  }
}
