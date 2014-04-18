//
//  Record.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food, Meal;

@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * item;
@property (nonatomic) double carbs;
@property (nonatomic) double amount;
@property (nonatomic, retain) NSString * quantifier;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) Meal *meal;
@property (nonatomic, retain) Food *food;

@end
