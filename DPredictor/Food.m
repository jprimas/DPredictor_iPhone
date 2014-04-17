//
//  Food.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "Food.h"


@implementation Food

@dynamic amount;
@dynamic quantifier;
@dynamic item;
@dynamic carbs;
@dynamic units;
@dynamic score;
@dynamic createdAt;
@dynamic updatedAt;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *currentDate = [NSDate date];
    self.createdAt = currentDate;
    self.updatedAt = currentDate;
}

@end
