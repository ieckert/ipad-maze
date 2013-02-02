//
//  Pool.h
//  Maze
//
//  Created by ian on 1/22/13.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "GameObject.h"
#import "ObjectBuilder.h"

@class ObjectBuilder; //forward defination to prevent dependency cycles

@interface Pool : NSObject
{
    CCSpriteBatchNode *p_spriteBatchNode;
    NSMutableArray *activeObjects;
    NSMutableArray *inactiveObjects;
    
    ObjectBuilder *objectBuilder;
    ObjectType poolType;
    
    NSString *p_atlasList;
    NSString *p_atlasImage;
    
}
@property (readonly) ObjectType poolType;

-(id)initWithList:(NSString *)list Image:(NSString *)image ObjectType:(ObjectType)objectType Size:(NSInteger)size;
-(id)initWithObjectType:(ObjectType)objectType Size:(NSInteger)size;
-(id)init;

-(void)printStats;

-(void)setAtlasList:(NSString*)list AndAtlasImage:(NSString*)image AndRebuildObjects:(NSInteger)count;

-(GameObject *)getObject;
-(BOOL)returnObject:(GameObject**)gameObject;
-(CCArray *)getActiveObjects;
-(CCSpriteBatchNode *)getBatchNode;

-(NSInteger)countActiveObjects;
-(NSInteger)countInactiveObjects;
-(NSInteger)countAllObjects;

-(void)emptyPool;
-(void)buildObjects:(NSInteger)count;
@end
