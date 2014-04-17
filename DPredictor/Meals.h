//
//  Meals.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class Meal;

@interface Meals : NSObject

+ (instancetype) getSharedAccessor;
- (BOOL)saveChanges;

- (Meal *) addMeal:(Meal *)meal;
- (Meal *) getMealWithId:(NSManagedObjectID *)id;
- (Meal *) getUnfinishedMeal;
- (NSArray *) getMealsStartingFrom:(int)index;


@end
