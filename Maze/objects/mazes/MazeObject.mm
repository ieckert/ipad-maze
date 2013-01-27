//
//  MazeObject.m
//  Maze
//
//  Created by ian on 1/21/13.
//
//

#import "MazeObject.h"

@implementation MazeObject

-(void)printDebugStats
{
    NSLog(@"maze object (%@) - height: %i width: %i circles: %i wall: %@ ",
          self, m_height, m_width, m_circles, m_wall);
    [super printDebugStats];
}

-(id)initWithHeight:(NSInteger)height Width:(NSInteger)width Circles:(NSInteger)circles Wall:(NSString*)wall
{
    if( (self = [super init]) ){
        m_height = height;
        m_width = width;
        m_circles = circles;
        m_wall = wall;
        type = G_MAZE;    
    }
    return self;
}

-(id) init {
    return [self initWithHeight:0 Width:0 Circles:0 Wall:nil];
}

- (void) dealloc{
    [super dealloc];    
}

-(void)build
{
    
}

-(void)setHeight:(NSInteger)height Width:(NSInteger)width
{
    m_height = height;
    m_width = width;
    /*
    smallMazeCols = (windowWidth / wallWidth / kTrueScale)-1;
    smallMazeRows = (windowHeight / wallHeight / kTrueScale)-1;
    
    largeMazeRows = (smallMazeRows*kTrueScale)+1;
    largeMazeCols = (smallMazeCols*kTrueScale)+1;
    
    largeMazeSize = largeMazeRows*largeMazeCols;
    smallMazeSize = smallMazeRows*smallMazeCols;
     */
}



@end
