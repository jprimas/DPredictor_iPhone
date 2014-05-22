//
//  EditMealViewController.h
//  DPredictor
//
//  Created by Joshua Primas on 4/19/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class Meal;

@interface EditMealViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
}

@property (atomic, strong) Meal *meal;
@property (atomic) BOOL newMeal;

@end
