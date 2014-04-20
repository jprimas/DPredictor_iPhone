//
//  EditMealViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/19/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "EditMealViewController.h"
#import "SWTableViewCell.h"
#import "AddFoodViewController.h"
#import "Meal.h"

@interface EditMealViewController (){
    NSMutableArray *_records;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;

@end

@implementation EditMealViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Add Food";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backButtonPress)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.errorLabel.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.meal.levelBefore != 0) {
        self.textField.text = [NSString stringWithFormat:@"%d", self.meal.levelBefore ];
    }
    if([self.meal.records count] > 0){
        _records = [[NSMutableArray alloc] initWithArray:[self.meal.records allObjects]];
    }else{
        _records = [[NSMutableArray alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPress{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addFood{
    AddFoodViewController *addFoodVC = [[AddFoodViewController alloc] init];
    addFoodVC.meal = self.meal;
    [self.navigationController pushViewController:addFoodVC animated:YES];
}

- (IBAction)doneButtonPress:(id)sender{
    int sugarLevel = [self.textField.text integerValue];
    NSLog(@"%d", sugarLevel);
    if(sugarLevel < 1 || sugarLevel > 999){
        self.errorLabel.text = @"Blood glucose level must be a number between 0 and 999!";
        self.errorLabel.hidden = NO;
    }else{
        self.meal.levelBefore = sugarLevel;
        self.errorLabel.hidden = YES;
    }
    self.textField.text = [NSString stringWithFormat:@"%d", sugarLevel];
    [self.textField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:.9]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.bounds.size.width, 33)];
    headerLabel.text = @"F o o d s";
    headerLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size: 12.0  ];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button setFrame:CGRectMake(275.0, 2.0, 30.0, 30.0)];
    button.tag = section;
    button.hidden = NO;
    [button setBackgroundColor:[UIColor clearColor]];
    button.tintColor = [UIColor blackColor];
    [button addTarget:self action:@selector(addFood) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:button];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_records count] + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == [_records count]) {
        [self addFood];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < [_records count]) {
        SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SwipeableCell"];
        
        if (cell == nil) {
            
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"SwipeableCell"
                                      containingTableView:_tableView
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:[self rightButtons]];
            cell.delegate = self;
        }
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = _records[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegularCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"RegularCell"];
            
        }
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = @"Add a Food Item";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    // Delete button was pressed
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    

    [_records removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}



@end
