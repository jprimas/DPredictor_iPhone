//
//  User.h
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic) double carbsPerUnit;
@property (nonatomic) int carbsPerUnitScore;
@property (nonatomic) double sugarsPerUnit;
@property (nonatomic) int sugarsPerUnitScore;
@property (nonatomic) double breakfastCorrection;
@property (nonatomic) int breakfastCorrectionScore;
@property (nonatomic) double lunchCorrection;
@property (nonatomic) int lunchCorrectionScore;
@property (nonatomic) double dinnerCorrection;
@property (nonatomic) int dinnerCorrectionScore;

- (BOOL)saveChanges;

@end
