//
//  Stats.h
//  Maze
//
//  Created by ian on 10/18/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stats : NSManagedObject

@property (nonatomic, retain) NSNumber * coins;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * time;

@end
