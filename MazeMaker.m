//
//  MazeMaker.m
//  Maze
//
//  Created by ian on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MazeMaker.h"
#import "CommonProtocols.h"
#import "Constants.h"
#import "Pair.h"
#import "ObjectInfoConstants.h"

@implementation MazeMaker
@synthesize rows, cols;
@synthesize wallList;

-(id)init
{
    self = [super init];
    if (self) {
        rows = 0;
        cols = 0;
    }
    return self;
}

- (void) dealloc
{
    NSLog(@"MazeMaker Dealloc");
    [disjsets release];
    [wallList release];
    [fullKeysList release];
    [fullBreakdownOptionsList release];
    
	[super dealloc];
}

-(id) initWithSizeAndRequirements: (NSInteger) numRows: (NSInteger) numCols: (MazeRequirements*) reqs: (NSMutableArray*) maze
{
    if (self = [super init])
    {
        NSLog(@"MazeMaker InitWithSizeAndRequirements");
        translationReturnPair = [[Pair alloc] initWithRequirements:0 :0];
        rows = numRows;
        cols = numCols;
        disjsets = [[Disjsets alloc] initWithSize:rows :cols];
        realMaze = maze;
        requirements = reqs;
        
        wallList = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < rows*cols; i++)
        {
            [wallList setObject:[[NSMutableSet alloc] init] forKey:[NSNumber numberWithInt:i]];
        }
        
        for (int i = 0; i < rows*kTrueScale*cols*kTrueScale; i++)
        {
            [realMaze insertObject:[NSNumber numberWithInt:tWall] atIndex:i];
        }
//        NSLog(@"mazeMaker - mazeSize: %i", [realMaze count] );
        
        fullBreakdownOptionsList = [[NSMutableDictionary alloc] init];
        int currentNum=0;
        for (int i=0; currentNum < rows*cols; i++)
        {
//            NSLog(@"building the fullBreakdownOptionsList. currentNum: %i", currentNum);

            /*
             cases:
             5x5 maze - showing the different cases you will need when joining a random side
             01112
             34445
             34445
             34445
             67778
             */   

            if (currentNum == 0) {
                //case 0
                //            NSLog(@"case0");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+cols] forKey:[NSNumber numberWithInt:i]];
            }
            else if (currentNum > 0 && currentNum < (cols - 1)) {
                //case 1
                //            NSLog(@"case1");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+cols] forKey:[NSNumber numberWithInt:i]];
            }
            else if (currentNum == cols -1) {
                //case 2
                //            NSLog(@"case2");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+cols] forKey:[NSNumber numberWithInt:i]];
            }
            else if (currentNum > 0 && currentNum < ((rows * cols) - cols) && (currentNum % cols) == 0) {
                //case 3
                //            NSLog(@"case3");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+cols] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-cols] forKey:[NSNumber numberWithInt:i]];                
            }
            else if (currentNum > (cols - 1) && currentNum < ((rows * cols) - 1) && ((currentNum+1) % cols) == 0) {
                //case 5
                //            NSLog(@"case5");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+cols] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-cols] forKey:[NSNumber numberWithInt:i]];                
            }
            else if (currentNum == ((rows * cols) - cols)) {
                //case 6
                //            NSLog(@"case6");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-cols] forKey:[NSNumber numberWithInt:i]];
            }
            else if (currentNum > ((rows * cols) - cols) && currentNum < ((rows * cols)-1)) {
                //case 7
                //            NSLog(@"case7");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-cols] forKey:[NSNumber numberWithInt:i]];                
            }
            else if (currentNum == ((rows * cols) - 1)) {
                //case 8
                //            NSLog(@"case8");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-cols] forKey:[NSNumber numberWithInt:i]];
            }
            else {
                //case 4
                //            NSLog(@"case4");
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum+cols] forKey:[NSNumber numberWithInt:i]];
                i++;
                [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                     initWithRequirements:currentNum :currentNum-cols] forKey:[NSNumber numberWithInt:i]];
            }
            currentNum++;
            
        }
        
    }
    return self;
}

