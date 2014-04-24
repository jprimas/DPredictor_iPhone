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

@property (nonatomic) double amount;
@property (nonatomic, retain) NSString * quantifier;
@property (nonatomic, retain) NSString * item;
@property (nonatomic) double carbs;
@property (nonatomic) double units;
@property (nonatomic) int score;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;

+ (NSString*) standardizeQuantfier:(NSString *)quantifier;
- (void) standardizeQuantfier;

@end
