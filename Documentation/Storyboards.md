# Storyboards parser

## Input

The storyboards parser accepts either a file or a directory, which it'll search for `storyboard` files. The parser will load all the scenes and all the segues for each storyboard. It supports both AppKit (macOS) and UIKit (iOS, watchOS, tvOS) storyboards. 

## Output

The output context has the following structure:

 - `modules`    : `Array<String>` — List of modules used by scenes and segues
 - `storyboards`: `Array` — List of storyboards
    - `name`: `String` — Name of the storyboard
    - `initialScene`: `Dictionary` (absent if not specified)
       - `customClass` : `String` (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` (absent if no custom class)
       - `baseType`: `String` (absent if class is a custom class).
          The base class type on which the initial scene is base.
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `scenes`: `Array` (absent if empty)
       - `identifier` : `String`
       - `customClass`: `String` (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` (absent if no custom class)
       - `baseType`: `String` (absent if class is a custom class).
          The base class type on which a scene is base.
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `segues`: `Array` (absent if empty)
       - `identifier`: `String`
       - `customClass`: `String` (absent if generic UIStoryboardSegue)
