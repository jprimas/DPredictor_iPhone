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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                                          target:self
                                                                                          action:@selector(backButtonPress)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(doneButtonPress)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
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

@end
