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
    NSMutableArray *examplesBuilder = [[NSMutableArray alloc] init];
    
    [examplesBuilder addObject:[[KPLExample alloc] initWithName:@"Simple Insets"
                                                     setupBlock:^(UIView *container) {
                                                         UIView *black = [[UIView alloc] init];
                                                         black.backgroundColor = [UIColor blackColor];
                                                         [container addSubview:black];
                                                         
                                                         black.keepInsets.equal = KeepRequired(10);
                                                         
                                                     }]];
    
    self.examples = [examplesBuilder copy];
}





#pragma mark Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.examples.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Examples";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if ( ! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    KPLExample *example = [self.examples objectAtIndex:indexPath.row];
    cell.textLabel.text = example.name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KPLExample *example = [self.examples objectAtIndex:indexPath.row];
    KPLExampleViewController *exampleViewController = [[KPLExampleViewController alloc] initWithExample:example];
    [self.navigationController pushViewController:exampleViewController animated:YES];
}





@end
