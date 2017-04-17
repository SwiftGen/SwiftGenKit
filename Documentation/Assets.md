# Asset Catalog parser

## Input

The assets parser accepts one (or more) asset catalogs, which it'll parse using the `actool` utility. For now it only parses `image set`s and folders.

Note: there is a bug in `actool` where it won't be able to parse a catalog if it contains certain types of assets, see [here](https://github.com/SwiftGen/SwiftGen/issues/228).

## Output

The output context has the following structure:

 - `catalogs`: `Array` — list of asset catalogs
   - `name`  : `String` — the name of the catalog
   - `assets`: `Array` — tree structure of items, each item is either a:
     - group: this represents a folder
		- `name` : `String` — name of the folder
        - `items`: `Array` — list of items, can be either groups or images
     - image: this represents an image asset
        - `name` : `String` — name of the image
        - `value`: `String` — the actual name for loading the image
