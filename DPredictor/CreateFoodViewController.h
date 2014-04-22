//
//  CreateFoodViewController.h
//  DPredictor
//
//  Created by Joshua Primas on 4/21/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Meal;

@interface CreateFoodViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (atomic, strong) Meal *meal;

@end
