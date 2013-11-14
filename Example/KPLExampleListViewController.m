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

@property (nonatomic, readwrite, strong) NSArray *examples;

@end





@implementation KPLExampleListViewController





- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Keep Layout";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Examples" style:UIBarButtonItemStyleBordered target:nil action:nil];
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
    @"github.com/iMartinKiss/KeepLayout" @"\n"
    @"\n"
    @"Copyright © 2013 Martin Kiss" @"\n"
    @"Licensed under MIT License";
    self.tableView.tableFooterView = footnote;
    
    [self loadExamples];
}


- (void)loadExamples {
    NSMutableArray *simpleExamples = [[NSMutableArray alloc] init];
    
    UIView *(^createView)(UIColor *, UIView *) = ^UIView *(UIColor *color, UIView *superview) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = color;
        [superview addSubview:view];
        return view;
    };
    
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Equal Insets"
                             subtitle:@"1 line of code"
                           setupBlock:^KPLExampleStateBlock(UIView *container) {
                               UIView *view = createView(self.view.tintColor, container);
                               
                               // 1
                               view.keepInsets.equal = KeepRequired(10);
                               
                               // Equivalent:
                               /*
                                black.keepTopInset.equal = KeepRequired(10);
                                black.keepBottomInset.equal = KeepRequired(10);
                                black.keepLeftInset.equal = KeepRequired(10);
                                black.keepRightInset.equal = KeepRequired(10);
                                */
                               
                               // Animating insets
                               return ^(NSUInteger state) {
                                   BOOL odd = (state % 2);
                                   view.keepInsets.equal = KeepRequired(odd? 80 : 10);
                               };
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Various Insets"
                                subtitle:@"1 line of code"
                           setupBlock:^KPLExampleStateBlock(UIView *container) {
                               UIView *view = createView(self.view.tintColor, container);
                               
                               // 1
                               [view keepInsets:UIEdgeInsetsMake(10, 20, 30, 40)];
                               
                               // Equivalent:
                               /*
                                black.keepTopInset.equal = KeepRequired(10);
                                black.keepBottomInset.equal = KeepRequired(30);
                                black.keepLeftInset.equal = KeepRequired(20);
                                black.keepRightInset.equal = KeepRequired(40);
                                */
                               
                               // Animating insets
                               return ^(NSUInteger state) {
                                   BOOL odd = (state % 2);
                                   [view keepInsets:UIEdgeInsetsMake(odd? 80 : 10, 20, 30, odd? 5 : 40)];
                               };
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Center & Size"
                                subtitle:@"2 lines of code"
                           setupBlock:^KPLExampleStateBlock(UIView *container) {
                               UIView *view = createView(self.view.tintColor, container);
                               
                               // 1
                               [view keepSize:CGSizeMake(200, 200) priority:KeepPriorityHigh];
                               
                               // Equivalent:
                               /*
                                black.keepWidth.equal = KeepRequired(100);
                                black.keepHeight.equal = KeepRequired(200);
                                */
                               
                               // 2
                               [view keepCentered];
                               
                               // Equivalent:
                               /*
                                black.keepHorizontalCenter.equal = KeepRequired(0.5);
                                black.keepVerticalCenter.equal = KeepRequired(0.5);
                                */
                               
                               // Animating center, which changes size
                               view.keepInsets.min = KeepRequired(10);
                               return ^(NSUInteger state) {
                                   BOOL odd = (state % 2);
                                   view.keepHorizontalCenter.equal = KeepRequired(odd? 0.1 : 0.5);
                               };
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Video 16:9"
                                subtitle:@"3 lines of code"
                           setupBlock:^KPLExampleStateBlock(UIView *container) {
                               UIView *black = createView(self.view.tintColor, container);
                               
                               // 1
                               black.keepAspectRatio.equal = KeepRequired(16./9.);
                               
                               // 2
                               [black keepCentered];
                               
                               // 3
                               [black.keepInsets keepAt:10 min:10];
                               
                               // Equivalent:
                               /*
                                black.keepInsets.equal = KeepHigh(10);
                                black.keepInsets.min = KeepRequired(10);
                                */
                               
                               // Animating horizontal or vertical aspect ratio
                               return ^(NSUInteger state) {
                                   BOOL odd = (state % 2);
                                   black.keepAspectRatio.equal = KeepRequired(odd? 9./16 : 16./9.);
                               };
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Dynamic Text"
                              subtitle:@"Reflow content when text changes"
                            setupBlock:^KPLExampleStateBlock(UIView *container) {
                                
                                UIView *top = createView(self.view.tintColor, container);
                                top.keepHorizontalInsets.equal = KeepRequired(10);
                                top.keepTopInset.equal = KeepRequired(10);
                                top.keepHeight.min = KeepRequired(80);
                                
                                UIView *bottom = createView(self.view.tintColor, container);
                                bottom.keepHorizontalInsets.equal = KeepRequired(10);
                                bottom.keepHeight.min = KeepRequired(30);
                                bottom.keepBottomInset.equal = KeepRequired(10);
                                
                                UILabel *label = [[UILabel alloc] init];
                                label.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
                                label.numberOfLines = 0;
                                label.textAlignment = NSTextAlignmentCenter;
                                [container addSubview:label];
                                
                                label.keepInsets.min = KeepRequired(10);
                                label.keepHorizontalCenter.equal = KeepRequired(0.5);
                                label.keepVerticalCenter.equal = KeepFitting(0.5);
                                
                                label.keepTopOffsetTo(top).min = KeepRequired(10);
                                label.keepBottomOffsetTo(bottom).min = KeepRequired(10);
                                
                                return ^(NSUInteger state) {
                                    BOOL odd = (state % 2);
                                    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:(odd? 20 : 15)];
                                };
                            }]];
    
    NSMutableArray *complexExamples = [[NSMutableArray alloc] init];
    [complexExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Everything"
                              subtitle:@"All attributes used"
                            setupBlock:^KPLExampleStateBlock(UIView *container) {
                                UIView *center = createView(self.view.tintColor, container);
                                UIView *topStick = createView(self.view.tintColor, container);
                                UIView *bottomStick = createView(self.view.tintColor, container);
                                UIView *leftBox = createView(self.view.tintColor, container);
                                UIView *rightBox = createView(self.view.tintColor, container);
                                UIView *topLeftCorner = createView(self.view.tintColor, container);
                                UIView *bottomRightCorner = createView(self.view.tintColor, container);
                                
                                KeepValue offsetHigh = KeepHigh(10);
                                KeepValue offsetRequired = KeepRequired(10);
                                KeepValue thickness = KeepRequired(30);
                                
                                NSArray *views = @[ center, topStick, bottomStick, leftBox, rightBox, topLeftCorner, bottomRightCorner ];
                                views.keepInsets.min = offsetRequired;

                                center.keepCenter.equal = KeepRequired(0.5);
                                
                                center.keepTopOffsetTo(topStick).equal = offsetHigh;
                                center.keepBottomOffsetTo(bottomStick).equal = offsetHigh;
                                center.keepLeftOffsetTo(leftBox).equal = offsetHigh;
                                center.keepRightOffsetTo(rightBox).equal = offsetHigh;
                                
                                leftBox.keepLeftInset.equal = offsetRequired;
                                rightBox.keepRightInset.equal = offsetRequired;
                                topStick.keepTopInset.equal = offsetRequired;
                                bottomStick.keepBottomInset.equal = offsetRequired;
                                
                                leftBox.keepAspectRatio.equal = KeepRequired(1);
                                rightBox.keepAspectRatio.equal = KeepRequired(1);
                                
                                topStick.keepWidth.equal = thickness;
                                bottomStick.keepWidth.equal = thickness;
                                
                                center.keepTopAlignTo(leftBox).equal = KeepRequired(0);
                                center.keepBottomAlignTo(rightBox).equal = KeepRequired(0);
                                
                                topLeftCorner.keepHeight.equal = thickness;
                                topLeftCorner.keepRightOffsetTo(center).equal = KeepRequired(0);
                                topLeftCorner.keepHorizontalAlignTo(topStick).equal = KeepRequired(0);
                                topLeftCorner.keepLeftAlignTo(leftBox).equal = offsetRequired;
                                
                                bottomRightCorner.keepHeight.equal = thickness;
                                bottomRightCorner.keepLeftOffsetTo(center).equal = KeepRequired(0);
                                bottomRightCorner.keepHorizontalAlignTo(bottomStick).equal = KeepRequired(0);
                                bottomRightCorner.keepRightAlignTo(rightBox).equal = offsetRequired;
                                
                                center.keepWidthTo(leftBox).equal = KeepRequired(1);
                                leftBox.keepWidthTo(rightBox).equal = KeepRequired(1);
                                
                                center.keepHeightTo(topStick).equal = KeepRequired(1);
                                topStick.keepHeightTo(bottomStick).equal = KeepRequired(1);
                                
                                NSArray *vertical = @[ topStick, center, bottomStick ];
                                [vertical keepVerticallyAligned];
                                
                                return ^(NSUInteger state) {
                                    BOOL odd = (state % 2);
                                    center.keepWidthTo(leftBox).equal = KeepRequired(odd? 2 : 1);
                                    center.keepHeightTo(topStick).equal = KeepRequired(odd? 2 : 1);
                                };
                            }]];
    
    [complexExamples addObject:
     [[KPLExample alloc] initWithTitle:@"Tiles"
                              subtitle:@"Using many NSArray attributes"
                            setupBlock:^KPLExampleStateBlock(UIView *container) {
                                
                                NSUInteger rowCount = 4;
                                NSUInteger columnCount = 4;
                                CGFloat padding = 10;
                                
                                // Arrays
                                NSMutableArray *tiles = [[NSMutableArray alloc] init];
                                NSMutableArray *cells = [[NSMutableArray alloc] init];
                                
                                NSMutableArray *columns = [[NSMutableArray alloc] init];
                                for (NSUInteger c = 0; c < columnCount; c++) {
                                    NSMutableArray *column = [[NSMutableArray alloc] init];
                                    [columns addObject:column];
                                }
                                NSMutableArray *rows = [[NSMutableArray alloc] init];
                                for (NSUInteger r = 0; r < rowCount; r++) {
                                    NSMutableArray *row = [[NSMutableArray alloc] init];
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
                                
                                
                                [tiles keepSizesEqual];
                                tiles.keepInsets.min = KeepRequired(padding);
                                
                                [[[columns objectAtIndex:0] keepLeftInset] setEqual:KeepRequired(padding)];
                                for (NSMutableArray *column in columns) {
                                    [column keepVerticalOffsets:KeepHigh(padding)];
                                    [column keepVerticalAlignments:KeepHigh(0)];
                                }
                                [[columns.lastObject keepRightInset] setEqual:KeepRequired(padding)];
                                
                                [[[rows objectAtIndex:0] keepTopInset] setEqual:KeepRequired(padding)];
                                for (NSMutableArray *row in rows) {
                                    [row keepHorizontalOffsets:KeepHigh(padding)];
                                    [row keepHorizontalAlignments:KeepHigh(0)];
                                }
                                [[rows.lastObject keepBottomInset] setEqual:KeepRequired(padding)];
                                
                                cells.keepInsets.min = KeepRequired(0);
                                cells.keepInsets.equal = KeepHigh(0);
                                [cells keepCentered];
                                
                                return ^(NSUInteger state) {
                                    BOOL odd = (state % 2);
                                    cells.keepAspectRatio.equal = (odd? KeepValueMake(1, KeepPriorityHigh+1) : KeepNone);
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
