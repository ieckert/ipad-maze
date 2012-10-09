//
//  MazeInterface.m
//  Maze
//
//  Created by ian on 9/26/12.
//
//

#import "MazeInterface.h"

@implementation MazeInterface
static MazeInterface *singleton = nil;

- (void)dealloc
{
    [openYPoints release];
    [openXPoints release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        openXPoints = [[NSMutableArray alloc] init];
        openYPoints = [[NSMutableArray alloc] init];
        openPointsSorted = false;
    }
    return self;
}

+ (MazeInterface *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[MazeInterface alloc] init];
        }
    }
    return singleton;
}

-(void) addPoint:(CGPoint)point
{
    [openXPoints addObject:[NSNumber numberWithFloat:point.x]];
    [openYPoints addObject:[NSNumber numberWithFloat:point.y]];
    openPointsSorted = false;
}

-(void) sortPoints
{
    NSArray *tmpArr = [openXPoints sortedArrayUsingSelector:@selector(compare:)];
    [openXPoints setArray:tmpArr];
    
    tmpArr = [openYPoints sortedArrayUsingSelector:@selector(compare:)];
    [openYPoints setArray:tmpArr];
    openPointsSorted = true;
}

-(void) removeAllOpenPoints
{
    [openXPoints removeAllObjects];
    [openYPoints removeAllObjects];
    openPointsSorted = false;
}

-(float) searchInArray:(NSMutableArray*)arr ForNumber:(float)findNum
{
//    NSLog(@"in searchInArray");
    
    float tmp1, tmp2;
    NSInteger arrSize = [arr count];
    NSInteger keepIndex = arrSize-1;

    for (int i=0; i < arrSize; i++) {
        if (findNum < [[arr objectAtIndex:i] floatValue] ) {
//            NSLog(@"in searchArrayFor: i: %i arrSize: %i", i, arrSize);
            keepIndex = i;
            break;
        }
    }
//    NSLog(@"keepIndex: %i", keepIndex);
//prevents bounds errors
    if (keepIndex-1 >= 0)
        tmp1 = [[arr objectAtIndex:(keepIndex-1)] floatValue];
    else
        tmp1 = [[arr objectAtIndex:keepIndex] floatValue];

    tmp2 = [[arr objectAtIndex:keepIndex] floatValue];
//    NSLog(@"exiting searchInArray");

    if ( (findNum - tmp1) < (tmp2 - findNum) )
        return tmp1;
    else
        return tmp2;
}

-(CGPoint) returnRandomOpenPoint
{
    CGPoint tmpPoint;
    tmpPoint.x = [[openXPoints objectAtIndex:(arc4random()%[openXPoints count])] floatValue] ;
    tmpPoint.y = [[openYPoints objectAtIndex:(arc4random()%[openYPoints count])] floatValue] ;
    return tmpPoint;
}


-(CGPoint) findClosestArrayMatchToPoint:(CGPoint)point
{
//    NSLog(@"in findClosestArrayMatchToPoint");

    CGPoint tmpPoint;
        
    if (!openPointsSorted)
        [self sortPoints];
    
    tmpPoint.x = [self searchInArray:openXPoints ForNumber:point.x];
    tmpPoint.y = [self searchInArray:openYPoints ForNumber:point.y];
//    NSLog(@"exiting findClosestArrayMatchToPoint");

    return tmpPoint;
}

@end
