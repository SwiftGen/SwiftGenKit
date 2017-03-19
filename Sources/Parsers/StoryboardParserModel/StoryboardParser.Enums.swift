//
// SwiftGenKit
// Copyright (c) 2017 SwiftGen
// MIT Licence
//

import Foundation

extension StoryboardParser {

  public enum Platform: String {
    case macOS = "MacOSX.Cocoa"
    case iOS = "iOS.CocoaTouch"
  }

  public enum CellType: String {
    case tableViewCell
    case collectionViewCell
  }

  public enum SegueKind: String {
    case show
    case showDetail
    case presentModal = "presentation"
    case popoverPresentation
    case custom
    case unwind
    case relationship
    // macOS
    case popover
    case modal
    case sheet
    case embed
  }

}
