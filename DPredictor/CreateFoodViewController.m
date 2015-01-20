//
//  CreateFoodViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/21/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "CreateFoodViewController.h"
#import "DatabaseConnector.h"
#import "Record.h"
#import "Meal.h"
#import "EditMealViewController.h"

@interface CreateFoodViewController (){
    NSArray *_quantifiers;
    int _quantifierIndex;
}


@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UITextField *foodNameInput;
@property (nonatomic, weak) IBOutlet UITextField *foodQuantifierInput;
@property (nonatomic, weak) IBOutlet UITextField *carbCountInput;
@property (nonatomic, weak) IBOutlet UITextField *amountInput;
@property (nonatomic, weak) IBOutlet UILabel *quantifierLabel;
@property (nonatomic, weak) IBOutlet UIButton *createButton;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;

@end

@implementation CreateFoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _quantifiers = [NSArray arrayWithObjects:@"Grams", @"Ounces", @"Milliliters", @"Teaspoons", @"Tablespoons", @"cups", @"Pints", @"Hampfle", @"Tasse", nil];
        _quantifierIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Create a Food";
    UIImage* whiteBackButtonImg = [UIImage imageNamed:@"backArrow_white.png"];
    UIImage* blackBackButtonImg = [UIImage imageNamed:@"backArrow_black.png"];
    CGRect frameimg = CGRectMake(0, 0, whiteBackButtonImg.size.width, whiteBackButtonImg.size.height);
    UIButton *backButton = [[UIButton alloc] initWithFrame:frameimg];
    [backButton setBackgroundImage:whiteBackButtonImg forState:UIControlStateNormal];
    [backButton setBackgroundImage:blackBackButtonImg forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.pickerView = [[UIPickerView alloc] init];
    [self.pickerView setDataSource: self];
    [self.pickerView setDelegate: self];
    [self.pickerView setFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216.0f)];
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerView selectRow:_quantifierIndex inComponent:0 animated:YES];
    self.foodQuantifierInput.inputView = self.pickerView;
    
    self.quantifierLabel.text = _quantifiers[_quantifierIndex];
    self.foodQuantifierInput.text = _quantifiers[_quantifierIndex];
    [self.foodNameInput becomeFirstResponder];
    
    self.errorLabel.hidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPress{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addFoodButtonPress:(id)sender{
    self.errorLabel.hidden = true;
    BOOL sanatizedInput = true;
    NSString *item = _foodNameInput.text;
    if ([item length] <= 0) {
        sanatizedInput = false;
        self.errorLabel.text = @"Enter a descriptive name for the food.";
    }
    NSString *quantifier = _foodQuantifierInput.text;
    if(![_quantifiers containsObject:quantifier]){
        sanatizedInput = false;
        self.errorLabel.text = @"Select a valid quantifier.";
    }
    if([[DatabaseConnector getSharedDBAccessor] alreadyExistsWithName:item withQuantifier:quantifier]){
        //Precondition: There is a valid quantifier and a valid food name
        sanatizedInput = false;
        self.errorLabel.text = @"Such a food item has already been added.";
    }
    double amount = [_amountInput.text doubleValue];
    if(amount <= 0){
        sanatizedInput = false;
        self.errorLabel.text = @"The amount must be larger then 0.";
    }
    double carbs = [_carbCountInput.text doubleValue];
    if(carbs < 0){
        sanatizedInput = false;
        self.errorLabel.text = @"The predicted carb count cannot be negative.";
    }
    double units = 0.0;
    // TODO: except units as input instead of carbs
    if (sanatizedInput) {
        Food *food = [[DatabaseConnector getSharedDBAccessor] createFoodWithItem:item
                                                                      quantifier:quantifier
                                                                          amount:amount
                                                                           carbs:carbs
                                                                           units:units];
        Record *record = [[DatabaseConnector getSharedDBAccessor] createRecord];
        record.food = food;
        record.meal = self.meal;
        record.amount = amount;
        record.quantifier = quantifier;
        record.carbs = carbs;
        [self.meal addRecord:record];
        
        //Pop back two view controllers
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        for (UIViewController *aViewController in allViewControllers) {
            if ([aViewController isKindOfClass:[EditMealViewController class]]) {
                [self.navigationController popToViewController:aViewController animated:YES];
            }
        }
    } else{
        self.errorLabel.hidden = false;
    }
}


///////////////
//Picker View//
///////////////

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_quantifiers count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_quantifiers objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _quantifierIndex = (int)row;
    self.foodQuantifierInput.text = _quantifiers[_quantifierIndex];
    self.quantifierLabel.text = _quantifiers[_quantifierIndex];
}

@end
