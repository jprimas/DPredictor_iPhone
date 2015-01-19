//
//  DatabaseConnector.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class Food;
@class Meal;
@class Record;

@interface DatabaseConnector : NSObject

+ (instancetype) getSharedDBAccessor;
- (BOOL)saveChanges;

//Methods to do with Food Entity
- (Food *)createFoodWithItem:(NSString *)item
               quantifier:(NSString *)quantifier
                   amount:(double)amount
                    carbs:(double)carbs
                    units:(double)units;
- (NSArray *)getSimilarFoods:(NSString *)name;
- (NSArray *)getRecentFoods;
- (BOOL) alreadyExistsWithName:(NSString *)item withQuantifier:(NSString *)quantifer;
- (BOOL) hasUnfinishedMeal;
- (Meal *) getUnfinishedMeal;
//- (Food *)getFoodWithId:(NSManagedObjectID *)id;

//Methods to do with Meal Entity
- (Meal *)createMeal;
- (double) getAverageCarbErrorForMealType:(NSString *)mealType;

//Methods to do with Record Entity
- (Record *) createRecord;


@end
