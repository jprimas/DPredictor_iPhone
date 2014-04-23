//
//  EditMealViewController.m
//  DPredictor
//
//  Created by Joshua Primas on 4/19/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#include <math.h>
#import "EditMealViewController.h"
#import "SWTableViewCell.h"
#import "AddFoodViewController.h"
#import "KeyboardToolbarView.h"
#import "Meal.h"
#import "Record.h"
#import "Food.h"

@interface EditMealViewController (){
    NSArray *_quantifiers;
    NSArray *_numbers;
    NSArray *_decimals;
    NSArray *_wieghts;
    NSArray *_liquidWieghts;
    Record *_selectedRecord;
}

@property (nonatomic, weak) IBOutlet UIView *pickerToolbar;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UILabel *errorLabel;

@property (nonatomic, strong) NSMutableArray *records;

@end

@implementation EditMealViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _quantifiers = [[NSArray alloc] init];
        _numbers = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"30", nil];
        _decimals = [NSArray arrayWithObjects:@".0", @".1", @".2", @".3", @".4", @".5", @".6", @".7", @".8", @".9", nil];
        _wieghts = [NSArray arrayWithObjects:@"Grams", @"Ounces", nil];
        _liquidWieghts = [NSArray arrayWithObjects:@"Milliliters", @"Liters", @"Teaspoons", @"Tablespoons", @"Cups", @"Pints", nil];
        _selectedRecord = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Add Food";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backButtonPress)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 40;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    NSLog(@"ddddh:    %f",keyboardToolbar.frame.size.height);
    [keyboardToolbar setBarTintColor:[UIColor colorWithRed:170/255.0 green:175/255.0 blue:181/255.0 alpha:1]];
    KeyboardToolbarView *keyboardToolbarView = [[KeyboardToolbarView alloc] initWithFrame:keyboardToolbar.frame];
    [keyboardToolbarView.doneButton addTarget:self action:@selector(doneButtonPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithCustomView:keyboardToolbarView];
    
    [keyboardToolbar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    self.textField.inputAccessoryView = keyboardToolbar;
    
    [self.pickerView setDataSource: self];
    [self.pickerView setDelegate: self];
    [self.pickerView setBackgroundColor:[UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1]];
    self.pickerView.hidden = YES;
    [self.pickerToolbar setBackgroundColor:[UIColor colorWithRed:170/255.0 green:175/255.0 blue:181/255.0 alpha:1]];
    KeyboardToolbarView *pickerToolbarView = [[KeyboardToolbarView alloc] initWithFrame:keyboardToolbar.frame];
    [pickerToolbarView.doneButton addTarget:self action:@selector(doneWithPicker) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerToolbar addSubview:pickerToolbarView];
    self.pickerToolbar.hidden = YES;
    
    self.errorLabel.hidden = YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self clearInputPopups];
    if (self.meal.levelBefore != 0) {
        self.textField.text = [NSString stringWithFormat:@"%d", self.meal.levelBefore ];
    }
    self.records = [[self.meal.records allObjects] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)clearInputPopups{
    [self.textField resignFirstResponder];
    self.pickerView.hidden = YES;
    self.pickerToolbar.hidden = YES;
}

- (void)backButtonPress{
    [self clearInputPopups];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addFood{
    [self clearInputPopups];
    AddFoodViewController *addFoodVC = [[AddFoodViewController alloc] init];
    addFoodVC.meal = self.meal;
    [self.navigationController pushViewController:addFoodVC animated:YES];
}

- (void)doneButtonPress{
    int sugarLevel = [self.textField.text integerValue];
    if(sugarLevel < 1 || sugarLevel > 999){
        self.errorLabel.text = @"Blood glucose level must be a number between 0 and 999!";
        self.errorLabel.hidden = NO;
    }else{
        self.meal.levelBefore = sugarLevel;
        self.errorLabel.hidden = YES;
    }
    self.textField.text = [NSString stringWithFormat:@"%d", sugarLevel];
    [self clearInputPopups];
}

-(void)doneWithPicker{
    self.pickerToolbar.hidden = YES;
    self.pickerView.hidden = YES;
}

//Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//Creates the header for the tableview section
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    [headerView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:.9]];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.bounds.size.width, 33)];
    headerLabel.text = @"F o o d s";
    headerLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size: 12.0  ];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button setFrame:CGRectMake(275.0, 2.0, 30.0, 30.0)];
    button.tag = section;
    button.hidden = NO;
    [button setBackgroundColor:[UIColor clearColor]];
    button.tintColor = [UIColor blackColor];
    [button addTarget:self action:@selector(addFood) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:button];
    [headerView addSubview:headerLabel];
    return headerView;
}

