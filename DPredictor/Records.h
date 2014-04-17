//
//  Records.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@class Record;

@interface Records : NSObject

+ (instancetype) getSharedAccessor;
- (BOOL)saveChanges;

- (Record *) addRecord:(Record *)record;

@end
