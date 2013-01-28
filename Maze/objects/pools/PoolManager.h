//
//  PoolManager.h
//  Maze
//
//  Created by ian on 1/22/13.
//
//

#import <Foundation/Foundation.h>
#import "Pool.h"
#import "Constants.h"

@interface PoolManager : NSObject
{
    NSMutableArray *pools;
}
+(PoolManager *) createSingleton;

-(void)printPoolStats:(ObjectType)type;
-(void)printAllPoolStats;

-(GameObject*)getObject:(ObjectType)objectType;
-(void)buildObjects:(NSInteger)count OfType:(ObjectType)objectType;
-(BOOL)returnObject:(GameObject**)gameObject;

-(Pool*)getPool:(ObjectType)objectType;
-(CCArray *)getActiveObjects;
-(NSMutableArray *)getAllBatchNodes;

-(NSInteger)countPools;
-(NSInteger)countAllObjectsInPool:(ObjectType)type;
-(NSInteger)countActiveObjectsInPool:(ObjectType)type;
-(NSInteger)countInactiveObjectsInPool:(ObjectType)type;

-(void)emptyPools;

@end
