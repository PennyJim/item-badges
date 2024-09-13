# Icon Badges
## Introduction
**Icon Badges** is a mod for Factorio designed to make icons and recipes easier to distinguish for those with various forms of colorblindness, or for mods that just have tons of similar-looking icons that would benefit from having further distinction from one another..
Note: Yes, I misnamed the repository 'item-badges'. Augh.

## For users
**Icon Badges** adds specific 1, 2, or 3-letter identifiers OR images to certain *items*, *fluids*, and *recipes*. For Vanilla Factorio, it includes all items that have the same shape but different colors, like barreled fluids, electronic circuits, and weapon magazines. For element-based items (copper, iron, etc.), I used identifiers from the periodic table. For items whose proper names are commonly used (light oil, shotgun shells, etc.), I used one or two letters from the name, favoring using only one. For items that are commonly referenced by their color ('yellow belt', 'green circuits,' etc.), I used the first letter of the color. Any time I deviated from this, there was usually some kind of collision (for example: most people say 'red' or 'green' science; however, 'grey' science collides pretty hard with 'green' when using two letters). I didn't use any images in Vanilla Factorio, but it is available to those that might wish to use them in their mods.

Hint: In game, if you press F4 and check 'allow increased zoom' (third from the last option at the time of writing), you can zoom in very close to read the badges.
Hint Corollary : Those are debug options. They shouldn't melt your game, but tread lightly when tinkering.

### The settings
**Show Badges:**
  - Only GUI: The mod will display badges ONLY in GUI screens (inventory, craftable recipes, etc.).
  - Only Belts: The mod will display badges ONLY on belts, and NOT GUI screens
  - All: The mod will display badges in GUI screens AND on belts.

**Badge Scale:**
  - How large should the badges be? It defaults to Average, and going up or down a tier from there adds or subtracts 25% size.

**Zoom Visibility:**
  - Far: Badges are visible from far away (i.e. they never fade)
  - Medium: Badges are visible from a medium distance, but will fade out past that.
  - Near: Badges are visible when zoomed in near the ground, but will fade out past that.

**Badge Opacity:**
  - How opaque should the badges be when fully diplayed (1 = fully visible, 0 = fully transparent)?

## For Modders
Good news! This is super duper easy to use. To add a badge to any *item*, *fluid* or *recipe*, you can add a Letter badge and/or an Image Badge, in different corners if you wish!

The font that Factorio uses is called Titillium Web, which is unfortunately not mono-spaced, meaning characters have varying pixel widths. Thus, I built the letter badge functions to justify things properly *manually*. Because image badges can be any size, I didn't build justification functionality into it.

First, Icon Badges will attempt to badge vanilla items. If you want to turn off this behavior so that you can do it your own way, simply set `Ib_global.badge_vanilla = false` BEFORE data-final-fixes.lua.

Next, to badge an item, create a table called *ib_data*. ib_data is a table that will contain all of the badge properties, listed below.

Finally, use the function *Build_badge(prototype, ib_data)* to put your badge on the item!
  - *prototype*: A properly formed *fluid*, *recipe*, *item* or *child-of-item* prototype. See: https://lua-api.factorio.com/latest/prototypes/ItemPrototype.html for a list of all child-of-item prototypes.
  - *ib_data*: A table with (some of, maybe all; note which ones are listed as *optional*) the following properties.

### Letter Badge Properties
1. **ib_let_badge** :
   Must be a 1, 2 or 3 character string, consisting of lower- or upper-case letters or numbers (nothing else!). Valid examples: "AB", "aB", "Ab", "A", "b", "1A", "1", "GUI", "wHy".
   Note: 3-letter badges are always centered horizontally, though they can be put on the top or bottom of the icon. They're just too wide. Use "ib_corner" like normal; it'll work out the rest.

2. **ib_let_invert** :
   *(optional)* Set to anything that isn't 'nil' to invert the text. By default, badges are 'white text with black borders'. To help with collisions, I've also supplied 'black text with white borders.' It's both-or-neither; it's not possible to have one character inverted and another not.

3. **ib_let_corner** :
   *(optional)* This moves the badge in one of the four corners instead of the upper left. Set to one of the following EXACTLY as shown (even for 3-letter badges!!):
  - "left-top"     (default)
  - "left-bottom"
  - "right-top"
  - "right-bottom"

### Image Badge Properties
1. **ib_img_paths** :
   A **TABLE** of paths (strings). Each string should point to the location of the image file. Note: If you have just one path, still enclose it in a table. For example: ib_img_paths = {"whatever.png"}.

2. **ib_img_size** :
   The size of the image file.

3. **ib_img_corner** :
   *(optional)* Behaves perfectly analogously to ib_let_corner. While it can be different from the letter badge corner, there can be only one image badge corner, no matter how many images are referenced in ib_img_paths.

4. **ib_img_mips** :
   *(optional)* The mip levels of the image. By default, it assumes none, but if the image has mipmaps in it, leaving this blank will cause a crash.

5. **ib_img_scale** :
   *(optional)* A knob for modders to scale the image badges. This number will potentially differ between images, because the profile of the image may not take up the full (say) 64x64 px canvas. Determine empirically.

6. **ib_img_space** :
   *(optional)* Controls spacing between image badges, one value for all, in pixels. If this is 0, all images will stack on top of one another, in order.

### Interplay Property
1. **ib_let_on_top** :
   A boolean value that determines if the letter badge should be on top of the image badge. Default is true.

## Notes
If you badge-up a recipe that draw their icon(s) data from its product, and that product has already been badged, you'll get a double-badge. For max compatibility, just badge-up the product item.

With regards to timing, I add vanilla badges in data-final-fixes.lua.

Look in the file vanilla.lua to see an example of how to modify a batch of icons across various types of prototypes. I use a homebrew structure called a 'badge list' which is outlined in ib-lib.lua, but you don't have to.

If you need to unbadge something from Vanilla for compatibility with your mod, you have two options. 
A) Turn off vanilla badging entirely by setting Ib_global.badge_vanilla = false at the data.lua stage.
B) Turn off just the badges that conflict. You will have to use my Badge List structure then. To do this:
   1) Set Ib_global.badge_vanilla = false at the data.lua stage (just like option A) )
   2) Badge_list[prototype_group][prototype_name] = {} (or, to rebadge, replace {} with whatever ib_data you wish) for every prototype you want to unbadge (or rebadge), where prototype_group is a fluid, recipe, item, or child of item in data.raw.
   3) Run Process_badge_list(Badge_list).

I've tried to make the system as robust as possible, but due to how many ways items and recipes can be displayed in their prototypes, you may find some case that I don't handle. If something breaks, submit an issue on GitHub, and I'll take a look.

P.S. I strongly regret not naming the mod Badger. There's not mushroom for mis snakes, though, and I can't change the past. (if you get this pun, you are the best)
