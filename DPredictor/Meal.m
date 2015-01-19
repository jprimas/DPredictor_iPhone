//
//  Meal.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "Meal.h"
#import "User.h"
#import "Record.h"
#import "Food.h"
#import "DatabaseConnector.h"


@implementation Meal{
    NSMutableSet *_privRecords;
}

@dynamic totalCarbs;
@dynamic levelBefore;
@dynamic levelAfter;
@dynamic unitsTaken;
@dynamic unitsPredicted;
@dynamic mealType;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic records;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    NSDate *currentDate = [NSDate date];
    self.createdAt = currentDate;
    self.updatedAt = currentDate;
    
}

- (void)addRecord:(Record *)record{
    [self.records addObject:record];
}


- (void)removeRecord:(Record *)record{
    [self.records removeObject:record];
}

typedef enum SugarLevel : NSUInteger {
    tooLowSugar,
    perfectSugar,
    tooHighSugar
} SugarLevel;

- (double) getPrediction {
    User *user = [User getSharedUserAccessor];
    double unitsFromMeal = self.totalCarbs / (user.carbsPerUnit + [self getMealCorrection]);
    double unitsFromSugar = 0;
    if(self.levelBefore < 90){
        unitsFromSugar = (self.levelBefore - 100) / user.sugarsPerUnit;
    }else if(self.levelBefore > 110){
        unitsFromSugar = (self.levelBefore - 120) / user.sugarsPerUnit;
    }
    return unitsFromMeal + unitsFromSugar;
}

- (BOOL) updatePredictor{
    if(self.levelBefore < 0 || self.levelAfter < 0 || self.records == nil || [self.records count] == 0){
        return NO;
    }
    User *user = [User getSharedUserAccessor];
    NSLog(@"old carbsPerUnit: %f", user.carbsPerUnit);
    NSLog(@"old sugarsPerUnit: %f", user.sugarsPerUnit);
    int sugarsPerUnitScore = user.sugarsPerUnitScore;
    int bolusAmt = 0;
    if(self.levelBefore < 90){
        bolusAmt = (self.levelBefore - 100) / user.sugarsPerUnit;
    }else if(self.levelBefore > 110){
        bolusAmt = (self.levelBefore - 120) / user.sugarsPerUnit;
    }
    double excessInsulinTaken = self.unitsTaken - self.unitsPredicted;
    double finalExcessSugar = self.levelAfter - 130;
    double excessCarbs = (finalExcessSugar / user.sugarsPerUnit + excessInsulinTaken) * (user.carbsPerUnit + [self getMealCorrection]);
    int totalFoodScore = 0;
    for(Record *record in self.records){
        totalFoodScore += record.food.score;
    }
    NSLog(@"Total carb count: %f", self.totalCarbs);
    double totalFoodScoreFlipped = 0;
    for(Record *record in self.records){
        totalFoodScoreFlipped += (totalFoodScore - record.food.score) / (double)totalFoodScore;
    }
    double sumOfScores = totalFoodScore + user.carbsPerUnitScore + sugarsPerUnitScore;
    if(bolusAmt == 0){
        sugarsPerUnitScore = sumOfScores;
    }
    double sumOfScoresFlipped = (sumOfScores - totalFoodScore)/sumOfScores
    + (sumOfScores - user.carbsPerUnitScore)/sumOfScores
    + (sumOfScores - sugarsPerUnitScore)/sumOfScores;
    
    double foodsDistributionPercent = ((sumOfScores - totalFoodScore) / sumOfScores) / sumOfScoresFlipped;
    double carbsDistributionPercent = ((sumOfScores - user.carbsPerUnitScore) / sumOfScores) / sumOfScoresFlipped;
    double sugarsDistributionPercent = ((sumOfScores - sugarsPerUnitScore) / sumOfScores) / sumOfScoresFlipped;
    NSLog(@"foodDistributionPercent: %f", foodsDistributionPercent);
    NSLog(@"carbsDistributionPercent: %f", carbsDistributionPercent);
    NSLog(@"sugarsDistributionPercent: %f", sugarsDistributionPercent);
    double extraCarbsForFood = excessCarbs * foodsDistributionPercent;
    double extraCarbsForCarbsPerUnit = excessCarbs * carbsDistributionPercent;
    double extraCarbsForSugarsPerUnit = excessCarbs * sugarsDistributionPercent;
    NSLog(@"extraCarbsForFood: %f", extraCarbsForFood);
    NSLog(@"extraCarbsForCarbsPerUnit: %f", extraCarbsForCarbsPerUnit);
    NSLog(@"extraCarbsForSugarsPerUnit: %f", extraCarbsForSugarsPerUnit);
    
    //Update Food
    for(Record *record in self.records){
        Food *food = record.food;
        NSLog(@"Updating Food Item: %@", food.item);
        NSLog(@"Previous Food Carb Count: %f", food.carbs);
        double predictedCarbCount = food.carbs * record.amount;
        
        double singleFoodDistributionPercent = [self getFoodModifierPercentWithFoodScore:food.score
                                                                          totalFoodScore:totalFoodScore
                                                                               carbCount:food.carbs
                                                                          totalCarbCount:self.totalCarbs];
        double newCarbCount = predictedCarbCount + extraCarbsForFood * singleFoodDistributionPercent;
        double updatedCarbCount = ((food.score * food.carbs) + newCarbCount) / (double)(food.score + 1) / record.amount;
        food.carbs = updatedCarbCount;
        //Update Food Score
        if([self getMealSuccess]  == tooLowSugar && excessInsulinTaken > 1){
            food.score = MAX(1, food.score + 1);
        }else if([self getMealSuccess]  == tooLowSugar && excessInsulinTaken <= 1 && excessInsulinTaken >= -1){
            food.score = MAX(1, food.score - 1);
        }else if([self getMealSuccess]  == tooLowSugar && excessInsulinTaken < -1){
            food.score = MAX(1, food.score - 5);
        }else if([self getMealSuccess]  == perfectSugar && excessInsulinTaken > 1){
            food.score = MAX(1, food.score - 2);
        }else if([self getMealSuccess]  == perfectSugar && excessInsulinTaken <= 1 && excessInsulinTaken >= -1){
            food.score = MAX(1, food.score + 6);
        }else if([self getMealSuccess]  == perfectSugar && excessInsulinTaken < -1){
            food.score = MAX(1, food.score - 2);
        }else if([self getMealSuccess]  == tooHighSugar && excessInsulinTaken > 1){
            food.score = MAX(1, food.score - 5);
        }else if([self getMealSuccess]  == tooHighSugar && excessInsulinTaken <= 1 && excessInsulinTaken >= -1){
            food.score = MAX(1, food.score - 1);
        }else if([self getMealSuccess]  == tooHighSugar && excessInsulinTaken < -1){
            food.score = MAX(1, food.score + 1);
        }
        
        NSLog(@"New Food Carb Count: %f", food.carbs);
    }
    
    //Update Units per Carb
    double newCarbsPerUnit = user.carbsPerUnit - (extraCarbsForCarbsPerUnit / fabs(self.unitsPredicted));
    double updatedCarbsPerUnit = (user.carbsPerUnitScore * user.carbsPerUnit + newCarbsPerUnit) / (user.carbsPerUnitScore + 1);
    user.carbsPerUnit = updatedCarbsPerUnit;
    user.carbsPerUnitScore = user.carbsPerUnitScore + 1;
    
    //Update Sugars per Carb
    if(bolusAmt != 0){
        NSLog(@"Update Sugars per Unit");
        double newSugarsPerUnit = user.sugarsPerUnit - (extraCarbsForSugarsPerUnit / fabs(bolusAmt));
        double updatedSugarsPerUnit = (user.sugarsPerUnitScore * user.sugarsPerUnit + newSugarsPerUnit * fabs(bolusAmt))
        /(double)(user.sugarsPerUnitScore + fabs(bolusAmt));
        user.sugarsPerUnit = updatedSugarsPerUnit;
        user.sugarsPerUnitScore = user.sugarsPerUnitScore + 1;
    }
    
    NSLog(@"New carbsPerUnit: %f", user.carbsPerUnit);
    NSLog(@"New sugarsPerUnit: %f", user.sugarsPerUnit);
    
    //Update meal corrections
    
    
    [user saveChanges];
    [[DatabaseConnector getSharedDBAccessor] saveChanges];
    
    return YES;
}

