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
#import "DatabaseConnector.h"
#import "CreateFoodViewController.h"

@interface AddFoodViewController ()

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton    *addNewFoodButton;

@property (nonatomic, strong) Record *record;

@end

@implementation AddFoodViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPress{
    self.record = [[DatabaseConnector getSharedDBAccessor] createRecord];
    self.record.item = @"Wheat Bread";
    [self.meal addRecord: self.record];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createNewFood:(id)sender{
    CreateFoodViewController *createFoodVC = [[CreateFoodViewController alloc] init];
    createFoodVC.meal = self.meal;
    [self.navigationController pushViewController:createFoodVC animated:YES];
}

@end
