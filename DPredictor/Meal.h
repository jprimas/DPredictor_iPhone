//
//  Meal.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Meal : NSManagedObject

@property (nonatomic, retain) NSNumber * totalCarbs;
@property (nonatomic, retain) NSNumber * levelBefore;
@property (nonatomic, retain) NSNumber * levelAfter;
@property (nonatomic, retain) NSNumber * unitsTaken;
@property (nonatomic, retain) NSNumber * unitsPredicted;
@property (nonatomic, retain) NSString * mealType;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *records;
@end

@interface Meal (CoreDataGeneratedAccessors)

- (void)addRecordsObject:(NSManagedObject *)value;
- (void)removeRecordsObject:(NSManagedObject *)value;
- (void)addRecords:(NSSet *)values;
- (void)removeRecords:(NSSet *)values;

@end
