//
//  RecordLayer.m
//  Maze
//
//  Created by ian on 11/26/12.
//
//

#import "RecordLayer.h"

@implementation RecordLayer

-(id)init {
    self = [super init];
    if (self != nil) {
        statsKeeper = [StatsKeeper createSingleton];

        
    }
    return self;
}


@end
