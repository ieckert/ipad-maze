//
//  DataAdapter.h
//  Maze
//
//  Created by ian on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Settings.h"
@interface DataAdapter : NSObject
{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

+ (DataAdapter *) createSingleton;

-(BOOL)saveChanges;
-(NSArray*)loadAllLevels;

-(BOOL)addStatisticsToLevel:(NSNumber*) level WithTime:(NSNumber*) time AndCoins:(NSNumber*) coins WithHealth:(NSNumber*)health;
-(BOOL)deleteStatisticsForLevel:(NSNumber*)level;
-(BOOL)deleteStatisticsForAllLevels;
-(Settings*)returnSettings;
-(BOOL)changeSettings:(NSNumber*) screenRotation;
-(NSInteger) returnLatestLevel;
-(NSInteger) returnLatestHealth;

/*mainly for debugging*/
-(void)printAllLevelStats;

@end
