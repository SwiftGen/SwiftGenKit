# Storyboards parser

## Input

The storyboards parser accepts either a file or a directory, which it'll search for `storyboard` files. The parser will load all the scenes and all the segues for each storyboard. It supports both AppKit (macOS) and UIKit (iOS, watchOS, tvOS) storyboards. 

## Output

The output context has the following structure:

 - `modules`    : `Array<String>` — List of modules used by scenes and segues — typically to be used for "import" statements
 - `storyboards`: `Array` — List of storyboards
    - `name`: `String` — Name of the storyboard
    - `initialScene`: `Dictionary` (absent if not specified)
       - `customClass` : `String` — The custom class of the scene (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` — The custom module of the scene (absent if no custom class)
       - `baseType`: `String` — The base class type of the scene if not custom (absent if class is a custom class).
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `scenes`: `Array` (absent if empty)
       - `identifier` : `String` — The scene identifier
       - `customClass`: `String` — The custom class of the scene (absent if generic UIViewController/NSViewController)
       - `customModule`: `String` — The custom module of the scene (absent if no custom class)
       - `baseType`: `String` — The base class type of the scene if not custom (absent if class is a custom class).
          Possible values include 'ViewController', 'NavigationController', 'TableViewController'…
    - `segues`: `Array` (absent if empty)
       - `identifier`: `String` — The segue identifier
       - `customClass`: `String` — The custom class of the segue (absent if generic UIStoryboardSegue)
       - `customModule`: `String` — The custom module of the segue (absent if no custom segue class)
