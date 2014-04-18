//
//  User.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "User.h"

@implementation User

- (id) init {
    if (self = [super init]) {
        NSString *path = [self userArchivePath];
        User *u = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (u.carbsPerUnit > 0) {
            return u;
        }else{
            NSLog(@"Create new User");
            self.carbsPerUnit = 2.0f;
            NSLog(@"first save: %f", self.carbsPerUnit);
            self.carbsPerUnitScore = 1;
            self.sugarsPerUnit = 0.0f;
            self.sugarsPerUnitScore = 1;
            self.breakfastCorrection = 0.0f;
            self.breakfastCorrectionScore = 1;
            self.lunchCorrection = 0.0f;
            self.lunchCorrectionScore = 1;
            self.dinnerCorrection = 0.0f;
            self.dinnerCorrectionScore = 1;
        }
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.carbsPerUnit forKey:@"carbsPerUnit"];
    [aCoder encodeInt:self.carbsPerUnitScore forKey:@"carbsPerUnitScore"];
    [aCoder encodeInt:self.sugarsPerUnit forKey:@"sugarsPerUnit"];
    [aCoder encodeInt:self.sugarsPerUnitScore forKey:@"sugarsPerUnitScore"];
    [aCoder encodeInt:self.breakfastCorrection forKey:@"breakfastCorrection"];
    [aCoder encodeInt:self.breakfastCorrectionScore forKey:@"breakfastCorrectionScore"];
    [aCoder encodeInt:self.lunchCorrection forKey:@"lunchCorrection"];
    [aCoder encodeInt:self.lunchCorrectionScore forKey:@"lunchCorrectionScore"];
    [aCoder encodeInt:self.dinnerCorrection forKey:@"dinnerCorrection"];
    [aCoder encodeInt:self.dinnerCorrectionScore forKey:@"dinnerCorrectionScore"];
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self){
        self.carbsPerUnit = [aDecoder decodeIntForKey:@"carbsPerUnit"];
        self.carbsPerUnitScore = [aDecoder decodeIntForKey:@"carbsPerUnitScore"];
        self.sugarsPerUnit = [aDecoder decodeIntForKey:@"sugarsPerUnit"];
        self.sugarsPerUnitScore = [aDecoder decodeIntForKey:@"sugarsPerUnitScore"];
        self.breakfastCorrection = [aDecoder decodeIntForKey:@"breakfastCorrection"];
        self.breakfastCorrectionScore = [aDecoder decodeIntForKey:@"breakfastCorrectionScore"];
        self.lunchCorrection = [aDecoder decodeIntForKey:@"lunchCorrection"];
        self.lunchCorrectionScore = [aDecoder decodeIntForKey:@"lunchCorrectionScore"];
        self.dinnerCorrection = [aDecoder decodeIntForKey:@"dinnerCorrection"];
        self.dinnerCorrectionScore = [aDecoder decodeIntForKey:@"dinnerCorrectionScore"];
    }
    return self;
}

- (NSString *)userArchivePath {
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"user.archive"];
}

- (BOOL)saveChanges {
    NSLog(@"Save User");
    NSString *path = [self userArchivePath];
    return [NSKeyedArchiver archiveRootObject:self
                                       toFile:path];
}

@end
