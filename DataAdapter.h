//
//  DataAdapter.h
//  Maze
//
//  Created by ian on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataAdapter : NSObject
{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

+ (DataAdapter *) createSingleton;

-(BOOL)saveChanges;
-(NSArray*)loadAllLevels;

-(BOOL)addStatisticsToLevel:(NSNumber*) level WithTime:(NSNumber*) time AndCoins:(NSNumber*) coins;
-(BOOL)deleteStatisticsForLevel:(NSNumber*)level;
-(BOOL)deleteStatisticsForAllLevels;

/*mainly for debugging*/
-(void)printAllLevelStats;

@end
