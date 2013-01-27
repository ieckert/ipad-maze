//
//  MazeObject.h
//  Maze
//
//  Created by ian on 1/21/13.
//
//

#import "GameObject.h"
#import "cocos2d.h"

@interface MazeObject : GameObject {
    
    NSInteger m_rows;
    NSInteger m_cols;
    NSInteger m_height;
    NSInteger m_width;
    NSInteger m_circles;
    
    NSString *m_wall;
    
}

-(id)initWithHeight:(NSInteger)height Width:(NSInteger)width Circles:(NSInteger)circles Wall:(NSString*)wall;
-(id)init;

-(void)build;
-(void)setHeight:(NSInteger)height Width:(NSInteger)width;

@end
