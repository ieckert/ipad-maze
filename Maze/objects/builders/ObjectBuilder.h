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

@class Pool;

@interface ObjectBuilder : NSObject
{
    NSMutableArray *poolSizeLookup;
    NSMutableArray *objectCreationLookup;
}

+(ObjectBuilder *) createSingleton;

-(Pool*) buildPool:(ObjectType)poolType;
-(GameObject*) buildObject:(ObjectType)objectType;

@end
