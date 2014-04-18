//
//  UserViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"

@interface UserViewController ()

@property (nonatomic) int state;
@property (nonatomic, strong) User *user;

@property (nonatomic, weak) IBOutlet
UITextField *inputField;
@property (nonatomic, weak) IBOutlet
UIButton *backButton;
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
        self.state = 0;
        self.user = [User getSharedUserAccessor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self changeState:self.state];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okayButtonPressed:(id)sender{
    [self.inputField resignFirstResponder];
    switch (self.state){
        case 0:
            self.user.carbsPerUnit =  [self.inputField.text doubleValue];
            break;
        case 1:
            self.user.sugarsPerUnit = [self.inputField.text doubleValue];
            break;
        default:
            NSLog(@"Invalid State");
            break;
    }
}

- (IBAction)nextButtonPress:(id)sender{
    switch (self.state){
        case 0:
            [self changeState:(self.state+1)];
            break;
        case 1:
            [self.user saveChanges];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        default:
            NSLog(@"Invalid State");
            break;
    }
}

- (IBAction)backButtonPress:(id)sender{
    switch (self.state){
        case 0:
            NSLog(@"Invalid Push of Back Button");
            break;
        case 1:
            [self changeState:(self.state-1)];
            break;
        default:
            NSLog(@"Invalid State");
            break;
    }
}

- (void)changeState:(int)s{
    self.state = s;
    switch (self.state){
        case 0:
            [self.backButton setHidden:YES];
            [self.backButton setEnabled:NO];
            self.titleLabel.text = @"Welcome, Enter Initial Data!";
            self.descriptionLabel.text = @"Carbs Per Unit of Insulin";
            self.clarificationLabel.text = @"Input the amount of carbs that one unit of insulin compensates for. This can be your best estimate. The algorithm builds off this value.";
            self.nextButton.titleLabel.text = @"Next";
            self.inputField.text = [NSString stringWithFormat:@"%i", (int)self.user.carbsPerUnit];

            
            break;
        case 1:
            [self.backButton setHidden:NO];
            [self.backButton setEnabled:YES];
            self.titleLabel.text = @"One more but of info...";
            self.descriptionLabel.text = @"Sugars Per Unit of Insulin";
            self.clarificationLabel.text = @"Input the amount of sugars that one unit of insulin will reduce. This can be your best estimate. The algorithm builds off this value.";
            self.nextButton.titleLabel.text = @"Save";
            self.inputField.text = [NSString stringWithFormat:@"%i", (int)self.user.sugarsPerUnit];
            
            break;
        default:
            NSLog(@"Invalid State");
            break;
    }
}

@end
