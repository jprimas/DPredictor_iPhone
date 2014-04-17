//
//  Meal.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "Meal.h"


@implementation Meal

@dynamic totalCarbs;
@dynamic levelBefore;
@dynamic levelAfter;
@dynamic unitsTaken;
@dynamic unitsPredicted;
@dynamic mealType;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic records;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *currentDate = [NSDate date];
    self.createdAt = currentDate;
    self.updatedAt = currentDate;
    
}

@end
