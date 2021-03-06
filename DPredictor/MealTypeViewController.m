//
//  MealTypeViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/19/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "MealTypeViewController.h"
#import "DatabaseConnector.h"
#import "Meal.h"
#import "EditMealViewController.h"

@interface MealTypeViewController (){
     NSArray *_options;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation MealTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.meal = [[DatabaseConnector getSharedDBAccessor] createMeal];
        _options = [NSArray arrayWithObjects:@"Breakfast", @"Lunch", @"Afternoon Snack", @"Dinner", @"Bedtime Snack", @"Night Snack", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Add a Meal";
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
    [self.tableView registerClass:[UITableViewCell class]
            forCellReuseIdentifier:@"Cell"];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:.9]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 33)];
    headerLabel.text = @"Meal Times";
    headerLabel.font = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_options count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.meal.mealType = _options[indexPath.row];
    EditMealViewController *editMealVC = [[EditMealViewController alloc] init];
    editMealVC.meal = self.meal;
    [self.navigationController pushViewController:editMealVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:cellIdentifier];
        
    }
    
    cell.textLabel.text = _options[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font  = [UIFont fontWithName: @"Helvetica-Neue" size: 14.0 ];
    cell.backgroundColor = [UIColor colorWithRed:218/255.0 green:241/255.0 blue:226/255.0 alpha:1];
    
    return cell;
    
}

@end
