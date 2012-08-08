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

@implementation MazeMaker
static MazeMaker *singleton = nil;
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

-(id) initWithSizeAndRequirements: (NSInteger) numRows: (NSInteger) numCols: (MazeRequirements*) reqs: (GameObjectType*) maze
{
    if (self = [super init])
    {
        NSLog(@"MazeMaker InitWithSizeAndRequirements");

        rows = numRows;
        cols = numCols;
        disjsets = [[Disjsets alloc] initWithSize:rows :cols];
        realMaze = maze;
        requirements = reqs;
        
        wallList = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < rows*kTrueScale*cols*kTrueScale; i++)
        {
            realMaze[i] = tWall;
            [wallList setObject:[[NSMutableSet alloc] init] forKey:[NSNumber numberWithInt:i]];
        }
        
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

+ (MazeMaker *) createSingleton
{
    @synchronized(singleton) {
        if ( !singleton || singleton==nil ) {
            singleton = [[MazeMaker alloc] init];
        }
    }
    return singleton;
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
            case 1:
                randX = arc4random()%halfwayX;
                randY = arc4random()%halfwayY;
                
                break;
            case 2:
                randX = (arc4random()%((cols*kTrueScale)-halfwayX))+halfwayX;
                randY = arc4random()%halfwayY;
                
                break;
            case 3:
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

        rnum = (randY * (cols*kTrueScale)) + randX;
        if (realMaze[rnum] == tNone) {
//            NSLog(@"counter: %i rnum: %i randX: %i randY: %i rows: %i cols: %i", counter, rnum, randX, randY, rows, cols);
            realMaze[rnum] = tCoin;
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

-(void) cutOutOfRealMaze: (NSInteger) x1: (NSInteger) x2 {
    int num1, num2;
    num1 = x1;
    num2 = x2;
    int row1, row2, col1, col2;
    int newNum1, newNum2;
    //get a x,y of the cells we are joining        
    row1 = num1 / cols;
    col1 = num1 - (row1 * cols);
    row2 = num2 / cols;
    col2 = num2 - (row2 * cols);
    //translate that to the larger - x,y coords
    row1 = (row1 * kTrueScale) + 1;
    col1 = (col1 * kTrueScale) + 1;
    row2 = (row2 * kTrueScale) + 1;
    col2 = (col2 * kTrueScale) + 1;
    //translate that to the larger graph - single num coord
    newNum1 = row1 * (cols * kTrueScale) + col1;
    newNum2 = row2 * (cols * kTrueScale) + col2;
    //cut out walls from actual maze
    //        NSLog(@"chosen nodes        : %i, %i", num1, num2);
    //        NSLog(@"nodes on real maze  : %i, %i", newNum1, newNum2);
    
    if (num1 == num2 - 1) {
        for (int i = newNum1; i <= newNum2; i++) {
            //                NSLog(@"removing  : %i", i);
            realMaze[i] = tNone;
        }
    } else if (num1 == num2 + 1) {
        for (int i = newNum2; i <= newNum1; i++) {
            //                NSLog(@"removing  : %i", i);
            realMaze[i] = tNone;
        }
    } else if (num1 == num2 + cols) {
        for (int i = newNum2; i <= newNum1; i+= (cols * kTrueScale)) {
            //                NSLog(@"removing  : %i", i);
            realMaze[i] = tNone;
        }
    } else if (num1 == num2 - cols) {
        for (int i = newNum1; i <= newNum2; i+= (cols * kTrueScale)) {
            //                NSLog(@"removing  : %i", i);
            realMaze[i] = tNone;
        }
    } else {
        NSLog(@"when breaking down walls in true maze... found an impossible situation");
    }

}

-(Boolean) createMaze
{
    NSInteger num1, num2;

    if (rows == 0 || cols == 0) {
        NSLog(@"can't have rows / cols be 0");
        return false;
    }
    
    int hallwayRange = 2;
    while ([self sameSet] != rows*cols) {
        [self shuffleIndicies];
        NSLog(@"allowed hallway range: %i", hallwayRange);
        for (id object in fullKeysList) {
            if ([self sameSet] == rows*cols)
                break;
            num1 = [[fullBreakdownOptionsList objectForKey:object] chosenBlock];
            num2 = [[fullBreakdownOptionsList objectForKey:object] breakdownBlock];
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
            
            [self cutOutOfRealMaze:num1 :num2];
    //        [fullKeysList removeObject:object];
        }
        hallwayRange++;
    }
   
//creates circles
    hallwayRange = 2;
    NSLog(@"numCircles:%i", [requirements circles]);
    for (int i=0; i < [requirements circles];) {
        [self shuffleIndicies];
        NSLog(@"allowed hallway range: %i", hallwayRange);
        NSLog(@"size of keys list: %i", [fullKeysList count]);
        for (id object in fullKeysList) {
            if (i == [requirements circles])
                break;
            num1 = [[fullBreakdownOptionsList objectForKey:object] chosenBlock];
            num2 = [[fullBreakdownOptionsList objectForKey:object] breakdownBlock];

            if ([self properWallRemoval:num1:num2:hallwayRange] == FALSE ) {
//                NSLog(@"skipping wall breakdown for because not proper wall removal");
                continue;
            }
            if ( [[wallList objectForKey:[NSNumber numberWithInt:num1]] containsObject:[NSNumber numberWithInt:num2] ] ) {
                continue;
            }
            
            [[wallList objectForKey:[NSNumber numberWithInt:num1]] addObject:[NSNumber numberWithInt:num2]];
            [[wallList objectForKey:[NSNumber numberWithInt:num2]] addObject:[NSNumber numberWithInt:num1]];
            NSLog(@"in circles: chose to breakdown %i, %i",num1,num2);

            [self cutOutOfRealMaze:num1 :num2];
            i++;
            //        [fullKeysList removeObject:object];
        }
        hallwayRange++;
    }
    [disjsets print];

    [self placeCoins:[requirements numCoins]];
    return true;
}

@end
