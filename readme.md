# Item-Badges
**Item Badges** is a mod for Factorio designed to make icons and recipes easier to distinguish for those with various forms of colorblindness.

## For users
**Item Badges** adds specific two-letter identifiers to certain items and recipes. For Vanilla Factorio, it includes all items that have the same shape but different colors, like barreled fluids, electronic circuits, and weapon magazines. For element-based items (copper, iron, etc.), I used identifiers from the periodic table. For items whose proper names are commonly used (light oil, shotgun shells, etc.), I used one or two letters from the name, favoring using only one. For items that are commonly referenced by their color ('yellow belt', 'green circuits,' etc.), I used the first letter of the color. Any time I deviated from this, there was usually some kind of collision (for example: most people say 'red' or 'green' science; however, 'grey' science collides pretty hard with 'green' when using two letters).

### The settings
**Show Badges:**
  - Inventory: The mod will display badges ONLY in GUI screens (inventory, craftable recipes, etc.).
  - All: The mod will display badges in GUI screens AND on belts.

**Badge Scale:**
  - How large should the badges be? It starts at Average, and going up or down a tier from there adds or subtracts 25% size.

**Zoom Visibility:**
  - Far: Badges are visible from far away (i.e. they never fade)
  - Medium: Badges are visible from a medium distance, but will fade out past that.
  - Near: Badges are visible when zoomed in near the ground, but will fade out past that.

## For Modders
Good news! This is super duper easy to use. To add a badge to any item or recipe, add the following properties to any item or recipe prototype:
1. **ib_badge** : A 1 or 2 character string, consisting of lower- or upper-case letters or numbers (nothing else!). Valid examples: "AB", "aB", "Ab", "A", "b", "1A", "1".
2. **ib_invert** : (optional) Set to anything that isn't 'nil' to invert the text. By default, badges are 'white text with black borders'. To help with collisions, I've also supplied 'black text with white borders.' It's both-or-neither; it's not possible to have one character inverted and another not.
3. **ib_corner** : (optional) (recipe ONLY) This moves the **recipe** badge in one of the four corners instead of the upper left. (note: this doesn't work for items, as any corner that isn't left-top won't always be visible when the item is on belts) Set to one of the following EXACTLY as shown:
  - "left-top"     (default)
  - "left-bottom"
  - "right-top"
  - "right-bottom"
      
I add badges in data-final-fixes.lua. As long as you add those properties to your items or recipes before then -- either by using data.lua, data-updates.lua, or making my mod an optional dependency of yours, it should work. You shouldn't have to fuss with anything else.

I've tried to make the system as robust as possible, but due to how many ways items and recipes can be displayed in their prototypes, you may find some case that I don't handle. Submit an issue on GitHub, and I'll take a look. :)