//
//  ViewFoodItemsViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 1/19/15.
//  Copyright (c) 2015 Joshua Primas. All rights reserved.
//

#import "ViewFoodItemsViewController.h"
#import "KeyboardToolbarView.h"
#import "DatabaseConnector.h"
#import "Record.h"
#import "Food.h"


@interface ViewFoodItemsViewController () {
    NSArray *_allFoods;
    NSArray *_searchResults;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *records; //placeholder for data being displayed at the moment

@end

@implementation ViewFoodItemsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _allFoods = [[DatabaseConnector getSharedDBAccessor] getAllFoodRecords];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Foods";
    UIImage* whiteBackButtonImg = [UIImage imageNamed:@"backArrow_white.png"];
    UIImage* blackBackButtonImg = [UIImage imageNamed:@"backArrow_black.png"];
    CGRect frameimg = CGRectMake(0, 0, whiteBackButtonImg.size.width, whiteBackButtonImg.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setBackgroundImage:whiteBackButtonImg forState:UIControlStateNormal];
    [backButton setBackgroundImage:blackBackButtonImg forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    self.tableView.tintColor = [UIColor colorWithRed:209/255.0 green:238/255.0 blue:216/255.0 alpha:1];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    /*
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    [keyboardToolbar setBarTintColor:[UIColor colorWithRed:170/255.0 green:175/255.0 blue:181/255.0 alpha:1]];
    KeyboardToolbarView *keyboardToolbarView = [[KeyboardToolbarView alloc] initWithFrame:keyboardToolbar.frame];
    [keyboardToolbarView.doneButton addTarget:self action:@selector(doneButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:keyboardToolbarView];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    self.textField.inputAccessoryView = keyboardToolbar;
     */
}

- (void)backButtonPress{
    [self.navigationController popViewControllerAnimated:YES];
}


////////////////////
///FOR TABLE VIEW///
////////////////////

//Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//Creates the header for the tableview section
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:.9]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.bounds.size.width, 33)];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        headerLabel.text = @"Search Results";
        _records = [NSMutableArray arrayWithArray:_searchResults];
    } else {
        headerLabel.text = @"All Foods";
        _records = [NSMutableArray arrayWithArray:_allFoods];
    }
    headerLabel.font = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0  ];
    headerLabel.textAlignment = NSTextAlignmentLeft;

    [headerView addSubview:headerLabel];
    return headerView;
}

//How many rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResults count];
    } else {
        return [_allFoods count];
    }
}

//Height of section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

//Handler when a row is selected from tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Record *r = _records[indexPath.row];
    //Go to edit page??
}

//Formats cells of tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    Food *f = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        f = _searchResults[indexPath.row];
    } else {
        f = _allFoods[indexPath.row];
    }
    cell.textLabel.text = f.item;
    cell.textLabel.font  = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0 ];
    cell.detailTextLabel.text = [@"   " stringByAppendingString:f.quantifier];;
    cell.textLabel.font  = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0 ];
    cell.backgroundColor = [UIColor colorWithRed:218/255.0 green:241/255.0 blue:226/255.0 alpha:1];
    return cell;
    
}

/////////////////////////////
//Search / Filter Functions//
/////////////////////////////

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    _searchResults = [[DatabaseConnector getSharedDBAccessor] getSimilarFoods:searchString];
    
    return YES;
}


@end
