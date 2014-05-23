//
//  Predictor.m
//  DPredictor
//
//  Created by Joshua Primas on 5/22/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "Predictor.h"
#import "Meal.h"
#import "User.h"
#import "Record.h"
#import "Food.h"
#import "DatabaseConnector.h"

@implementation Predictor

typedef enum SugarLevel : NSUInteger {
    tooLowSugar,
    perfectSugar,
    tooHighSugar
} SugarLevel;

+ (double) getPredictionForMeal:(Meal *)meal {
    User *user = [User getSharedUserAccessor];
    double unitsFromMeal = meal.totalCarbs / (user.carbsPerUnit);
    double unitsFromSugar = 0;
    if(meal.levelBefore < 90){
        unitsFromSugar = (meal.levelBefore - 100) / user.sugarsPerUnit;
    }else if(meal.levelBefore > 110){
        unitsFromSugar = (meal.levelBefore - 120) / user.sugarsPerUnit;
    }
    return unitsFromMeal + unitsFromSugar;
}

+ (BOOL) updatePredictorWithMeal:(Meal *)meal{
    if(meal.levelBefore < 0 || meal.levelAfter < 0 || meal.records == nil || [meal.records count] == 0){
        return NO;
    }
    User *user = [User getSharedUserAccessor];
    NSLog(@"old carbsPerUnit: %f", user.carbsPerUnit);
    NSLog(@"old sugarsPerUnit: %f", user.sugarsPerUnit);
    int sugarsPerUnitScore = user.sugarsPerUnitScore;
    int bolusAmt = 0;
    if(meal.levelBefore < 90){
        bolusAmt = (meal.levelBefore - 100) / user.sugarsPerUnit;
    }else if(meal.levelBefore > 110){
        bolusAmt = (meal.levelBefore - 120) / user.sugarsPerUnit;
    }
    double excessInsulinTaken = meal.unitsTaken - meal.unitsPredicted;
    double finalExcessSugar = meal.levelAfter - 130;
    double excessCarbs = (finalExcessSugar / user.sugarsPerUnit + excessInsulinTaken) * user.carbsPerUnit;
    int totalFoodScore = 0;
    for(Record *record in meal.records){
        totalFoodScore += record.food.score;
    }
    NSLog(@"Total carb count: %f", meal.totalCarbs);
    double totalFoodScoreFlipped = 0;
    for(Record *record in meal.records){
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
    for(Record *record in meal.records){
        Food *food = record.food;
        NSLog(@"Updating Food Item: %@", food.item);
        NSLog(@"Previous Food Carb Count: %f", food.carbs);
        double predictedCarbCount = food.carbs * record.amount;
        
        double singleFoodDistributionPercent = [self getFoodModifierPercentWithFoodScore:food.score
                                                                totalFoodScore:totalFoodScore
                                                                     carbCount:food.carbs
                                                                totalCarbCount:meal.totalCarbs];
        double newCarbCount = predictedCarbCount + extraCarbsForFood * singleFoodDistributionPercent;
        double updatedCarbCount = ((food.score * food.carbs) + newCarbCount) / (double)(food.score + 1) / record.amount;
        food.carbs = updatedCarbCount;
        //Update Food Score
        if([self getMealSuccess: meal]  == tooLowSugar && excessInsulinTaken > 1){
            food.score = MAX(1, food.score + 1);
        }else if([self getMealSuccess: meal]  == tooLowSugar && excessInsulinTaken <= 1 && excessInsulinTaken >= -1){
            food.score = MAX(1, food.score - 1);
        }else if([self getMealSuccess: meal]  == tooLowSugar && excessInsulinTaken < -1){
            food.score = MAX(1, food.score - 5);
        }else if([self getMealSuccess: meal]  == perfectSugar && excessInsulinTaken > 1){
            food.score = MAX(1, food.score - 2);
        }else if([self getMealSuccess: meal]  == perfectSugar && excessInsulinTaken <= 1 && excessInsulinTaken >= -1){
            food.score = MAX(1, food.score + 6);
        }else if([self getMealSuccess: meal]  == perfectSugar && excessInsulinTaken < -1){
            food.score = MAX(1, food.score - 2);
        }else if([self getMealSuccess: meal]  == tooHighSugar && excessInsulinTaken > 1){
            food.score = MAX(1, food.score - 5);
        }else if([self getMealSuccess: meal]  == tooHighSugar && excessInsulinTaken <= 1 && excessInsulinTaken >= -1){
            food.score = MAX(1, food.score - 1);
        }else if([self getMealSuccess: meal]  == tooHighSugar && excessInsulinTaken < -1){
            food.score = MAX(1, food.score + 1);
        }
        
        NSLog(@"New Food Carb Count: %f", food.carbs);
    }
    
    //Update Units per Carb
    double newCarbsPerUnit = user.carbsPerUnit - (extraCarbsForCarbsPerUnit / fabs(meal.unitsPredicted));
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
    
    
    
    
    [user saveChanges];
    [[DatabaseConnector getSharedDBAccessor] saveChanges];
    
    return YES;
}

+ (double) getFoodModifierPercentWithFoodScore: (double)foodScore
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

+ (SugarLevel) getMealSuccess: (Meal *) meal {
    if(meal.levelAfter >= 90 && meal.levelAfter <= 145){
        return perfectSugar;
    } else if(meal.levelAfter < 90){
        return tooLowSugar;
    } else {
        return tooHighSugar;
    }
}

+ (void) updateMealCorrections {
    
}


@end
