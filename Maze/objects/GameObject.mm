//
//  GameObject.m
//  Maze
//
//  Created by ian on 1/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject

@synthesize body, type, health;

-(id) init {
    if( (self = [super init]) ){
        active = FALSE;
        type = G_OBJET;
    }
    return self;
}

- (void) dealloc{
    [super dealloc];
    
}

-(void)printDebugStats
{
    NSLog(@"(debug) GameObeject - health:%d", self.health);
    
}

/*Location*/
-(void)placeAtLocation:(CGPoint)location
{
    
}

/*Visual*/
-(void)changeSkin
{
    
}

-(void)display
{
    [self setVisible:TRUE];
}

-(void)removeFromDisplay
{
    [self setVisible:FALSE];
}

/*Data*/
-(void)removeFromPool
{
    
}

@end
