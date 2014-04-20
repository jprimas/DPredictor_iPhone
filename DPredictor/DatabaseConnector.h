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
- (Food *)addFoodWithItem:(NSString *)item
               quantifier:(NSString *)quantifier
                   amount:(double)amount
                    carbs:(double)carbs
                    units:(double)units;
- (NSArray *)getSimilarFoods:(NSString *)name;
- (Food *)getFoodWithId:(NSManagedObjectID *)id;

//Methods to do with Meal Entity
- (Meal *)createMeal;
- (Meal *) addMealWithTotalCarbs:(double)totalCarbs
                     levelBefore:(int)levelBefore
                      levelAfter:(int)levelAfter
                      unitsTaken:(int)unitsTaken
                  unitsPredicted:(int)unitsPredicted
                        mealType:(NSString *)mealType;
- (Meal *) getMealWithId:(NSManagedObjectID *)id;
- (Meal *) getUnfinishedMeal;
- (NSArray *) getMealsStartingFrom:(int)index;

//Methods to do with Record Entity
- (Record *) addRecordWithItem:(NSString *)item
                         carbs:(double)carbs
                        amount:(double)amount
                    quantifier:(NSString *)quantifier
                          meal:(Meal *) meal;


@end