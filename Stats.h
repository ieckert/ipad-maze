//
//  Stats.h
//  Maze
//
//  Created by ian on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stats : NSManagedObject

@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * coins;

@end
