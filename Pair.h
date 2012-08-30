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
    NSInteger num1;
    NSInteger num2;
}
@property (readwrite) NSInteger num1;
@property (readwrite) NSInteger num2;

-(id) initWithRequirements: (NSInteger) b1
                          : (NSInteger) b2;

@end

