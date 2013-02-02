//
//  ObjectBuilder.h
//  Maze
//
//  Created by ian on 1/24/13.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "GameObject.h"
#import "Pool.h"

@class Pool;    //forward defination to prevent dependency cycles

@interface ObjectBuilder : NSObject
{
    NSArray *poolSizeLookup;
    NSArray *objectCreationLookup;
}

+(ObjectBuilder *) createSingleton;

-(Pool*) buildPool:(ObjectType)poolType;
-(GameObject*) buildObject:(ObjectType)objectType;

@end