-(BOOL) properWallRemoval: (NSInteger) wall1: (NSInteger) wall2: (NSInteger) hallwayLength
{
    if ([requirements straightShot] == FALSE) {        
        int t1, count, diff, allowedRange;
        t1=0;
        count=0;
        diff=0;
        allowedRange = hallwayLength;
        
        diff = wall1-wall2;
//wall1 should always be larger        
        if (diff < 0) {
            diff = diff*-1;
            t1 = wall2;
            wall2 = wall1;
            wall1 = t1;
        }
        t1 = wall1;
            for (int i = 0; i < hallwayLength; i++) {
                if ( [[wallList objectForKey:[NSNumber numberWithInt:t1]] 
                      containsObject:[NSNumber numberWithInt:(t1+diff)]] ) {
                    count++;
                }
//                NSLog(@"t1: %i diff: %i count: %i", t1, diff, count);
                t1 += diff;
            }
            if (count == hallwayLength)
                return FALSE;
        
        count = 0;
        t1 = wall2;
            for (int i = 0; i < hallwayLength; i++) {
                if ( [[wallList objectForKey:[NSNumber numberWithInt:t1]] 
                      containsObject:[NSNumber numberWithInt:(t1-diff)]] ) {
                    count++;
                }
//                NSLog(@"t1: %i diff: %i count: %i", t1, diff, count);
                t1 -= diff;
            }
            if (count == hallwayLength)
                return FALSE;        
    }
    
    return TRUE;
}

-(NSInteger) sameSet
{
	int c=0;	//counter
	for(int i=0; i<rows*cols;i++)
	{
		if( [disjsets find:0] == [disjsets find:i] )
		{
			c++;	//track how many sets are in the same adt set
		}
	}
	return c;
}

-(void) placeCoins: (NSInteger) numCoins
{
/*
main idea - split maze into 4 psudo even quadrents
start with the quadrent closest to the end and place a coin there
move from quadrent to quadrent placeing coins until you have no more to place
 
how to:
    3x3 maze = 9x9 actual grid on the screen
    
        | -halfway is 4
    0123456789
    1   |
    2 Q1|  Q2
    3   |
   -4---------
    5   |
    6   |
    7 Q3|  Q4
    8   |
    9   |
    
    use % to get the X, Y value that will put you
    in the proper quadrent range
*/
    
    int rnum, randY, randX, halfwayX, halfwayY, counter;
    halfwayX = (cols*kTrueScale)/2;
    halfwayY = (rows*kTrueScale)/2;

    counter = 4;
    
    for (int i = 0; i < numCoins; i++) {
        randX = 0;
        randY = 0;
        rnum = 0;
        switch (counter) {
            case 3:
                randX = arc4random()%halfwayX;
                randY = arc4random()%halfwayY;
                
                break;
            case 2:
                randX = (arc4random()%((cols*kTrueScale)-halfwayX))+halfwayX;
                randY = arc4random()%halfwayY;
                
                break;
            case 1:
                randX = arc4random()%halfwayX;
                randY = (arc4random()%((rows*kTrueScale)-halfwayY))+halfwayY;                

                break;
            case 4:
                randX = (arc4random()%((cols*kTrueScale)-halfwayX))+halfwayX;                
                randY = (arc4random()%((rows*kTrueScale)-halfwayY))+halfwayY;                
                
                break;
                
            default:
                break;
        }
        rnum = [self translateLargeXYToArrayIndex:randX :randY];
        if ([[realMaze objectAtIndex:rnum] intValue] == tNone) {
//            NSLog(@"counter: %i rnum: %i randX: %i randY: %i rows: %i cols: %i", counter, rnum, randX, randY, rows, cols);
            [realMaze replaceObjectAtIndex:rnum withObject:[NSNumber numberWithInt:tCoin]];
            counter--;
        }
        else {
            i--;
        }
        //reset counter to start at area1
        if (counter == 0)
            counter = 4;
    }
}

