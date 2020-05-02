# stanley

Common flutter widgets and helper methods.

## Dependencies

As of now, stanley is an opiniated package which includes dependencies to:
- [easy_localization](https://pub.dev/packages/easy_localization)

## Main classes

### Decorator

A all-in-one budget to manage layout and styling of other widgets. Based on the properties set, `Decorator` will encapsulate the child wigdet with whatever is needed to support:
- Sizing
- Margins
- Paddings
- Borders (including rounded)
- Background color
- Tap handler

Paddings and margins can be specified with various parameters that can be used to override defaults. For instance:
-	`paddingAll`: 16
-	`paddingHoriz`: 8
-	`paddingLeft`: 4

Will result in:
- Top and bottom = 16 (paddingAll)
- Right = 8 (overriden by paddingHoriz)
- Left = 4 (overriden by paddingLeft)

The `example` uses `Decorator` for the buttons displayed on the page.

### Native Dialog

A class to display native dialogs and alert sheets on iOS and Android with unified interface. The `example` demonstrates several uses of this.

### Other UI Helpers

Other helpers include `scaffold`, `text` which basically embrace the same philosophy as `Decorator`: pass all required parmeters and these classes will do the work.

### Forms

A set of classes to quickly create vertical forms (definitely more Material than iOS). Those were mostly created for non-white backgrounds as they override a number decorations to fit your style. You can override `PaddedFormField.textColor` (defaults to white) if needed.

All widgets include the possibility to attach an icon as decoration that can be clicked to get help.

Widgets include:
- `DecoratedTextFormField`: safe explanatory
- `DropdownField`: encapsulated `DropdownButtonFormField`
- `ToggleFormField`: specialized `DropdownField` for boolean choices
