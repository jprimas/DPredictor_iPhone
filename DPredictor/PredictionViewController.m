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
    double _prediction;
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
        _prediction = 0.0;
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
    
    
    //complete and save meal/record/food
    self.meal.unitsPredicted = _prediction;
    self.meal.unitsTaken = _unitsTaken;
    self.meal.levelAfter = -1;
    double carbCount = 0;
    for (Record * r in self.meal.records){
        carbCount += r.carbs;
    }
    self.meal.totalCarbs = carbCount;
    
    //Calculate Prediction
    _prediction = [self.meal getPrediction];
    _predictionLabel.text = [NSString stringWithFormat:@"%.2f", _prediction];
    self.meal.unitsPredicted = round(_prediction);
    
    //Create a Notifcation reminder
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Finish logging your meal now.";
    NSDate *currentDate = [NSDate date];
    NSTimeInterval twoHours = 1.5 * 60 * 60;
    NSDate *newDate = [currentDate dateByAddingTimeInterval:twoHours];
    note.fireDate = newDate;
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.unitInput becomeFirstResponder];
    
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
    double unitsTaken = [self.unitInput.text doubleValue];
    if(unitsTaken >= 0){
        self.meal.unitsTaken = unitsTaken;
        [[DatabaseConnector getSharedDBAccessor] saveChanges];
    
        //Done!
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