-(void) shuffleIndicies {
//    NSLog(@"shuffling the indicies");
    fullKeysList = [[NSMutableArray alloc] initWithArray:[fullBreakdownOptionsList allKeys]];
    int max = [fullKeysList count];
//    NSLog(@"tmpArray count: %i", max);
    int randNum = 0;
    
    for (int i=0; i < max; i++) {
        randNum = arc4random() % max; 
//        NSLog(@"chose to shuffle %i, %i",i,randNum);
        [fullKeysList exchangeObjectAtIndex:i withObjectAtIndex:randNum];
    }
}

-(void) cutOutOfRealMaze: (NSInteger) x1: (NSInteger) x2: (BOOL) specialNodes {
    int num1 = x1;
    int num2 = x2;
    int newNum1, newNum2;

    newNum1 = [self translateSmallArrayIndexToLarge:num1];
    newNum2 = [self translateSmallArrayIndexToLarge:num2];
    
    //cut out walls from actual maze
    //        NSLog(@"chosen nodes        : %i, %i", num1, num2);
    //        NSLog(@"nodes on real maze  : %i, %i", newNum1, newNum2);
    
    if (!specialNodes)
    {
        if (num1 == num2 - 1) {
            for (int i = newNum1; i <= newNum2; i++) {
                //                NSLog(@"removing  : %i", i);
                [realMaze replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tNone]];
            }
        } else if (num1 == num2 + 1) {
            for (int i = newNum2; i <= newNum1; i++) {
                //                NSLog(@"removing  : %i", i);
                [realMaze replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tNone]];
            }
        } else if (num1 == num2 + cols) {
            for (int i = newNum2; i <= newNum1; i+= (cols * kTrueScale)) {
                //                NSLog(@"removing  : %i", i);
                [realMaze replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tNone]];
            }
        } else if (num1 == num2 - cols) {
            for (int i = newNum1; i <= newNum2; i+= (cols * kTrueScale)) {
                //                NSLog(@"removing  : %i", i);
                [realMaze replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tNone]];
            }
        } else {
            NSLog(@"when breaking down walls in true maze... found an impossible situation");
        }
    }
    else {
        //for now these will be the start / end points!
        [realMaze replaceObjectAtIndex:newNum1 withObject:[NSNumber numberWithInt:tStart]];
        [realMaze replaceObjectAtIndex:newNum2 withObject:[NSNumber numberWithInt:tFinish]];

    }
//    [[wallList objectForKey:[NSNumber numberWithInt:newNum1]] addObject:[NSNumber numberWithInt:newNum2]];
//    [[wallList objectForKey:[NSNumber numberWithInt:newNum2]] addObject:[NSNumber numberWithInt:newNum1]];
}

