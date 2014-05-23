//
//  Record.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "Record.h"
#import "Food.h"
#import "Meal.h"


@implementation Record

@dynamic item;
@dynamic carbs;
@dynamic amount;
@dynamic quantifier;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic meal;
@dynamic food;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *currentDate = [NSDate date];
    self.createdAt = currentDate;
    self.updatedAt = currentDate;
    
}

-(void) calculateCarbCount{
    if([self.quantifier.lowercaseString isEqualToString:@"ounces"]){
        self.carbs = self.food.carbs * self.amount * 28.3495;
    } else if([self.quantifier.lowercaseString isEqualToString:@"liters"]){
        self.carbs = self.food.carbs * self.amount * 1000;
    } else if([self.quantifier.lowercaseString isEqualToString:@"teaspoons"]){
        self.carbs = self.food.carbs * self.amount * 4.92892;
    } else if([self.quantifier.lowercaseString isEqualToString:@"tablespoons"]){
        self.carbs = self.food.carbs * self.amount * 14.7868;
    } else if([self.quantifier.lowercaseString isEqualToString:@"cups"]){
        self.carbs = self.food.carbs * self.amount * 236.588;
    } else if([self.quantifier.lowercaseString isEqualToString:@"pints"]){
        self.carbs = self.food.carbs * self.amount * 473.176;
    } else if([self.quantifier.lowercaseString isEqualToString:@"quarts"]){
        self.carbs = self.food.carbs * self.amount * 946.353;
    } else if([self.quantifier.lowercaseString isEqualToString:@"gallons"]){
        self.carbs = self.food.carbs * self.amount * 3785.41;
    }else{
        self.carbs = self.food.carbs * self.amount;
    }
}

@end
