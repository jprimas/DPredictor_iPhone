//
//  PredictionViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/22/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "PredictionViewController.h"
#import "KeyboardToolbarView.h"
#import "Meal.h"
#import "Record.h"
#import "DatabaseConnector.h"

@interface PredictionViewController (){
    int _prediction;
    int _unitsTaken;
}

@property (nonatomic, weak) IBOutlet UILabel *predictionLabel;
@property (nonatomic, weak) IBOutlet UITextField *unitInput;

@end

@implementation PredictionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _prediction = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Unit Prediction";
    UIImage* whiteBackButtonImg = [UIImage imageNamed:@"backArrow_white.png"];
    UIImage* blackBackButtonImg = [UIImage imageNamed:@"backArrow_black.png"];
    CGRect frameimg = CGRectMake(0, 0, whiteBackButtonImg.size.width, whiteBackButtonImg.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setBackgroundImage:whiteBackButtonImg forState:UIControlStateNormal];
    [backButton setBackgroundImage:blackBackButtonImg forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    [keyboardToolbar setBarTintColor:[UIColor colorWithRed:170/255.0 green:175/255.0 blue:181/255.0 alpha:1]];
    KeyboardToolbarView *keyboardToolbarView = [[KeyboardToolbarView alloc] initWithFrame:keyboardToolbar.frame];
    [keyboardToolbarView.doneButton addTarget:self action:@selector(doneButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:keyboardToolbarView];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    self.unitInput.inputAccessoryView = keyboardToolbar;
    
    _prediction = 5; //TODO: get actual prediction
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
    _unitsTaken = [self.unitInput.text intValue];
    [self.unitInput resignFirstResponder];
}

-(IBAction)finishButtonPress:(id)sender{
    self.meal.unitsPredicted = _prediction;
    self.meal.unitsTaken = _unitsTaken;
    self.meal.levelAfter = -1;
    double carbCount = 0;
    for (Record * r in self.meal.records){
        carbCount += r.carbs;
    }
    self.meal.totalCarbs = carbCount;
    [[DatabaseConnector getSharedDBAccessor] saveChanges];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //complete and save meal/record/food
}

@end
