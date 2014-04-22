//
//  DatabaseConnector.m
//  DPredictor
//
//  Created by Joshua Primas on 4/17/14.
//  Copyright (c) 2014 Joshua Primas. All rights reserved.
//

#import "DatabaseConnector.h"
#import "Food.h"

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

@end
