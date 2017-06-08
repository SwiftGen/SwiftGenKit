# Asset Catalog parser

## Input

The assets parser accepts one (or more) asset catalogs, which it'll parse for `image set`s and folders.

## Output

The output context has the following structure:

 - `catalogs`: `Array` — list of asset catalogs
   - `name`  : `String` — the name of the catalog
   - `assets`: `Array` — tree structure of items, each item either
     - represents a folder and has the following entries:
       - `name` : `String` — name of the folder
       - `items`: `Array` — list of items, can be either folders or images
     - represents an image asset, and has the following entries:
       - `name` : `String` — name of the image
       - `value`: `String` — the actual full name for loading the image

## Example

```
{
  "catalogs": [
    {
      "name": "Images",
      "assets": [
        {
          "name": "Exotic",
          "items": [
            {
              "value": "Exotic\/Banana",
              "name": "Banana"
            },
            {
              "value": "Exotic\/Mango",
              "name": "Mango"
            }
          ]
        },
        {
          "value": "Logo",
          "name": "Logo"
        },
        {
          "name": "Round",
          "items": [
            {
              "value": "Round\/Apricot",
              "name": "Apricot"
            },
            {
              "value": "Round\/Orange",
              "name": "Orange"
            },
            {
              "name": "Red",
              "items": [
                {
                  "value": "Round\/Apple",
                  "name": "Apple"
                },
                {
                  "name": "Double",
                  "items": [
                    {
                      "value": "Round\/Double\/Cherry",
                      "name": "Cherry"
                    }
                  ]
                },
                {
                  "value": "Round\/Tomato",
                  "name": "Tomato"
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```
