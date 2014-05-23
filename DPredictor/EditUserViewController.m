//
//  EditUserViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 5/21/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "EditUserViewController.h"
#import "User.h"
#import "KeyboardToolbarView.h"

@interface EditUserViewController (){
    User *_user;
}
@property (nonatomic, weak) IBOutlet UITextField *carbsIF;
@property (nonatomic, weak) IBOutlet UITextField *sugarsIF;
@property (nonatomic, weak) IBOutlet UITextField *breakfastIF;
@property (nonatomic, weak) IBOutlet UITextField *lunchIF;
@property (nonatomic, weak) IBOutlet UITextField *dinnerIF;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation EditUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _user = [User getSharedUserAccessor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Edit Variables";
    //back Button
    UIImage* whiteBackButtonImg = [UIImage imageNamed:@"backArrow_white.png"];
    UIImage* blackBackButtonImg = [UIImage imageNamed:@"backArrow_black.png"];
    CGRect frameimg = CGRectMake(0, 0, whiteBackButtonImg.size.width, whiteBackButtonImg.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setBackgroundImage:whiteBackButtonImg forState:UIControlStateNormal];
    [backButton setBackgroundImage:blackBackButtonImg forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //Save Button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(saveButtonPress)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    [keyboardToolbar setBarTintColor:[UIColor colorWithRed:170/255.0 green:175/255.0 blue:181/255.0 alpha:1]];
    KeyboardToolbarView *keyboardToolbarView = [[KeyboardToolbarView alloc] initWithFrame:keyboardToolbar.frame];
    keyboardToolbarView.doneButtonText = @"Din";
    [keyboardToolbarView.doneButton addTarget:self action:@selector(doneButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:keyboardToolbarView];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    [self initInputFieldsWithToolbar:keyboardToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)backButtonPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneButtonPress{
    [self.view endEditing:YES];
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)saveButtonPress{
    _user.carbsPerUnit = [self.carbsIF.text doubleValue];
    _user.sugarsPerUnit = [self.sugarsIF.text doubleValue];
    _user.breakfastCorrection = [self.breakfastIF.text doubleValue];
    _user.lunchCorrection = [self.lunchIF.text doubleValue];
    _user.dinnerCorrection = [self.dinnerIF.text doubleValue];
    [_user saveChanges];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initInputFieldsWithToolbar:(UIToolbar*) toolbar{
    self.carbsIF.text = [NSString stringWithFormat:@"%.0f", _user.carbsPerUnit];
    self.carbsIF.inputAccessoryView = toolbar;
    self.carbsIF.delegate = self;
    self.sugarsIF.text = [NSString stringWithFormat:@"%.0f", _user.sugarsPerUnit];
    self.sugarsIF.inputAccessoryView = toolbar;
    self.sugarsIF.delegate = self;
    self.breakfastIF.text = [NSString stringWithFormat:@"%.0f", _user.breakfastCorrection];
    self.breakfastIF.inputAccessoryView = toolbar;
    self.breakfastIF.delegate = self;
    self.lunchIF.text = [NSString stringWithFormat:@"%.0f", _user.lunchCorrection];
    self.lunchIF.inputAccessoryView = toolbar;
    self.lunchIF.delegate = self;
    self.dinnerIF.text = [NSString stringWithFormat:@"%.0f", _user.dinnerCorrection];
    self.dinnerIF.inputAccessoryView = toolbar;
    self.dinnerIF.delegate = self;
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"begin: %@", textField.text);
    if ([textField isEqual:self.lunchIF])
    {
        self.scrollView.contentOffset = CGPointMake(0, 85);
    }
    else if ([textField isEqual:self.dinnerIF])
    {
        self.scrollView.contentOffset = CGPointMake(0, 85);
    }else {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    
    return YES;
}

@end
