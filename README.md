# Keep Layout

Keep Layout is project **under active development** whose purpose is to make *Auto Layout* easy to use _from code_! No more clicking in *Interface Builder* or manual creation of constraints. Think in attributes and their rules. *Keep Layout* will set all constraints to keep your desired layout.

_NOTE: I focus on iOS, but support for OSX will be added. In fact, **you may add it!** Please contribute with your ideas. Thank you!_



## Short Syntax
Naming of classes and methods is focused on the shortest syntax possible. Because of this there are subclasses that override constructors for your convenience. Defining layout will be reduced to few lines of code.

I will be improving interface of classes, so it would cover most of the uses with one lin



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

_NOTE: You may not like the naming, but I wanted something human-friendly. Since “keep” is verb I choose modal verbs to make it more like natural language._



### Keep the layout
Tell your view to keep created attribute with its rules. Examples:

##### Keep width exactly 150 points:

```objective-c
[view keep:[KeepWidth rules:@[ [KeepEqual must:150] ]];
```

##### Keep aspect ratio between 4:3 and 16:9:

```objective-c
[view keep:[KeepAspectRatio rules:@[ [KeepMin must:4/3.], [KeepMax must:16/9.] ]];
```

##### Keep top inset (to superview) flexible with preffered value of 20 points, but it may never be less than 10 points.

```objective-c
[view keep:[KeepTopInset rules:@[ [KeepMin must:10], [KeepEqual may:20] ]];
```

##### Keep insets minimum of 10 points with preffered value 10 point. Keep aspect ration 16:9. Keep Horizontally centered but vertically in 1/3rd of superview with allowed movement to the center.

```objective-c
NSArray *rules = @[ [KeepMin must:10], [KeepEqual may:10] ];
[view keep:[KeepTopInset rules:rules]];
[view keep:[KeepBottomInset rules:rules]];
[view keep:[KeepRightInset rules:rules]];
[view keep:[KeepLeftInset rules:rules]];
    
[view keep:[KeepAspectRatio rules:@[ [KeepMin must:16/9.] ]]];

[view keep:[KeepHorizontally rules:@[ [KeepEqual must:1/2.] ]]];
[view keep:[KeepVertically rules:@[ [KeepMax must:1/2.], [KeepMin must:1/3.], [KeepEqual may:1/3.] ]]];
```

**_See pictures and demo app included in project._**

![Portrait](https://raw.github.com/iMartinKiss/KeepLayout/master/readme/example-portrait.png)
![Landscape](https://raw.github.com/iMartinKiss/KeepLayout/master/readme/example-landscape.png)

---
_Version 0.1.0_

MIT License, Copyright © 2013 Martin Kiss

`THE SOFTWARE IS PROVIDED "AS IS", and so on...`
