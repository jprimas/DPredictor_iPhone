//
//  MealDataTableViewCell.h
//  DPredictor
//
//  Created by Joshua Primas on 3/8/15.
//  Copyright (c) 2015 Joshua Primas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealDataTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalCarbsLabel;
@property (nonatomic, weak) IBOutlet UILabel *insulinTakenLabel;
@property (nonatomic, weak) IBOutlet UILabel *bloodSugarLevelBeforeLabel;
@property (nonatomic, weak) IBOutlet UILabel *bloodSugarLevelAfterLabel;

@end
