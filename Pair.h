//
//  Pair.h
//  Maze
//
//  Created by ian on 7/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pair : NSObject
{
    NSInteger chosenBlock;
    NSInteger breakdownBlock;
}
@property (readwrite) NSInteger chosenBlock;
@property (readwrite) NSInteger breakdownBlock;

-(id) initWithRequirements: (NSInteger) b1
                          : (NSInteger) b2;

@end

