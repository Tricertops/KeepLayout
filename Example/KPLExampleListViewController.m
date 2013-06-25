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
    footnote.textColor = [UIColor blackColor];
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
     [[KPLExample alloc] initWithName:@"Equal Insets"
                                lines:1
                           setupBlock:^(UIView *container) {
                               UIView *black = createView(UIColor.blackColor, container);
                               
                               // 1
                               black.keepInsets.equal = KeepRequired(10);
                               
                               // Equivalent:
                               /*
                                black.keepTopInset.equal = KeepRequired(10);
                                black.keepBottomInset.equal = KeepRequired(10);
                                black.keepLeftInset.equal = KeepRequired(10);
                                black.keepRightInset.equal = KeepRequired(10);
                                */
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithName:@"Various Insets"
                                lines:1
                           setupBlock:^(UIView *container) {
                               UIView *black = createView(UIColor.blackColor, container);
                               
                               // 1
                               [black keepInsets:UIEdgeInsetsMake(10, 20, 30, 40)];
                               
                               // Equivalent:
                               /*
                                black.keepTopInset.equal = KeepRequired(10);
                                black.keepBottomInset.equal = KeepRequired(30);
                                black.keepLeftInset.equal = KeepRequired(20);
                                black.keepRightInset.equal = KeepRequired(40);
                                */
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithName:@"Center & Size"
                                lines:2
                           setupBlock:^(UIView *container) {
                               UIView *black = createView(UIColor.blackColor, container);
                               
                               // 1
                               [black keepSize:CGSizeMake(100, 200)];
                               
                               // Equivalent:
                               /*
                                black.keepWidth.equal = KeepRequired(100);
                                black.keepHeight.equal = KeepRequired(200);
                                */
                               
                               // 2
                               [black keepCentered];
                               
                               // Equivalent:
                               /*
                                black.keepHorizontalCenter.equal = KeepRequired(0.5);
                                black.keepVerticalCenter.equal = KeepRequired(0.5);
                                */
                           }]];
    [simpleExamples addObject:
     [[KPLExample alloc] initWithName:@"Video 16:9"
                                lines:3
                           setupBlock:^(UIView *container) {
                               UIView *black = createView(UIColor.blackColor, container);
                               
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
                               
                           }]];
    
    self.examples = @[ simpleExamples ];
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
    cell.textLabel.text = example.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i line%@ of code", example.lines, (example.lines == 1? @"" : @"s")];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KPLExample *example = [[self.examples objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    KPLExampleViewController *exampleViewController = [[KPLExampleViewController alloc] initWithExample:example];
    [self.navigationController pushViewController:exampleViewController animated:YES];
}





@end
