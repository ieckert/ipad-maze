//
//  StatsObject.h
//  Maze
//
//  Created by ian on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsObject : NSObject {

    NSInteger coins;
    NSInteger time;
}

@property (readwrite, assign) NSInteger coins;
@property (readwrite, assign) NSInteger time;

@end