-(Boolean) createMaze
{
//    NSLog(@"wallList size:  %i", [wallList count]);
    NSInteger num1, num2;

    if (rows == 0 || cols == 0) {
        NSLog(@"can't have rows / cols be 0");
        return false;
    }
    
    int hallwayRange = 1;
    while ([self sameSet] != rows*cols) {
        [self shuffleIndicies];
//        NSLog(@"allowed hallway range: %i", hallwayRange);
        for (id object in fullKeysList) {
            if ([self sameSet] == rows*cols)
                break;
            num1 = [[fullBreakdownOptionsList objectForKey:object] num1];
            num2 = [[fullBreakdownOptionsList objectForKey:object] num2];
//            NSLog(@"chose to breakdown %i, %i",num1,num2);

            if ([disjsets find:num1] == [disjsets find:num2]) 
                continue;
            if ([self properWallRemoval:num1:num2:hallwayRange] == FALSE ) {
//                NSLog(@"skipping wall breakdown for because not proper wall removal");
                continue;
            }
            [disjsets unionSets:[disjsets find:num1] :[disjsets find:num2]];
            [[wallList objectForKey:[NSNumber numberWithInt:num1]] addObject:[NSNumber numberWithInt:num2]];
            [[wallList objectForKey:[NSNumber numberWithInt:num2]] addObject:[NSNumber numberWithInt:num1]];
            //NSLog(@"creating path between %i and %i", num1, num2);
            [self cutOutOfRealMaze:num1 :num2 :false];
    //        [fullKeysList removeObject:object];
        }
        hallwayRange++;
    }
   
//creates circles
    hallwayRange = 1;
//    NSLog(@"numCircles:%i", [requirements circles]);
    for (int i=0; i < [requirements circles];) {
        [self shuffleIndicies];
//        NSLog(@"allowed hallway range: %i", hallwayRange);
//        NSLog(@"size of keys list: %i", [fullKeysList count]);
        for (id object in fullKeysList) {
            if (i == [requirements circles])
                break;
            num1 = [[fullBreakdownOptionsList objectForKey:object] num1];
            num2 = [[fullBreakdownOptionsList objectForKey:object] num2];

            if ([self properWallRemoval:num1:num2:hallwayRange] == FALSE ) {
//                NSLog(@"skipping wall breakdown for because not proper wall removal");
                continue;
            }
            if ( [[wallList objectForKey:[NSNumber numberWithInt:num1]] containsObject:[NSNumber numberWithInt:num2] ] ) {
                continue;
            }
            
            [[wallList objectForKey:[NSNumber numberWithInt:num1]] addObject:[NSNumber numberWithInt:num2]];
            [[wallList objectForKey:[NSNumber numberWithInt:num2]] addObject:[NSNumber numberWithInt:num1]];
//            NSLog(@"in circles: chose to breakdown %i, %i",num1,num2);

            [self cutOutOfRealMaze:num1 :num2 :false];
            i++;
            //        [fullKeysList removeObject:object];
        }
        hallwayRange++;
    }

    //place start and end markers
    [self cutOutOfRealMaze:[requirements startingPosition] :[requirements endingPosition] :true];
    [self placeCoins:[requirements numCoins]];
    return true;
}

-(NSInteger) translateSmallArrayIndexToLarge:(NSInteger) smallArrIndex
{
    int num1 = smallArrIndex;
    int row1, col1;
    int largeArrIndex;
    //get a x,y of the cells we are joining        
    row1 = num1 / cols;
    col1 = num1 - (row1 * cols);
    //translate that to the larger - x,y coords
    row1 = (row1 * kTrueScale) + 1;
    col1 = (col1 * kTrueScale) + 1;
    //translate that to the larger graph - single num coord
    largeArrIndex = row1 * (cols * kTrueScale) + col1;
    //cut out walls from actual maze
    //        NSLog(@"chosen nodes        : %i, %i", num1, num2);
    //        NSLog(@"nodes on real maze  : %i, %i", newNum1, newNum2);
    return largeArrIndex;
}

-(Pair *) translateLargeArrayIndexToXY:(NSInteger) num1
{
    int X, Y;
    Y = num1 / (cols*kTrueScale);
    X = num1 - (Y * (cols*kTrueScale));
    translationReturnPair.num1 = X;
    translationReturnPair.num2 = Y;
    return translationReturnPair;}

-(Pair *) translateSmallArrayIndexToXY:(NSInteger) num1
{
    int X, Y;
    Y = num1 / (cols);
    X = num1 - (Y * (cols));
    translationReturnPair.num1 = X;
    translationReturnPair.num2 = Y;
    return translationReturnPair;    
}

-(NSInteger) translateLargeXYToArrayIndex: (NSInteger) X :(NSInteger) Y
{
    return (Y * (cols*kTrueScale)) + X;
}

-(NSInteger) translateSmallXYToArrayIndex: (NSInteger) X :(NSInteger) Y
{
    return (Y * cols) + X;
}

@end