- (double) getFoodModifierPercentWithFoodScore: (double)foodScore
                                totalFoodScore: (double)totalFoodScore
                                     carbCount: (double)carbCount
                                totalCarbCount: (double)totalCarbCount {
    if(totalFoodScore == foodScore){
        return 1.0;
    } else {
        double scorePart = foodScore / totalFoodScore;
        double carbPart = carbCount / totalCarbCount;
        return (2*scorePart + carbPart) / 3;
    }
}

- (SugarLevel) getMealSuccess {
    if(self.levelAfter >= 90 && self.levelAfter <= 145){
        return perfectSugar;
    } else if(self.levelAfter < 90){
        return tooLowSugar;
    } else {
        return tooHighSugar;
    }
}

- (void) updateMealCorrections {
    User *user = [User getSharedUserAccessor];
    DatabaseConnector *dbc = [DatabaseConnector getSharedDBAccessor];
    double breakfastCarbError = [dbc getAverageCarbErrorForMealType:@"Breakfast"];
    double lunchCarbError = [dbc getAverageCarbErrorForMealType:@"Lunch"];
    double dinnerCarbError = [dbc getAverageCarbErrorForMealType:@"Dinner"];
    double meanCarbError = (breakfastCarbError + lunchCarbError + dinnerCarbError) / 3;
    
    //double temp = mean - breakfastCarbError;
    //FIXME
    
    
}

- (double) getMealCorrection{
    User *user = [User getSharedUserAccessor];
    if ([self.mealType isEqualToString: @"Breakfast"]) {
        return user.breakfastCorrection;
    } else if ([self.mealType isEqualToString: @"Lunch"]) {
        return user.lunchCorrection;
    }else if ([self.mealType isEqualToString: @"Dinner"]) {
        return user.dinnerCorrection;
    } else {
        return 0.0;
    }
}


@end
