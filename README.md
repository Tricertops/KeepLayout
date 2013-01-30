# Keep Layout

Keep Layout is project **under active development** whose purpose is to make *Auto Layout* easy to use _from code_! No more clicking in *Interface Builder* or manual creation of constraints. Think in attributes and their rules. *Keep Layout* will set all constraints to keep your desired layout.

_NOTE: I focus on iOS, but support for OSX will be added. In fact, **you may add it!** Please contribute with your ideas. Thank you!_



## Short Syntax
Naming of classes and methods is focused on the shortest syntax possible. Because of this there are subclasses that override constructors for your convenience. Defining layout will be reduced to few lines of code.

I will be improving interface of classes, so it would cover most of the uses with one line. Because 90% of time you use only 10% possibilities of *Auto Layout* (numbers are made up, but you get the point).



## Overview



### Attributes – `KeepAttribute` subclasses
Create representation of view attribute. They define internal metric or relation to another view:

 - **dimensions** – width, height, aspect ratio
 - **insets** – top, bottom, left, right – related to superview
 - **position** – relative to superview bounds
 - *more comming…*



### Rules – `KeepRule` subclasses
Create multiple rules for each attribute. Rule encapsulates a value, type of the value and its priority. There are 3 types with one subclass for each:

 - **equal** – attribute should be equal to this value
 - **max** – attribute should be lower or equal to this value
 - **min** – attribute should be greater or equal to this value

Rule priorities are four (just like when usinng `NSLayoutConstraint`) and you specify them by calling appropriate constructor:

 1. **must** – Highest priority saying this rule _must_ be applied without compromises. Use `+must:` constructor.
 2. **shall** – High priority saying this rule _should_ be applied. Use `+shall:` constructor.
 3. **may** – Normal priority saying this rule _may_ be applied. Use `+may:` constructor.
 4. **fit** – Lowest priority saying this rule is just fallback case to _fit_. Use `+fit:` constructor.

You may create rule relative to another view. Not every attribute supports them, but for example you may keep widths of multiple views to be related, like “always double” or “at least one half”.

_NOTE: You may not like the naming, but I wanted something human-friendly. Since “keep” is verb I choose modal verbs to make it more like natural language._



### Keep the layout
Tell your view to keep created attribute with its rules. Examples:

##### 1. Keep width exactly 150 points:

```objective-c
[view keep:[KeepWidth rules:@[ [KeepEqual must:150] ]];
```

##### 2. Keep aspect ratio between 4:3 and 16:9:

```objective-c
[view keep:[KeepAspectRatio rules:@[ [KeepMin must:4/3.], [KeepMax must:16/9.] ]];
```

##### 3. Keep top inset (to superview) flexible with preffered value of 20 points, but it may never be less than 10 points.

```objective-c
[view keep:[KeepTopInset rules:@[ [KeepMin must:10], [KeepEqual may:20] ]];
```

##### 4. Keep insets 10 points. Keep aspect ration 16:9. Keep centered in 1/3rd of container. _See pictures and “example1” included in project._

```objective-c
// Insets
NSArray *rules = @[ [KeepMin must:10], [KeepEqual may:10] ];
[view keep:[KeepTopInset rules:rules]];
[view keep:[KeepBottomInset rules:rules]];
[view keep:[KeepRightInset rules:rules]];
[view keep:[KeepLeftInset rules:rules]];

// Dimensions
[view keep:[KeepAspectRatio rules:@[ [KeepMin must:16/9.] ]]];

// Position
[view keep:[KeepHorizontally rules:@[ [KeepEqual must:1/2.] ]]];
[view keep:[KeepVertically rules:@[ [KeepMax must:1/2.], [KeepMin must:1/3.], [KeepEqual may:1/3.] ]]];
```

![Portrait Example 1](https://raw.github.com/iMartinKiss/KeepLayout/master/readme/example1-portrait.png)
![Landscape Example 1](https://raw.github.com/iMartinKiss/KeepLayout/master/readme/example1-landscape.png)

##### 4. Keep insets 20 and inter-view spacing 10. Keep equal widths and heights. _See pictures and “example2” included in project._

```objective-c
// Insets
NSArray *insetRules = @[ [KeepMin must:20], [KeepMax may:20] ];
for (UIView *view in @[ red, green, blue ]) {
    [view keep:[KeepTopInset rules:insetRules]];
    [view keep:[KeepBottomInset rules:insetRules]];
    [view keep:[KeepLeftInset rules:insetRules]];
    [view keep:[KeepRightInset rules:insetRules]];
}
// Offsets
NSArray *offsetRules = @[ [KeepMin must:10], [KeepMax shall:10] ];
[red keep:[KeepBottomOffset to:green rules:offsetRules]];
[red keep:[KeepBottomOffset to:blue rules:offsetRules]];
[green keep:[KeepRightOffset to:blue rules:offsetRules]];

// Dimensions
[green keep:[KeepHeight rules:@[ [KeepEqual mustTo:red] ]]];
[blue keep:[KeepHeight rules:@[ [KeepEqual mustTo:red] ]]];
[blue keep:[KeepWidth rules:@[ [KeepEqual mustTo:green] ]]];
```

![Portrait Example 2](https://raw.github.com/iMartinKiss/KeepLayout/master/readme/example2-portrait.png)
![Landscape Example 2](https://raw.github.com/iMartinKiss/KeepLayout/master/readme/example2-landscape.png)



---
_Version 0.2.0_

MIT License, Copyright © 2013 Martin Kiss

`THE SOFTWARE IS PROVIDED "AS IS", and so on...`
