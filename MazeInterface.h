//
//  MazeInterface.h
//  Maze
//
//  Created by ian on 9/26/12.
//
//

#import <Foundation/Foundation.h>

@interface MazeInterface : NSObject
{
    NSMutableArray *openXPoints;
    NSMutableArray *openYPoints;
    BOOL openPointsSorted;
}
+(MazeInterface *) createSingleton;

-(void) removeAllOpenPoints;
-(CGPoint) findClosestArrayMatchToPoint:(CGPoint)point;
-(void) addPoint:(CGPoint)point;
-(CGPoint) returnRandomOpenPoint;

@end
