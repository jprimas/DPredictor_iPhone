//
//  AddFoodViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/20/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "AddFoodViewController.h"
#import "Record.h"
#import "Meal.h"
#import "Food.h"
#import "DatabaseConnector.h"
#import "CreateFoodViewController.h"

@interface AddFoodViewController (){
    NSArray *_foods;
    NSArray *_commonFoods;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) UIButton    *addNewFoodButton;
@property (nonatomic, weak) UISearchBar *searchBar;

@property (nonatomic, strong) Record *record;

@end

@implementation AddFoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _commonFoods = [[DatabaseConnector getSharedDBAccessor] getRecentFoods];
        for(Food *f in _commonFoods){
            NSLog(@"%@", f.item);
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Select a Food";
    //backButton
    UIImage* whiteBackButtonImg = [UIImage imageNamed:@"backArrow_white.png"];
    UIImage* blackBackButtonImg = [UIImage imageNamed:@"backArrow_black.png"];
    CGRect frameimg = CGRectMake(0, 0, whiteBackButtonImg.size.width, whiteBackButtonImg.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setBackgroundImage:whiteBackButtonImg forState:UIControlStateNormal];
    [backButton setBackgroundImage:blackBackButtonImg forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //Add button
    UIImage* whitePlusSignImg = [UIImage imageNamed:@"plusSign_white.png"];
    UIImage* blackPlusSignImg = [UIImage imageNamed:@"plusSign_black.png"];
    UIButton *plusButton = [[UIButton alloc] initWithFrame:frameimg];
    [plusButton setBackgroundImage:whitePlusSignImg forState:UIControlStateNormal];
    [plusButton setBackgroundImage:blackPlusSignImg forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(createNewFood:)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createNewFood:(id)sender{
    CreateFoodViewController *createFoodVC = [[CreateFoodViewController alloc] init];
    createFoodVC.meal = self.meal;
    [self.navigationController pushViewController:createFoodVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:.9]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, tableView.bounds.size.width, 33)];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        headerLabel.text = @"Foods";
    } else {
        headerLabel.text = @"Recent Foods";
    }
    headerLabel.font = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0  ];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_foods count];
    } else {
        return [_commonFoods count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Record *record = [[DatabaseConnector getSharedDBAccessor] createRecord];
    Food *f = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView){
        f = _foods[indexPath.row];
    } else{
        f = _commonFoods[indexPath.row];
    }
    record.food = f;
    record.meal = self.meal;
    record.amount = 1;
    record.quantifier = f.quantifier;
    record.carbs = f.carbs;
    [self.meal addRecord:record];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        
    }
    
    Food *f = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        f = _foods[indexPath.row];
    } else {
        f = _commonFoods[indexPath.row];
    }
    cell.textLabel.text = f.item;
    cell.textLabel.font  = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0 ];
    
    return cell;
    
}


/////////////////////////////
//Search / Filter Functions//
/////////////////////////////
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    _foods = [[DatabaseConnector getSharedDBAccessor] getSimilarFoods:searchString];
    
    return YES;
}





@end
