//
//  ObjectBuilder.h
//  Maze
//
//  Created by ian on 1/24/13.
//
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#import "MazeObject.h"
#import "Pool.h"

@interface ObjectBuilder : NSObject
{
    
}

+(GameObject*) buildObject:(ObjectType)objectType;
+(Pool*) buildPool:(ObjectType)poolType;

@end
