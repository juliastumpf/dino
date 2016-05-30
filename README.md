http://doc.mapeditor.org <-- tiled documentation

to set where the player spawns, make an object called "player"

to load ur map into the game:

replace source/assets/maps/test.lua with ur own map file(use tiled's file>export function to export map as lua)
im using source/assets/maps/tmx/ as a place to store all the source map files from tiled

if you want to replace the player image, source/assets/images/player.png is the thing to fuck wit(note that it doesnt support animation yet, imma do that at the same time i revamp the movement system)
store tilesets in source/assets/images/ too

to run the game with your modifications, drag the source/ folder into love.exe(or a shorcut to love.exe)

or to run it in the command line, `"C:\Program Files\LOVE\love.exe" "......./source/"`

to make a .love file, zip the source/ folder, and rename the resulting .zip to a .love -- It's That Easy!
