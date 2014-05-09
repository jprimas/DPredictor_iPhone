//
//  UserViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"
#import "User2ViewController.h"

@interface UserViewController ()

@property (atomic, strong) User *user;

@property (nonatomic, weak) IBOutlet
UITextField *inputField;
@property (nonatomic, weak) IBOutlet
UIButton *nextButton;
@property (nonatomic, weak) IBOutlet
UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet
UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet
UILabel *clarificationLabel;

@end

@implementation UserViewController

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
    
    self.titleLabel.text = @"Welcome, Enter Initial Data!";
    self.descriptionLabel.text = @"Carbs Per Unit of Insulin";
    //self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.clarificationLabel.text = @"Input the amount of carbs that one unit of insulin compensates for. This can be your best estimate. The algorithm builds off this value.";
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    self.inputField.text = [NSString stringWithFormat:@"%i", (int)self.user.carbsPerUnit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.inputField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPress:(id)sender{
    self.user.carbsPerUnit =  [self.inputField.text doubleValue];
    User2ViewController *user2VC = [[User2ViewController alloc] init];
    [self.navigationController pushViewController:user2VC animated:YES];
}

@end
