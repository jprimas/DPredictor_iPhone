//
//  User2ViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/19/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "User2ViewController.h"
#import "User.h"

@interface User2ViewController ()

@property (atomic, strong) User *user;

@property (nonatomic, weak) IBOutlet
UITextField *inputField;
@property (nonatomic, weak) IBOutlet
UIButton *saveButton;
@property (nonatomic, weak) IBOutlet
UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet
UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet
UILabel *clarificationLabel;

@end

@implementation User2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.user = [User getSharedUserAccessor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Personalize";
    UIImage* whiteBackButtonImg = [UIImage imageNamed:@"backArrow_white.png"];
    UIImage* blackBackButtonImg = [UIImage imageNamed:@"backArrow_black.png"];
    CGRect frameimg = CGRectMake(0, 0, whiteBackButtonImg.size.width, whiteBackButtonImg.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setBackgroundImage:whiteBackButtonImg forState:UIControlStateNormal];
    [backButton setBackgroundImage:blackBackButtonImg forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.titleLabel.text = @"One more bit of info...";
    self.descriptionLabel.text = @"Sugars Per Unit of Insulin";
    self.clarificationLabel.text = @"Input the amount of sugars that one unit of insulin will reduce. This can be your best estimate. The algorithm builds off this value.";
    self.inputField.text = [NSString stringWithFormat:@"%i", (int)self.user.sugarsPerUnit];
    
    [self.inputField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPress:(id)sender{
    double temp = [self.inputField.text doubleValue];
    if (temp <= 0 ) {
        temp  = 30;
    }
    self.user.sugarsPerUnit = temp;
    [self.user saveChanges];
    [self.inputField resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backButtonPress{
    [self.inputField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
