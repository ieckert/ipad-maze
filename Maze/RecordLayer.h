//
//  RecordLayer.h
//  Maze
//
//  Created by ian on 11/26/12.
//
//

#import "CCLayer.h"
#import "DataAdapter.h"
#import "StatsKeeper.h"


@interface RecordLayer : CCLayer
{
    StatsKeeper *statsKeeper;
}

@end
