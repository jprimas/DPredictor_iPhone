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
#import "EditFoodItemViewController.h"


@interface ViewFoodItemsViewController ()

@property (nonatomic, strong) NSMutableDictionary *batchedFoods;
@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *allFoods;
@property (nonatomic, strong) NSArray *searchResults;

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
    self.tableView.sectionIndexColor = [UIColor blackColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([_allFoods count] <= 0) {
        self.tableView.hidden = YES;
        self.searchBar.hidden = YES;
        self.noFoodsLabel.hidden = NO;
    } else {
        self.tableView.hidden = NO;
        self.searchBar.hidden = NO;
        self.noFoodsLabel.hidden = YES;
    }
    
    [self batchFoods];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)backButtonPress{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)batchFoods{
    _batchedFoods = [[NSMutableDictionary alloc] init];
    
    //Batch all food by the starting letter
    for (int i = 0; i < [_allFoods count]; i++ ) {
        NSString *name = ((Food*)_allFoods[i]).item;
        NSString *letter = [[name substringToIndex:1] uppercaseString];
        if([_batchedFoods objectForKey:letter] != nil){
            NSMutableArray * arr = [_batchedFoods objectForKey:letter];
            [arr addObject:_allFoods[i]];
        } else {
            NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects: _allFoods[i], nil];
            [_batchedFoods setValue:arr forKey:letter];
        }
    }
    
    _letters = [_batchedFoods allKeys];
    _letters = [_letters sortedArrayUsingComparator:^(NSString *firstObject, NSString *secondObject) {
        return [firstObject caseInsensitiveCompare:secondObject];
    }];
}


////////////////////
///FOR TABLE VIEW///
////////////////////

//Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    } else {
        return [_letters count];
    }
}

//Creates the header for the tableview section
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:.9]];
    UILabel *headerLabel;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.bounds.size.width, 33)];
        headerLabel.text = @"Search Results";
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.font = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0  ];
    } else {
        headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, tableView.bounds.size.width, 22)];
        headerLabel.text = [_letters objectAtIndex:section];
        headerLabel.textAlignment = NSTextAlignmentLeft;
        headerLabel.font = [UIFont fontWithName: @"Helvetica-Neue" size: 12.0  ];
    }
    [headerView addSubview:headerLabel];
    return headerView;
}

//How many rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResults count];
    } else {
        NSString *letter = [[_letters objectAtIndex:section] uppercaseString];
        return [[_batchedFoods objectForKey:letter] count];
    }
}

//Height of section header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 44;
    } else {
        return 22;
    }
}

//Handler when a row is selected from tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Food *food = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        food = _searchResults[indexPath.row];
    } else{
        NSString *letter = [[_letters objectAtIndex:indexPath.section] uppercaseString];
        food = [_batchedFoods objectForKey:letter][indexPath.row];
    }
    EditFoodItemViewController *editFoodItemVC = [[EditFoodItemViewController alloc] init];
    editFoodItemVC.food = food;
    [self.navigationController pushViewController:editFoodItemVC animated:YES];
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
        NSString *letter = [[_letters objectAtIndex:indexPath.section] uppercaseString];
        f = [_batchedFoods objectForKey:letter][indexPath.row];
    }
    cell.textLabel.text = f.item;
    cell.textLabel.font  = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0 ];
    cell.detailTextLabel.text = [@"   " stringByAppendingString:f.quantifier];;
    cell.textLabel.font  = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0 ];
    cell.backgroundColor = [UIColor colorWithRed:218/255.0 green:241/255.0 blue:226/255.0 alpha:1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _letters;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_letters indexOfObject:title];
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
