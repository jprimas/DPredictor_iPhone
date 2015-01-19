//
//  MenuViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "MenuViewController.h"
#import "EditUserViewController.h"
#import "MealTypeViewController.h"
#import "EditMealViewController.h"
#import "DatabaseConnector.h"
#import "Meal.h"

@interface MenuViewController (){

    BOOL hasUnfinishedMeal;
    Meal *meal;
}

@property (nonatomic, weak) IBOutlet UIButton *mealButton;

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"DLogger";
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    hasUnfinishedMeal = [[DatabaseConnector getSharedDBAccessor] hasUnfinishedMeal];
    if (hasUnfinishedMeal) {
        meal =[[DatabaseConnector getSharedDBAccessor] getUnfinishedMeal];
        [self.mealButton setTitle:@"Finish Meal" forState:UIControlStateNormal];
    } else {
        [self.mealButton setTitle:@"Add New Meal" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editUser:(id)sender{
    EditUserViewController *editUserVC = [[EditUserViewController alloc] init];
    [self.navigationController pushViewController:editUserVC animated:NO];
}

-(IBAction)addMeal:(id)sender{
    if (!hasUnfinishedMeal) {
        MealTypeViewController *mealVC = [[MealTypeViewController alloc] init];
        [self.navigationController pushViewController:mealVC animated:YES];
    }else{
        EditMealViewController *mealVC = [[EditMealViewController alloc] init];
        mealVC.meal = meal;
        mealVC.newMeal = NO;
        [self.navigationController pushViewController:mealVC animated:YES];
    }
}

@end
