# Icon Badges
## Introduction
**Icon Badges** is a mod for Factorio designed to make icons and recipes easier to distinguish for those with various forms of colorblindness.
Note: Yes, I misnamed the repository 'item-badges'. Augh.

## For users
**Icon Badges** adds specific two-letter identifiers to certain *items*, *fluids*, and *recipes*. For Vanilla Factorio, it includes all items that have the same shape but different colors, like barreled fluids, electronic circuits, and weapon magazines. For element-based items (copper, iron, etc.), I used identifiers from the periodic table. For items whose proper names are commonly used (light oil, shotgun shells, etc.), I used one or two letters from the name, favoring using only one. For items that are commonly referenced by their color ('yellow belt', 'green circuits,' etc.), I used the first letter of the color. Any time I deviated from this, there was usually some kind of collision (for example: most people say 'red' or 'green' science; however, 'grey' science collides pretty hard with 'green' when using two letters).

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
Good news! This is super duper easy to use. To add a badge to any *item*, *fluid* or *recipe*, add the following properties to its prototype:

1. **ib_badge** :
   Must be a 1 or 2 character string, consisting of lower- or upper-case letters or numbers (nothing else!). Valid examples: "AB", "aB", "Ab", "A", "b", "1A", "1".

2. **ib_invert** :
   *(optional)* Set to anything that isn't 'nil' to invert the text. By default, badges are 'white text with black borders'. To help with collisions, I've also supplied 'black text with white borders.' It's both-or-neither; it's not possible to have one character inverted and another not.

3. **ib_corner** :
   *(optional)* This moves the badge in one of the four corners instead of the upper left. Set to one of the following EXACTLY as shown:
  - "left-top"     (default)
  - "left-bottom"
  - "right-top"
  - "right-bottom"

I add badges in data-final-fixes.lua. As long as you add those properties to your items, fluids or recipes before then -- either by using data.lua, data-updates.lua, or making my mod an optional dependency of yours, it should work. You shouldn't have to fuss with anything else.

If you badge-up a recipe that draw their icon(s) data from its product, and that product has already been badged, you'll get a double-badge. For max compatibility, just badge-up the product item.

I've tried to make the system as robust as possible, but due to how many ways items and recipes can be displayed in their prototypes, you may find some case that I don't handle. Submit an issue on GitHub, and I'll take a look. :)

P.S. I strongly regret not naming the mod Badger. There's not mushroom for mis snakes, though, and I can't change the past. (if you get this pun, you are the best)
