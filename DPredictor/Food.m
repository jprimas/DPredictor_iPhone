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

- (void) standardizeQuantfier{
    if([self.quantifier.lowercaseString isEqualToString:@"grams"]){
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    } else if([self.quantifier.lowercaseString isEqualToString:@"ounces"]){
        self.quantifier = @"Grams";
        self.amount = self.amount * 28.3495;
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    } else if([self.quantifier.lowercaseString isEqualToString:@"liters"]){
        self.quantifier = @"Milliliters";
        self.amount = self.amount / 1000;
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    } else if([self.quantifier.lowercaseString isEqualToString:@"teaspoons"]){
        self.quantifier = @"Milliliters";
        self.amount = self.amount * 4.92892;
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    } else if([self.quantifier.lowercaseString isEqualToString:@"tablespoons"]){
        self.quantifier = @"Milliliters";
        self.amount = self.amount * 14.7868;
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    } else if([self.quantifier.lowercaseString isEqualToString:@"cups"]){
        self.quantifier = @"Milliliters";
        self.amount = self.amount * 236.588;
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    } else if([self.quantifier.lowercaseString isEqualToString:@"pints"]){
        self.quantifier = @"Milliliters";
        self.amount = self.amount * 473.176;
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    } else if([self.quantifier.lowercaseString isEqualToString:@"quarts"]){
        self.quantifier = @"Milliliters";
        self.amount = self.amount * 946.353;
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    } else if([self.quantifier.lowercaseString isEqualToString:@"gallons"]){
        self.quantifier = @"Milliliters";
        self.amount = self.amount * 3785.41;
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    }else{
        self.carbs = self.carbs / self.amount;
        self.amount = 1;
    }
}

@end
