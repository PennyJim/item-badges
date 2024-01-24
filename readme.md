# Icon Badges
## Introduction
**Icon Badges** is a mod for Factorio designed to make icons and recipes easier to distinguish for those with various forms of colorblindness.
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
  - How large should the badges be? It starts at Average, and going up or down a tier from there adds or subtracts 25% size.

**Zoom Visibility:**
  - Far: Badges are visible from far away (i.e. they never fade)
  - Medium: Badges are visible from a medium distance, but will fade out past that.
  - Near: Badges are visible when zoomed in near the ground, but will fade out past that.

**Badge Opacity:**
  - How opaque should the badges be when fully diplayed (1 = fully visible, 0 = fully transparent)?

## For Modders
Good news! This is super duper easy to use. To add a badge to any *item*, *fluid* or *recipe*, you can add a Letter badge and/or an Image Badge, in different corners if you wish!

The font that Factorio uses is called Titillium Web, which is unfortunately not mono-spaced, meaning characters have varying pixel widths. Thus, I built the letter badge functions to justify things properly *manually*. Because image badges can be any size, I didn't build justification functionality into it.

### Letter Badge
To add a letter badge, add the following properties to its prototype:
1. **ib_let_badge** :
   Must be a 1, 2 or 3 character string, consisting of lower- or upper-case letters or numbers (nothing else!). Valid examples: "AB", "aB", "Ab", "A", "b", "1A", "1", "GUI", "wHy".
   Note: 3-letter badges are always centered (going left-to-right), though they can be put on the top or bottom of the icon. They're just too wide. Use "ib_corner" like normal; it'll work out the rest.

2. **ib_let_invert** :
   *(optional)* Set to anything that isn't 'nil' to invert the text. By default, badges are 'white text with black borders'. To help with collisions, I've also supplied 'black text with white borders.' It's both-or-neither; it's not possible to have one character inverted and another not.

3. **ib_let_corner** :
   *(optional)* This moves the badge in one of the four corners instead of the upper left. Set to one of the following EXACTLY as shown (even for 3-letter badges!!):
  - "left-top"     (default)
  - "left-bottom"
  - "right-top"
  - "right-bottom"

### Image Badge
To add a image badge, add the following properties to its prototype:
1. **ib_img_paths** :
   A table of paths (strings). Each should point to the location of the image file. If there's just one, it should be: ib_img_paths = {"whatever.png"}. This allows you to stack them in place.

2. **ib_img_size** :
   The size of the image file.

3. **ib_img_corner** :
   *(optional)* Behaves perfectly analogously to ib_let_corner. While it can be different from the letter badge corner, there can be only one image badge corner, no matter how many images are referenced in ib_img_paths. Currently, the image badge will always be on top of the letter badge. If there's enough need, I can make this a setting.

4. **ib_img_mips** :
   *(optional)* The mip levels of the image. By default, it assumes none, but if the image has mipmaps in it, leaving this blank will cause a crash.

5. **ib_img_scale** :
   *(optional)* A knob for modders to scale the image badges. This number will potentially differ between images, because the profile of the image may not take up the full (say) 64x64 px canvas. Determine empirically.

6. **ib_img_space** :
   *(optional)* Controls spacing between image badges, one value for all. This is in pixels.

## Notes
I add badges in data-final-fixes.lua. As long as you add those properties to your items, fluids or recipes before then -- either by using data.lua, data-updates.lua, or making my mod an optional dependency of yours, it should work. You shouldn't have to fuss with anything else.

Look in the file vanilla.lua to see an example of how to modify a batch of icons.

If you badge-up a recipe that draw their icon(s) data from its product, and that product has already been badged, you'll get a double-badge. For max compatibility, just badge-up the product item.

I've tried to make the system as robust as possible, but due to how many ways items and recipes can be displayed in their prototypes, you may find some case that I don't handle. Submit an issue on GitHub, and I'll take a look. :)

P.S. I strongly regret not naming the mod Badger. There's not mushroom for mis snakes, though, and I can't change the past. (if you get this pun, you are the best)