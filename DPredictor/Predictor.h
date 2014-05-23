//
//  Predictor.h
//  DPredictor
//
//  Created by Joshua Primas on 5/22/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Meal;

@interface Predictor : NSObject

+ (double) getPredictionForMeal:(Meal *)meal;
+ (BOOL) updatePredictorWithMeal:(Meal *)meal;

@end
