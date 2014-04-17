//
//  Foods.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class Food;

@interface Foods : NSObject

+ (instancetype) getSharedAccessor;
- (BOOL)saveChanges;

- (Food *)addFoodWithItem:(NSString *)item
               quantifier:(NSString *)quantifier
                   amount:(double)amount
                    carbs:(double)carbs
                    units:(double)units;
- (Food *)addFood:(Food *)food;
- (NSArray *)getSimilarFoods:(NSString *)name;
- (Food *)getFoodWithId:(NSManagedObjectID *)id;


@end
