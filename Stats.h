//
//  Stats.h
//  Maze
//
//  Created by ian on 12/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Stats : NSManagedObject

@property (nonatomic, retain) NSNumber * coins;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * health;

@end
