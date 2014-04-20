//
//  MealTypeViewController.h
//  DPredictor
//
//  Created by Joshua Primas on 4/19/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Meal;

@interface MealTypeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (atomic, strong) Meal *meal;

@end
