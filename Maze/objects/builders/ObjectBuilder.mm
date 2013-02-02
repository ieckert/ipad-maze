//
//  ObjectBuilder.m
//  Maze
//
//  Created by ian on 1/24/13.
//
//

#import "ObjectBuilder.h"
#import "Pool.h"
#import "MazeObject.h"

@implementation ObjectBuilder
static ObjectBuilder *singleton = nil;

-(id) init {
    if( (self = [super init]) ){
        /*
         the order in the lookup tables is very important!
         the index into the table is taken from the G_<TYPE>'s defined in Constants.h
         so if you want the value for G_MAZE, the index would be the int
         value of the enum, G_MAZE's.
         
         if the objects in the lookup table are out of order with the listing of GameObjects
         in Constants.h, then you will not get the correct object for your type
         */
        poolSizeLookup = [[NSArray alloc] initWithObjects:
                          [NSNumber numberWithInt:C_POOL_SIZE_OBJECT],  //G_OBJET
                          [NSNumber numberWithInt:C_POOL_SIZE_MAZE],    //G_MAZE
                          nil];
        objectCreationLookup = [[NSArray alloc] initWithObjects:
                                [^{return [[GameObject alloc] init];} copy],   //G_OBJET
                                [^{return [[MazeObject alloc] init];} copy],   //G_MAZE
                                [^{return nil;} copy],                         //G_PLAYER
                                [^{return nil;} copy],                         //G_ENEMY
                                [^{return nil;} copy],                         //G_ENEMY_SHOOTING
                                [^{return nil;} copy],                         //G_WALL
                                [^{return nil;} copy],                         //G_COIN
                                [^{return nil;} copy],                         //G_DOOR
                                [^{return nil;} copy],                         //G_POOL
                                nil];
    }
    return self;
}

+ (ObjectBuilder *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[ObjectBuilder alloc] init];
        }
    }
    return singleton;
}

- (void) dealloc{
    [poolSizeLookup release];
    [objectCreationLookup release];
    [super dealloc];
}

-(NSInteger)checkRange:(ObjectType)poolType
{
    return (poolType < 0 || poolType >= G_NUM_OBJECT_TYPES) ? C_POOL_SIZE : [[poolSizeLookup objectAtIndex:poolType] integerValue];
}

-(Pool*) buildPool:(ObjectType)poolType
{
    NSInteger size = [self checkRange:poolType];
    return [[Pool alloc] initWithObjectType:poolType Size:size];
}

-(GameObject*)buildObject:(ObjectType)objectType
{
    GameObject* (^objectCreation)(ObjectType) = [objectCreationLookup objectAtIndex:objectType];
    return objectCreation(objectType);
}

@end