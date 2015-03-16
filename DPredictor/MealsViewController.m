//
//  MealsViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 3/8/15.
//  Copyright (c) 2015 Joshua Primas. All rights reserved.
//

#import "MealsViewController.h"
#import "MealDataTableViewCell.h"
#import "Meal.h"
#import "DatabaseConnector.h"


@interface MealsViewController ()

@end



@implementation MealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Meals";
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
    
    _meals = [[DatabaseConnector getSharedDBAccessor] getMeals];
    if([_meals count] <= 0){
        _noMealsLabel.hidden = NO;
        _tableView.hidden = YES;
    } else {
        _noMealsLabel.hidden = YES;
        _tableView.hidden = NO;
    }
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

//How many rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_meals count];
}

//Hieght of rows
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
}

//Handler when a row is selected from tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //Meal *meal = _meals[indexPath.row];
}

//Formats cells of tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MealDataCell";
    
    MealDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MealDataTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Meal *meal = _meals[indexPath.row];
    
    //Format and Display Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM d 'at' h:mm a"];
    cell.dateLabel.text = [dateFormatter stringFromDate:meal.createdAt];
    cell.totalCarbsLabel.text = [NSString stringWithFormat:@"%d carbs", (int)(meal.totalCarbs + 0.5) ];
    cell.insulinTakenLabel.text = [NSString stringWithFormat:@"%d units", meal.unitsTaken];
    cell.bloodSugarLevelBeforeLabel.text = [NSString stringWithFormat:@"%d mg/dL", meal.levelBefore ];
    if (meal.levelAfter <= 0) {
        cell.bloodSugarLevelAfterLabel.hidden = YES;
        cell.bloodSugarLevelCaret.hidden = YES;
    } else {
        cell.bloodSugarLevelAfterLabel.text = [NSString stringWithFormat:@"%d mg/dL", meal.levelAfter];
    }
    return cell;
    
}


@end
