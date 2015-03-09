//
//  EditFoodItemViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 2/9/15.
//  Copyright (c) 2015 Joshua Primas. All rights reserved.
//

#import "EditFoodItemViewController.h"
#import "Food.h"
#import "Record.h"
#import "DatabaseConnector.h"
#import "KeyboardToolbarView.h"

@interface EditFoodItemViewController ()

@property (nonatomic, weak) IBOutlet UITextField *amountIF;
@property (nonatomic, weak) IBOutlet UITextField *carbsIF;
@property (nonatomic, weak) IBOutlet UITextField *scoreIF;
@property (nonatomic, weak) IBOutlet UILabel *quantifierLabel;
@property (nonatomic, weak) IBOutlet UIButton *updateButton;

@end

@implementation EditFoodItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = self.food.item;
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
    self.amountIF.inputAccessoryView = keyboardToolbar;
    self.carbsIF.inputAccessoryView = keyboardToolbar;
    self.scoreIF.inputAccessoryView = keyboardToolbar;
    
    
    self.amountIF.text = [NSString stringWithFormat:@"%.0f", self.food.amount];
    self.carbsIF.text = [NSString stringWithFormat:@"%.0f", self.food.carbs];
    self.scoreIF.text = [NSString stringWithFormat:@"%d", self.food.score];
    self.quantifierLabel.text = self.food.quantifier;
    
}

- (void)backButtonPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPress{
    [self.amountIF resignFirstResponder];
    [self.carbsIF resignFirstResponder];
    [self.scoreIF resignFirstResponder];
}

- (IBAction)addFoodButtonPress:(id)sender{
    double amount = [_amountIF.text doubleValue];
    double carbs = [_carbsIF.text doubleValue];
    double score = [_scoreIF.text doubleValue];
    
    [self.food setAmount:amount];
    [self.food setCarbs:carbs];
    [self.food setScore:score];
    
    [[DatabaseConnector getSharedDBAccessor] saveChanges];

}

@end