//How many rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.records count] + 1;
}

//Handler when a row is selected from tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self clearInputPopups];
    if (indexPath.row == [self.records count]) {
        [self addFood];
    } else {
        Record *r = _records[indexPath.row];
        _selectedRecord = r;
        if([r.food.quantifier.lowercaseString isEqualToString:@"grams"]){
            _quantifiers = _wieghts;
        } else if([r.food.quantifier.lowercaseString isEqualToString:@"milliliters"]){
            _quantifiers = _liquidWieghts;
        } else if([r.food.quantifier.lowercaseString isEqualToString:@"tasse"]){
            _quantifiers = [NSArray arrayWithObject:@"Tasse"];
        } else {
            _quantifiers = [NSArray arrayWithObject:@"Hampfle"];
        }
        [self.pickerView reloadAllComponents];
        double currentIntegerAmt = floor(_selectedRecord.amount);
        double currentDecimalAmt = _selectedRecord.amount - currentIntegerAmt;
        
        int index = [_numbers indexOfObject:[NSString stringWithFormat:@"%d", (int)currentIntegerAmt]];
        if(index != NSNotFound){
            [self.pickerView selectRow:index inComponent:0 animated:YES];
        }
        index = [_decimals indexOfObject:[[NSString stringWithFormat:@"%.1f", currentDecimalAmt]substringFromIndex:1]];
        if(index != NSNotFound){
            [self.pickerView selectRow:index inComponent:1 animated:YES];
        }
        index = [_quantifiers indexOfObject:r.quantifier];
        if(index != NSNotFound){
            [self.pickerView selectRow:index inComponent:2 animated:YES];
        }
        self.pickerView.hidden = NO;
        self.pickerToolbar.hidden = NO;
    }
}

//Formats cells of tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.records count]) {
        SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SwipeableCell"];
        
        if (cell == nil) {
            
            cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"SwipeableCell"
                                      containingTableView:_tableView
                                       leftUtilityButtons:nil
                                      rightUtilityButtons:[self rightButtons]];
            cell.delegate = self;
        }
        Record *r = ((Record*)self.records[indexPath.row]);
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text =r.food.item;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"   %.1f %@",r.amount,r.quantifier];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegularCell"];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"RegularCell"];
            
        }
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = @"Add a Food Item";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }
}

//Defines button on the right
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

//Functions called when a button is pressed
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    [self clearInputPopups];
    // Delete button was pressed
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

    Record *r = self.records[cellIndexPath.row];
    [self.meal removeRecord:r];
    [self.records removeObjectAtIndex:cellIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}


////////////////////
//FOR PICKER VIEW///
////////////////////
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [_numbers count];
        case 1:
            return [_decimals count];
        case 2:
            return [_quantifiers count];
        default:
            return 0;
    }
}

//width of columns
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 70.0;
        case 1:
            return 70.0;
        case 2:
            return 180.0;
        default:
            return 70.0;
    }
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [_numbers objectAtIndex: row];
        case 1:
            return [_decimals objectAtIndex: row];
        case 2:
            return [_quantifiers objectAtIndex: row];
        default:
            return @"";
    }
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(_selectedRecord != nil){
        double currentAmt= _selectedRecord.amount;
        double currentIntegerAmt = floor(currentAmt);
        double currentDecimalAmt = currentAmt - currentIntegerAmt;
        switch (component) {
            case 0:
                _selectedRecord.amount = [_numbers[row] doubleValue] + currentDecimalAmt;
                break;
            case 1:
                _selectedRecord.amount = [_decimals[row] doubleValue] + currentIntegerAmt;
                break;
            case 2:
                _selectedRecord.quantifier = _quantifiers[row];
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }
}




@end
