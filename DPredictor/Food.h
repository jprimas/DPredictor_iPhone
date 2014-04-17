//
//  Food.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Food : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * quantifier;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSNumber * carbs;
@property (nonatomic, retain) NSNumber * units;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSSet *records;
@end

@interface Food (CoreDataGeneratedAccessors)

- (void)addRecordsObject:(NSManagedObject *)value;
- (void)removeRecordsObject:(NSManagedObject *)value;
- (void)addRecords:(NSSet *)values;
- (void)removeRecords:(NSSet *)values;

@end
