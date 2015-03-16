//
//  MealsViewController.h
//  DPredictor
//
//  Created by Joshua Primas on 3/8/15.
//  Copyright (c) 2015 Joshua Primas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Meal;

@interface MealsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *noMealsLabel;
@property (nonatomic, strong) NSArray *meals;


@end
