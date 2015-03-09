//
//  DatabaseConnector.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "DatabaseConnector.h"
#import "Food.h"
#import "Meal.h"

@interface DatabaseConnector ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation DatabaseConnector

+ (instancetype)getSharedDBAccessor
{
    static DatabaseConnector *sharedAccessor = nil;
    
    // Do I need to create a sharedStore?
    if (!sharedAccessor) {
        sharedAccessor = [[self alloc] initPrivate];
    }
    
    return sharedAccessor;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[Results sharedResultsAccessor]"
                                 userInfo:nil];
    return nil;
}


- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        self.model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc =
            [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        
        //Get the SQLite File
        NSString *path = self.itemArchivePath;
        NSURL *dbURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:dbURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        // Create the managed object context
        self.context = [[NSManagedObjectContext alloc] init];
        self.context.persistentStoreCoordinator = psc;
    }
    
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                            NSUserDomainMask,
                                            YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"db.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (Meal *)createMeal{
    Meal *meal = [NSEntityDescription insertNewObjectForEntityForName:@"Meal"
                                                 inManagedObjectContext:self.context];
    return meal;
}

- (NSArray *) getMeals{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Meal"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(levelBefore > 0)"];
    [request setPredicate:predicate];

    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return result;

}

- (Record *)createRecord{
    Record *record = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                               inManagedObjectContext:self.context];
    return record;
}

- (Food *)createFoodWithItem:(NSString *)item
               quantifier:(NSString *)quantifier
                   amount:(double)amount
                    carbs:(double)carbs
                    units:(double)units
{
    Food *food = [NSEntityDescription insertNewObjectForEntityForName:@"Food"
                                               inManagedObjectContext:self.context];
    food.carbs = carbs / amount;
    food.quantifier = quantifier; //TODO: standardize quantifiers
    food.item = item;
    food.amount = 1.0;
    [food standardizeQuantfier];
    return food;
}

- (NSArray *)getSimilarFoods:(NSString *)name {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Food"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(item CONTAINS[cd] %@)", name];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return result;
    
}

- (NSArray *)getRecentFoods {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Food"
                                         inManagedObjectContext:self.context];
    request.entity = e;

    [request setFetchLimit:20];
    
     NSSortDescriptor *sd = [NSSortDescriptor
     sortDescriptorWithKey:@"createdAt"
     ascending:YES];
     request.sortDescriptors = @[sd];
    
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return result;
}

- (BOOL) alreadyExistsWithName:(NSString *)item withQuantifier:(NSString *)quantifer{
    quantifer = [Food standardizeQuantfier:quantifer];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Food"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(item MATCHES[cd] %@ AND quantifier MATCHES[cd] %@)", item, quantifer];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    if([result count] > 0){
        return YES;
    }else{
        return NO;
    }

}

- (BOOL) hasUnfinishedMeal {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Meal"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"levelAfter = -1 "];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    if([result count] > 0){
        return YES;
    }else{
        return NO;
    }
}

- (Meal *) getUnfinishedMeal {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Meal"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"levelAfter = -1 "];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sd = [NSSortDescriptor
                            sortDescriptorWithKey:@"createdAt"
                            ascending:NO];
    request.sortDescriptors = @[sd];
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    if([result count] > 0){
        return result[0];
    }else{
        return NULL;
    }
}

- (NSArray *) getAllFoodRecords {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Food"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"item" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    return result;
}

- (double) getAverageCarbErrorForMealType:(NSString *)mealType{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Meal"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"mealType = %@", mealType];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sd = [NSSortDescriptor
                            sortDescriptorWithKey:@"createdAt"
                            ascending:NO];
    request.sortDescriptors = @[sd];
    
    [request setFetchLimit:200];
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
    }
    if([result count] > 0){
        double totalError = 0;
        for(Meal *meal in result){
            totalError += meal.levelAfter - 130;
        }
        return totalError / [result count];
    }else{
        return 0;
    }
}





@end
