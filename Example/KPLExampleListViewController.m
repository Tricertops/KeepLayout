//
//  KPLExampleListViewController.m
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KPLExampleListViewController.h"
#import "KPLExampleViewController.h"
#import "KPLExample.h"

#import "KeepLayout.h"





@interface KPLExampleListViewController ()

@property (nonatomic, readwrite, strong) NSArray<NSArray<KPLExample *> *> *examples;

@end





@implementation KPLExampleListViewController





- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Keep Layout";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Examples" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *footnote = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 100)];
    footnote.textColor = [UIColor grayColor];
    footnote.numberOfLines = 0;
    footnote.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    footnote.textAlignment = NSTextAlignmentCenter;
    footnote.text =
    @"github.com/Tricertops/KeepLayout" @"\n"
    @"\n"
    @"Copyright © 2013-2017 Martin Kiss" @"\n"
    @"Licensed under MIT License";
    self.tableView.tableFooterView = footnote;
    
    [self loadExamples];
}


- (void)loadExamples {
    NSMutableArray<KPLExample *> *simpleExamples = [[NSMutableArray alloc] init];
    
    UIView *(^createView)(UIColor *, UIView *) = ^UIView *(UIColor *color, UIView *superview) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = color;
        [superview addSubview:view];
        return view;
    };
    
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Equal Insets"
                             subtitle:@"1 line of code"
                           setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                               UIView *container = controller.view;
                               
                               UIView *view = createView(self.view.tintColor, container);
                               
                               // 1
                               view.keepSafeInsets.equal = 10;
                               
                               // Equivalent:
                               /*
                                view.keepTopSafeInset.equal = 10;
                                view.keepBottomSafeInset.equal = 10;
                                view.keepLeftSafeInset.equal = 10;
                                view.keepRightSafeInset.equal = 10;
                                */
                               
                               // Animating insets
                               return ^(NSUInteger state) {
                                   BOOL odd = (state % 2);
                                   view.keepSafeInsets.equal = (odd? 80 : 10);
                               };
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Various Insets"
                                subtitle:@"1 line of code"
                           setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                               UIView *container = controller.view;
                               
                               UIView *view = createView(self.view.tintColor, container);
                               
                               // 1
                               [view keepSafeInsets:UIEdgeInsetsMake(10, 20, 30, 40)];
                               
                               // Equivalent:
                               /*
                                view.keepTopSafeInset.equal = 10;
                                view.keepBottomSafeInset.equal = 30;
                                view.keepLeftSafeInset.equal = 20;
                                view.keepRightSafeInset.equal = 40;
                                */
                               
                               // Animating insets
                               return ^(NSUInteger state) {
                                   BOOL odd = (state % 2);
                                   [view keepSafeInsets:UIEdgeInsetsMake(odd? 80 : 10, 20, 30, odd? 5 : 40)];
                               };
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Center & Size"
                                subtitle:@"3 lines of code"
                           setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                               UIView *container = controller.view;
                               
                               UIView *view = createView(self.view.tintColor, container);
                               
                               // 1
                               view.keepWidth.equal = 100 +keepHigh;
                               
                               // 2
                               view.keepHeight.equal = 200 +keepHigh;
                               
                               // 3
                               view.keepCenter.equal = 0.5;
                               
                               // Animating center, which changes size
                               view.keepSafeInsets.min = 10;
                               return ^(NSUInteger state) {
                                   BOOL odd = (state % 2);
                                   view.keepHorizontalCenter.equal = (odd? 0.1 : 0.5);
                               };
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Video 16:9"
                                subtitle:@"4 lines of code"
                           setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                               UIView *container = controller.view;
                               
                               UIView *video = createView(self.view.tintColor, container);
                               
                               // 1
                               video.keepAspectRatio.equal = 16./9.;
                               
                               // 2
                               video.keepCenter.equal = 0.5 +keepHigh;
                               
                               // 3
                               video.keepSafeInsets.equal = 10 +keepHigh;
                               
                               // 4
                               video.keepSafeInsets.min = 10;
                               
                               // Animating horizontal or vertical aspect ratio
                               return ^(NSUInteger state) {
                                   BOOL odd = (state % 2);
                                   video.keepAspectRatio.equal = (odd? 9./16 : 16./9.);
                               };
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Dynamic Text"
                              subtitle:@"Reflow content when text changes"
                            setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                                UIView *container = controller.view;
                                
                                UIView *top = createView(self.view.tintColor, container);
                                top.keepHorizontalSafeInsets.equal = 10;
                                top.keepTopSafeInset.equal = 10;
                                top.keepHeight.equal = 30;
                                
                                UIView *bottom = createView(self.view.tintColor, container);
                                bottom.keepHorizontalSafeInsets.equal = 10;
                                bottom.keepHeight.equal = 30;
                                bottom.keepBottomSafeInset.equal = 10;
                                
                                UILabel *label = [[UILabel alloc] init];
                                label.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
                                label.numberOfLines = 0;
                                label.textAlignment = NSTextAlignmentCenter;
                                [container addSubview:label];
                                
                                label.keepSafeInsets.min = 10;
                                label.keepHorizontalCenter.equal = 0.5;
                                label.keepVerticalCenter.equal = 0.5 keepFitting;
                                
                                label.keepTopOffsetTo(top).min = 10;
                                label.keepBottomOffsetTo(bottom).min = 10;
                                
                                return ^(NSUInteger state) {
                                    BOOL odd = (state % 2);
                                    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:(odd? 20 : 15)];
                                };
                            }]];
    
    NSMutableArray<KPLExample *> *complexExamples = [[NSMutableArray alloc] init];
    [complexExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Everything"
                              subtitle:@"All attributes used"
                            setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                                UIView *container = createView(UIColor.whiteColor, controller.view);
                                container.keepSafeInsets.equal = 0;
                                
                                UIView *center = createView(self.view.tintColor, container);
                                UIView *topStick = createView(self.view.tintColor, container);
                                UIView *bottomStick = createView(self.view.tintColor, container);
                                UIView *leftBox = createView(self.view.tintColor, container);
                                UIView *rightBox = createView(self.view.tintColor, container);
                                UIView *topLeftCorner = createView(self.view.tintColor, container);
                                UIView *bottomRightCorner = createView(self.view.tintColor, container);
                                
                                KeepValue offsetHigh = 10 +keepHigh;
                                KeepValue offsetRequired = 10;
                                KeepValue thickness = 30;
                                
                                NSArray<UIView *> *views = @[ center, topStick, bottomStick, leftBox, rightBox, topLeftCorner, bottomRightCorner ];
                                views.keepSafeInsets.min = offsetRequired;

                                center.keepCenter.equal = 0.5;
                                
                                center.keepTopOffsetTo(topStick).equal = offsetHigh;
                                center.keepBottomOffsetTo(bottomStick).equal = offsetHigh;
                                center.keepLeftOffsetTo(leftBox).equal = offsetHigh;
                                center.keepRightOffsetTo(rightBox).equal = offsetHigh;
                                
                                leftBox.keepLeftSafeInset.equal = offsetRequired;
                                rightBox.keepRightSafeInset.equal = offsetRequired;
                                topStick.keepTopSafeInset.equal = offsetRequired;
                                bottomStick.keepBottomSafeInset.equal = offsetRequired;
                                
                                leftBox.keepAspectRatio.equal = 1;
                                rightBox.keepAspectRatio.equal = 1;
                                
                                topStick.keepWidth.equal = thickness;
                                bottomStick.keepWidth.equal = thickness;
                                
                                center.keepTopAlignTo(leftBox).equal = 0;
                                center.keepBottomAlignTo(rightBox).equal = 0;
                                
                                topLeftCorner.keepHeight.equal = thickness;
                                topLeftCorner.keepRightOffsetTo(center).equal = 0;
                                topLeftCorner.keepHorizontalAlignTo(topStick).equal = 0;
                                topLeftCorner.keepLeftAlignTo(leftBox).equal = offsetRequired;
                                
                                bottomRightCorner.keepHeight.equal = thickness;
                                bottomRightCorner.keepLeftOffsetTo(center).equal = 0;
                                bottomRightCorner.keepHorizontalAlignTo(bottomStick).equal = 0;
                                bottomRightCorner.keepRightAlignTo(rightBox).equal = offsetRequired;
                                
                                center.keepWidthTo(leftBox).equal = 1;
                                leftBox.keepWidthTo(rightBox).equal = 1;
                                
                                center.keepHeightTo(topStick).equal = 1;
                                topStick.keepHeightTo(bottomStick).equal = 1;
                                
                                NSArray<UIView *> *vertical = @[ topStick, center, bottomStick ];
                                [vertical keepVerticallyAligned];
                                
                                return ^(NSUInteger state) {
                                    BOOL odd = (state % 2);
                                    center.keepWidthTo(leftBox).equal = (odd? 3 : 1);
                                    center.keepHeightTo(topStick).equal = (odd? 3 : 1);
                                };
                            }]];
    
    [complexExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Tiles"
                              subtitle:@"Using many NSArray attributes"
                            setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                                UIView *container = controller.view;
                                
                                NSUInteger rowCount = 4;
                                NSUInteger columnCount = 4;
                                CGFloat padding = 10;
                                
                                // Arrays
                                NSMutableArray<UIView *> *tiles = [[NSMutableArray alloc] init];
                                NSMutableArray<UIView *> *cells = [[NSMutableArray alloc] init];
                                
                                NSMutableArray<NSMutableArray<UIView *> *> *columns = [[NSMutableArray alloc] init];
                                for (NSUInteger c = 0; c < columnCount; c++) {
                                    NSMutableArray<UIView *> *column = [[NSMutableArray alloc] init];
                                    [columns addObject:column];
                                }
                                NSMutableArray<NSMutableArray<UIView *> *> *rows = [[NSMutableArray alloc] init];
                                for (NSUInteger r = 0; r < rowCount; r++) {
                                    NSMutableArray<UIView *> *row = [[NSMutableArray alloc] init];
                                    [rows addObject:row];
                                }
                                
                                // Populate arrays
                                for (NSUInteger c = 0; c < columnCount; c++) {
                                    for (NSUInteger r = 0; r < rowCount; r++) {
                                        UIView *view = createView(UIColor.whiteColor, container);
                                        [tiles addObject:view];
                                        [[columns objectAtIndex:c] addObject:view];
                                        [[rows objectAtIndex:r] addObject:view];
                                        
                                        UIView *cell = createView(self.view.tintColor, view);
                                        [cells addObject:cell];
                                    }
                                }
                                
                                 // Constraint counts assume 4x4 grid
                                
                                [tiles keepSizesEqual]; // 30 constraints
                                tiles.keepSafeInsets.min = padding; // 64 constraints
                                
                                
                                NSArray<UIView *> *firstColumn = columns.firstObject;
                                firstColumn.keepLeftSafeInset.equal = padding; // 4 constraints
                                
                                for (NSMutableArray<UIView *> *column in columns) {
                                    [column keepVerticalOffsets:padding]; // 4 iterations * 3 constraints
                                    [column keepVerticalAlignments:0]; // 4 iterations * 3 constraints
                                }
                                
                                NSArray<UIView *> *lastColumn = columns.lastObject;
                                lastColumn.keepRightSafeInset.equal = padding; // 4 constraints
                                
                                
                                NSArray<UIView *> *firstRow = rows.firstObject;
                                firstRow.keepTopSafeInset.equal = padding; // 4 constraints
                                
                                for (NSMutableArray<UIView *> *row in rows) {
                                    [row keepHorizontalOffsets:padding]; // 4 iterations * 3 constraints
                                    [row keepHorizontalAlignments:0]; // 4 iterations * 3 constraints
                                }
                                
                                NSArray<UIView *> *lastRow = rows.lastObject;
                                lastRow.keepBottomSafeInset.equal = padding; // 4 constraints
                                
                                
                                cells.keepInsets.min = 0; // 64 constraints
                                cells.keepInsets.equal = 0 +keepHigh; // 64 constraints
                                [cells keepCentered]; // 32 constraints
                                
                                
                                return ^(NSUInteger state) {
                                    BOOL odd = (state % 2);
                                    cells.keepAspectRatio.equal = (odd? KeepValueMake(1, KeepPriorityHigh+1) : KeepNone); // 16 constraints
                                };
                                
                                // Total: 334 constraints in this example
                            }]];
    [complexExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Aspect Fit"
                              subtitle:@"Multiple Aspect Ratios"
                            setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                                UIView *container = controller.view;
                                
                                UIView *topHalf = createView(UIColor.clearColor, container);
                                UIView *topBar = createView(self.view.tintColor, container);
                                [topHalf addSubview:topBar];
                                
                                UIView *bottomHalf = createView(UIColor.clearColor, container);
                                UIView *bottomBar = createView(self.view.tintColor, container);
                                [bottomHalf addSubview:bottomBar];
                                
                                //! Keep halves edge-to-edge
                                topHalf.keepTopSafeInset.equal = 0;
                                topHalf.keepHorizontalSafeInsets.equal = 0;
                                bottomHalf.keepHorizontalSafeInsets.equal = 0;
                                bottomHalf.keepBottomSafeInset.equal = 0;
                                //! Keep halves equaly high and touching
                                topHalf.keepBottomOffsetTo(bottomHalf).equal = 0;
                                topHalf.keepHeightTo(bottomHalf).equal = 1;
                                
                                //! Keep to bar horizontaly 1:4, centered
                                topBar.keepAspectRatio.equal = 0.25;
                                [topBar keepCentered];
                                //! Keep size as much close to fill, but aspect ratio has higher priority
                                topBar.keepSizeTo(topHalf).equal = 1 +keepHigh;
                                topBar.keepSafeInsets.min = 0;
                                
                                //! Keep to bar horizontaly 4:1, centered
                                bottomBar.keepAspectRatio.equal = 4;
                                [bottomBar keepCentered];
                                //! Keep size as much close to fill, but aspect ratio has higher priority
                                bottomBar.keepSizeTo(bottomHalf).equal = 1 +keepHigh;
                                bottomBar.keepSafeInsets.min = 0;
                                
                                //! On action, invert the aspect ratios
                                return ^(NSUInteger state) {
                                    topBar.keepAspectRatio.equal = (state%2? 2 : 0.25);
                                    bottomBar.keepAspectRatio.equal = (state%2? 0.5 : 4);
                                };
                            }]];
    [complexExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Atomic Layout"
                              subtitle:@"Deactivation of Atomic Layout Groups"
                            setupBlock:^KPLExampleStateBlock(UIViewController *controller) {
                                UIView *container = controller.view;
                                
                                UIView *first = createView(self.view.tintColor, container);
                                UIView *second = createView(self.view.tintColor, container);
                                first.keepSizeTo(second).equal = 1;
                                
                                CGFloat padding = 40;
                                
                                __block KeepAtomic *atomic = nil;
                                
                                return ^(NSUInteger state) {
                                    [atomic deactivate];
                                    if (state % 2 == 0) {
                                        atomic = [KeepAtomic layout:^{
                                            first.keepHorizontalSafeInsets.equal = padding;
                                            first.keepTopSafeInset.equal = padding;
                                            
                                            first.keepBottomOffsetTo(second).equal = padding;
                                            
                                            second.keepHorizontalSafeInsets.equal = padding;
                                            second.keepBottomSafeInset.equal = padding;
                                        }];
                                    }
                                    else {
                                        atomic = [KeepAtomic layout:^{
                                            first.keepVerticalSafeInsets.equal = padding;
                                            first.keepLeftInset.equal = padding;
                                            
                                            first.keepRightOffsetTo(second).equal = padding;
                                            
                                            second.keepVerticalSafeInsets.equal = padding;
                                            second.keepRightInset.equal = padding;
                                        }];
                                    }
                                };
                            }]];
    
    self.examples = @[ simpleExamples, complexExamples ];
}





#pragma mark Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.examples.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.examples objectAtIndex:section] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Simple Examples";
        case 1: return @"Complex Examples";
        default: return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( ! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    KPLExample *example = [[self.examples objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = example.title;
    cell.detailTextLabel.text = example.subtitle;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KPLExample *example = [[self.examples objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    KPLExampleViewController *exampleViewController = [[KPLExampleViewController alloc] initWithExample:example];
    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UINavigationController *detailNavigationController = [self.splitViewController.viewControllers objectAtIndex:1];
        detailNavigationController.viewControllers = @[ exampleViewController ];
    }
    else {
        [self.navigationController pushViewController:exampleViewController animated:YES];
    }
}





@end
