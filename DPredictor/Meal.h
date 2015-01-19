//
//  Meal.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class Record;


@interface Meal : NSManagedObject

@property (nonatomic) double totalCarbs;
@property (nonatomic) int levelBefore;
@property (nonatomic) int levelAfter;
@property (nonatomic) int unitsTaken;
@property (nonatomic) int unitsPredicted;
@property (nonatomic, retain) NSString * mealType;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSMutableSet *records;
@end

@interface Meal (CoreDataGeneratedAccessors)

- (void)addRecord:(Record *)record;
- (void)removeRecord:(Record *)record;
- (BOOL) updatePredictor;
- (double) getPrediction;

@end
