# Keep Layout

Keep Layout is project **under active development** whose purpose is to make _Auto Layout_ much easier to use _from code_! No more _Interface Builder_ or _Visual Format_. _Keep Layout_ provides **simple, more readable and powerful API for creating and _accessing existing_ constraints**.

_**Keep Layout** turned v1.0 recently and that means it is not backward compatible with older versions. This new release was written from scratch, it brings completely redesigned API, that is easier to write, easier to read and yet provides more possibilities._

Before you start, you should be familiar with _Auto Layout_ topic. [How it works and what's the point?](http://developer.apple.com/library/ios/#documentation/UserExperience/Conceptual/AutolayoutPG/Articles/Introduction.html#//apple_ref/doc/uid/TP40010853-CH1-SW1)



## Attributes

Every view has several _attributes_ that are represented by `KeepAttribute` class.

  - Dimensions: **width**, **height**, **aspect ratio**
  - Insets to superview: **top**, **bottom**, **left**, **right**
  - Position in superview: **horizontal** and **vertical**
  - Offsets to other views: **top**, **bottom**, **left**, **right**
  - Alignments with other views: **top**, **bottom**, **left**, **right**, **horizontal**, **vertical**, **baseline**
 
They can be accessed by calling methods on `UIView` object with one of these format:

```
- (KeepLayout *)keep<AttributeName>;
- (KeepLayout *(^)(UIView *))keep<AttributeName>To; // Returns block taking another view.
```

Example:

```
KeepAttribute *width = view.keepWidth;
KeepAttribute *topOffset = view.keepTopOffsetTo(anotherView); // Invoking the block that returns the actual attribute.
```

Calling such method for the first time creates the attribute object and any subsequent calls will return the same object. For attributes related to other views this is true for each pair of views. Sometimes even in inversed order or direction:

```
// aligns are the same regardless of order
viewOne.keepLeftAlign(viewTwo) == viewTwo.keepLeftAlign(viewOne)
// left offset from 1 to 2 is right offset from 2 to 1
viewOne.keepLeftOffset(viewTwo) == viewTwo.keepRightOffset(viewOne)
```

See `UIView+KeepLayout.h` for more.



## Values

Attributes have three properties: **equal**, **min** and **max**. These are not just plain scalar values, but rather a `struct` representing **value with priority**.

They can be created with one of four convenience functions, one for every basic layout priority:

```
KeepValue value = KeepRequired(42);
value = KeepHigh(42);
value = KeepLow(42);
value = KeepFitting(42);

// Arbitrary priority:
value = KeepValueMake(42, 800);
```

Priorities are redeclared as `KeepPriority` enum using `UILayoutPriority` values and they use similar naming:

```
Required > High > Low > Fitting
1000       750    250   50
```

See `KeepTypes.h` for more.



## Putting it together – Examples

Keep width of the view to be equal to 150 with High priority:

```
view.keepWidth.equal = KeepHigh(150);
```

Keep top inset to superview of the view to be at least 10, no excuses:

```
view.keepTopInset.min = KeepRequired(10);

```

Don't let the first view to get closer than 10 to the second from the left:

```
firstView.keepLeftOffsetTo(secondView).min = KeepRequired(10);
```

#### See the _Examples_ app included in the project for more.



---



## Grouped Attributes

You will often want to set multiple attributes to the same value. For this we have **grouped attributes**.

You can create groups at your own:

```
KeepAttribute *leftInsets = [KeepAttribute group:
                             viewOne.keepLeftInset,
                             viewTwo.keepLeftInset,
                             viewThree.keepLeftInset,
                             nil];
leftInsets.equal = KeepRequired(10);
```

However there are already some accessors to few of them:

```
view.keepSize    // group of both Width and Height
view.keepInsets  // group of all four insets
view.keepCenter  // group of both axis of position
```

See `UIView+KeepLayout.h` for more or `KeepAttribute.h`.



## Convenience Methods

For the most used cases there are convenience methods. Nothing you could write yourself, but simplify your code and improve readability. Some of them:

```
[view keepSize:CGSizeMake(100, 200)];
[view keepInsets:UIEdgeInsetsMake(10, 20, 30, 40)];
[view keepCentered];
```

See `UIView+KeepLayout.h` for more.



## Array Attributes – What?

Most of the methods added to `UIView` class can also be called on any **array on views**. Such call creates grouped attribute of all contained view attributes:

```
NSArray *views = @[ viewOne, viewTwo, viewThree ];
views.keepInsets.min = KeepRequired(10);
```

**The above code creates and configures 12 layout constraints!**

In addition, arrays allow you to use related attributes more easily, using another convenience methods:

```
NSArray *views = @[ viewOne, viewTwo, viewThree ];
[views keepWidthsEqual];
[views keepHorizontalOffsets:KeepRequired(20)];
[views keepTopAligned];
```

See `NSArray+KeepLayout.h` for more.



## Animations

Constraints can be animated. You can use plain simple `UIView` block animation, but don't  forget to call `-layoutIfNeeded` in the animation block. That triggers `-layoutSubviews` which applies new constraints.

Or you can use one of provided methods to don't need to case about that:

```
view.keepWidth.equal = KeepRequired(100);

[view.superview keepAnimatedWithDuration:1 layout:^{
    view.keepWidth.equal = KeepRequired(200);
}];
```

These are instance methods and must be called on parent view of all affected subviews. At the end of layout block this view receives `-layoutIfNeeded` method. Any changes to views out of the receiver's subview tree will not be animated.

See `UIView+KeepLayout.h` for more.



## Implementation Details

Once the attribute is accessed it is created and associated with given view (runtime asociation). In case of related attribbutes, the second view is used as weak key in `NSMapTable`.  
See `UIView+KeepLayout.m` for details.

Each attribute manages up to three constraints (`NSLayoutConstraint`) that are created, updated and removed when needed. One constraint for each of three relations (`NSLayoutRelation` enum) and setting `equal`, `min` or `max` properties modifies them.  
See `KeepAttribute.m` for details.

`KeepAttribute` class is a class cluster with specific subclasses. One that manages constraints using `constant` value, one for constraints using `multiplier` and one grouping subclass that forwards primitive methods to its contained children.  
See `KeepAttribute.m` for details.

Array methods usually call the same selector on contained views and return group of returned attributes.  
See `NSArray+KeepLayout.m` for details.



---
_Version 1.0.0_

MIT License, Copyright © 2013 Martin Kiss

`THE SOFTWARE IS PROVIDED "AS IS", and so on...` see `LICENSE.md` more.
