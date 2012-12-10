//
//  DataAdapter.m
//  Maze
//
//  Created by ian on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataAdapter.h"
#import "Stats.h"
#import "Settings.h"
@interface DataAdapter()

-(NSURL *)itemArchivePath;
-(BOOL)shouldUpdateLevel:(NSNumber*)level Time:(NSNumber*)time Coins:(NSNumber*)coins;

@end

@implementation DataAdapter
static DataAdapter *singleton = nil;

- (id)init
{
    self = [super init];
    if (self) {        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
           
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
                
        NSError *error = nil;
        NSURL *storeURL = [[self itemArchivePath] URLByAppendingPathComponent:@"Maze.sqlite"];
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        managedObjectContext = [[[NSManagedObjectContext alloc] init] retain];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
        [managedObjectContext setUndoManager:nil];
        
//        [self deleteStatisticsForAllLevels];

//        [self printAllLevelStats];
    }
    
    return self;
}

+ (DataAdapter *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[DataAdapter alloc] init];
        }
    }
    return singleton;
}

-(void) dealloc
{
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
        
    [super dealloc];
}

-(BOOL)changeSettings:(NSNumber*) screenRotation
{
//    NSLog(@"trying to add change settings");

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [[managedObjectModel entitiesByName] objectForKey:@"Settings"];
        
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    if ([result count] > 0) {
        Settings *settings = [result objectAtIndex:0];
        [settings setScreenRotation:screenRotation];
//        NSLog(@"should have saved settings");
    }
    else
    {
        Settings *settings = (Settings*)[NSEntityDescription insertNewObjectForEntityForName:@"Settings"
                                                                 inManagedObjectContext:managedObjectContext];
        [settings setScreenRotation:screenRotation];
        NSError *error = nil;
    }
    return [managedObjectContext save:&error];
}

-(Settings*)returnSettings
{
//    NSLog(@"trying to returnSettings");
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [[managedObjectModel entitiesByName] objectForKey:@"Settings"];
    
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    if ([result count] > 0) {
        Settings *settings = [result objectAtIndex:0];
        return settings;
    }
    return nil;
}

-(BOOL)addStatisticsToLevel:(NSNumber*) level WithTime:(NSNumber*) time AndCoins:(NSNumber*) coins
{
//    NSLog(@"trying to add new level stat");
    if ( [self shouldUpdateLevel:level Time:time Coins:coins] )
    {
        /*just incase the user beat their last score*/
        [self deleteStatisticsForLevel:level];
        
        Stats *levelStat = (Stats*)[NSEntityDescription insertNewObjectForEntityForName:@"Stats" 
                                                                 inManagedObjectContext:managedObjectContext];
        [levelStat setLevel:level];
        [levelStat setTime:time];
        [levelStat setCoins:coins];
        
//        NSLog(@"in add - Level:%i Time:%i Coins:%i", [[levelStat level] intValue], [[levelStat time] intValue], [[levelStat coins] intValue]);
        
    }
    else {
        //Nothing to update - the previous "saved" level was better than this run
        NSLog(@"in add - this run did not beat the previous times");
    }
    NSError *error = nil;
    return [managedObjectContext save:&error];
}

-(BOOL)deleteStatisticsForLevel:(NSNumber*)level
{
//    NSLog(@"delete stats for level! %i", [level intValue]);

    BOOL returnBool = TRUE;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Stats" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(level = %@)", level];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if ([array count] < 1)
    {
        returnBool = FALSE;
    }
    else {
        for (Stats *object in array) {
            [managedObjectContext deleteObject:object];
        }
    }
    
    [managedObjectContext save:&error];
    
    return returnBool;
}

-(BOOL)deleteStatisticsForAllLevels
{
//    NSLog(@"delete stats for all levels!");
    NSArray *allLevels = [self loadAllLevels];
    for (Stats* object in allLevels) {
        [managedObjectContext deleteObject:object];
    }
    NSError *error = nil;
    return [managedObjectContext save:&error];
}

-(NSArray*)loadAllLevels
{
//    NSLog(@"loading all levels!");
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [[managedObjectModel entitiesByName] objectForKey:@"Stats"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"level" ascending:YES];        
    
    [request setEntity:entityDescription];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"fetch failed" format:@"reason: %@", [error localizedDescription]];
    }
    [request release];
    return result;
}

-(BOOL)saveChanges
{
    NSError *error = nil;
    
    BOOL successful = [managedObjectContext save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@",[error localizedDescription]);
    }
    return successful;
}

-(NSInteger) returnLatestLevel
{
    NSArray *allLevels = [self loadAllLevels];
    Stats *tmp = [allLevels lastObject];
    return (tmp==nil || !tmp) ? 1 : [[tmp level] intValue]+1;
}


-(void) printAllLevelStats
{
    NSArray *allLevels = [self loadAllLevels];
    NSLog(@"core data holds %i levels", [allLevels count]);
    for (Stats* object in allLevels) {
        NSLog(@"Level:%i Time:%i Coins:%i", [[object level] intValue], [[object time] intValue], [[object coins] intValue]);
    }
    
    return;
}

-(BOOL)shouldUpdateLevel:(NSNumber*)level Time:(NSNumber*)time Coins:(NSNumber*)coins
{
    BOOL returnBool = FALSE;
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Stats" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(level = %@) AND (time <= %@) AND (coins >= %@)", level, time, coins];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil)
        NSLog(@"Error: %@", error);
    if ([array count] < 1)
    {
        returnBool = TRUE;
    }
//for debugging    
/*    
    NSLog(@"in should update level - Level:%i Time:%i Coins:%i", [level intValue], [time intValue], [coins intValue]);

    for (Stats* object in array) {
        NSLog(@"in should update level - Level:%i Time:%i Coins:%i", [[object level] intValue], [[object time] intValue], [[object coins] intValue]);
    }
*/    
    return returnBool;
}

-(NSURL *)itemArchivePath
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
