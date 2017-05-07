# Colors parser

## Input

The colors parser supports multiple input file types:

 - CLR: NSColor​List palette file ([see docs](https://developer.apple.com/reference/appkit/nscolorlist)).
 - JSON: Root object where each key is the name, each value is a hex color string.
 - TXT: Each line has a name and a color, separated by a `:`. A color can either be a color hex value, or the name of another color in the file.
 - XML: Android colors.xml file parser ([see docs](https://developer.android.com/guide/topics/resources/more-resources.html#Color)).

## Output

The output context has the following structure:

 - `colors`: `Array` — list of colors:
    - `name` : `String` — name of the color
    - `red`  : `String` — hex value of the red component
    - `green`: `String` — hex value of the green component
    - `blue` : `String` — hex value of the blue component
    - `alpha`: `String` — hex value of the alpha component
