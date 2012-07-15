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
    [disjsets release];
	[super dealloc];
}

-(id) initWithSizeAndRequirements: (NSInteger) numRows: (NSInteger) numCols: (MazeRequirements*) reqs: (MazeContents*) maze
{
    if (self = [super init])
    {
        rows = numRows;
        cols = numCols;
        disjsets = [[Disjsets alloc] initWithSize:rows :cols];
        realMaze = maze;
        requirements = reqs;
        wallList = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < rows*kTrueScale*cols*kTrueScale; i++)
        {
            realMaze[i] = cWall;
            [wallList setObject:[[NSMutableSet alloc] init] forKey:[NSNumber numberWithInt:i]];
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

-(BOOL) properWallRemoval: (NSInteger) wall1: (NSInteger) wall2
{
    if ([requirements straightShot] == FALSE) {        
        int t1, count, diff;
        t1=0;
        count = 0;
        diff=0;
        for (int x = 0; x < 8; x++) {
            switch (x) {
                case 0:
                    diff = 1;
                    break;
                case 1:
                    diff = cols; 
                    break;
                case 2:
                    diff = -1;
                    break;
                case 3:
                    diff = -cols;
                    break;
                case 4:
                    diff = 1;
                    break;
                case 5:
                    diff = cols; 
                    break;
                case 6:
                    diff = -1;
                    break;
                case 7:
                    diff = -cols;
                    break;
                default:
                    break;
            }
            if (x < 4)
                t1 = wall1;
            else
                t1 = wall2;

            count = 0;
            if (t1+(diff*3) >= 0 && t1+(diff*3) < rows*cols) {
                for (int i = 0; i < 3; i++) {
                    if ( [[wallList objectForKey:[NSNumber numberWithInt:t1]] 
                         containsObject:[NSNumber numberWithInt:(t1+diff)]] ) 
                        count++;
                    t1 += diff;
                }
                if (count == 3)
                    return FALSE;
            }
        }
        
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
    int rnum;
    for (int i = 0; i < numCoins; i++) {
        rnum = arc4random() % (rows*kTrueScale*cols*kTrueScale);
        if (realMaze[rnum] == cNone) {
            realMaze[rnum] = cCoin;
        }
        else {
            i--;
            continue;
        }
    }
}

-(Boolean) createMaze
{
    if (rows == 0 || cols == 0) {
        NSLog(@"can't have rows / cols be 0");
        return false;
    }
/*
    cases:
    5x5 maze - showing the different cases you will need when joining a random side
    01112
    34445
    34445
    34445
    67778
*/    
    NSInteger num1, num2, randAdd;
    
    while( [self sameSet] != rows*cols )
    {
        num1 = 0;
        num2 = 0;
        randAdd = 0;
        num1 = arc4random() % (rows*cols);    //first selected random slot of maze
//        NSLog(@"number chosen first: %i", num1);
        if (num1 == 0) {
            //case 0
//            NSLog(@"case0");
            randAdd = arc4random() % 1;
            switch (randAdd) {
                case 0:
                    num2 = num1 + 1;
                    break;
                case 1:
                    num2 = num1 + cols;
                    break;
                default:
                    break;
            }
        }
        else if (num1 > 0 && num1 < (cols - 1)) {
            //case 1
//            NSLog(@"case1");
            randAdd = arc4random() % 2;
            switch (randAdd) {
                case 0:
                    num2 = num1 + 1;
                    break;
                case 1:
                    num2 = num1 - 1;
                    break;
                case 2:
                    num2 = num1 + cols;
                    break;
                default:
                    break;
            }
            
        }
        else if (num1 == cols -1) {
            //case 2
//            NSLog(@"case2");
            randAdd = arc4random() % 1;
            switch (randAdd) {
                case 0:
                    num2 = num1 - 1;
                    break;
                case 1:
                    num2 = num1 + cols;
                    break;
                default:
                    break;
            }
            
        }
        else if (num1 > 0 && num1 < ((rows * cols) - cols) && (num1 % cols) == 0) {
            //case 3
//            NSLog(@"case3");
            randAdd = arc4random() % 2;
            switch (randAdd) {
                case 0:
                    num2 = num1 + cols;
                    break;
                case 1:
                    num2 = num1 - cols;
                    break;
                case 2:
                    num2 = num1 + 1;
                    break;
                default:
                    break;
            }
        }
        else if (num1 > (cols - 1) && num1 < ((rows * cols) - 1) && ((num1+1) % cols) == 0) {
            //case 5
//            NSLog(@"case5");
            randAdd = arc4random() % 2;
            switch (randAdd) {
                case 0:
                    num2 = num1 - cols;
                    break;
                case 1:
                    num2 = num1 - 1;
                    break;
                case 2:
                    num2 = num1 + cols;
                    break;
                default:
                    break;
            }
        }
        else if (num1 == ((rows * cols) - cols)) {
            //case 6
//            NSLog(@"case6");
            randAdd = arc4random() % 1;
            switch (randAdd) {
                case 0:
                    num2 = num1 + 1;
                    break;
                case 1:
                    num2 = num1 - cols;
                    break;
                default:
                    break;
            }
        }
        else if (num1 > ((rows * cols) - cols) && num1 < ((rows * cols)-1)) {
            //case 7
//            NSLog(@"case7");
            randAdd = arc4random() % 2;
            switch (randAdd) {
                case 0:
                    num2 = num1 + 1;
                    break;
                case 1:
                    num2 = num1 - 1;
                    break;
                case 2:
                    num2 = num1 - cols;
                    break;
                default:
                    break;
            }
            
        }
        else if (num1 == ((rows * cols) - 1)) {
            //case 8
//            NSLog(@"case8");
            randAdd = arc4random() % 1;
            switch (randAdd) {
                case 0:
                    num2 = num1 - cols;
                    break;
                case 1:
                    num2 = num1 - 1;
                    break;
                default:
                    break;
            }
        }
        else {
            //case 4
//            NSLog(@"case4");
            randAdd = arc4random() % 3;
            switch (randAdd) {
                case 0:
                    num2 = num1 + 1;
                    break;
                case 1:
                    num2 = num1 - 1;
                    break;
                case 2:
                    num2 = num1 - cols;
                    break;
                case 3:
                    num2 = num1 + cols;
                    break;
                default:
                    break;
            }
        }
        if ([disjsets find:num1] == [disjsets find:num2]) 
            continue;
        if ([self properWallRemoval:num1:num2] == FALSE ) {
            NSLog(@"skipping wall breakdown for because not proper wall removal");
            continue;
        }
        [disjsets unionSets:[disjsets find:num1] :[disjsets find:num2]];
        [[wallList objectForKey:[NSNumber numberWithInt:num1]] addObject:[NSNumber numberWithInt:num2]];
        [[wallList objectForKey:[NSNumber numberWithInt:num2]] addObject:[NSNumber numberWithInt:num1]];

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
        newNum1 = row1 * kTrueMazeCols + col1;
        newNum2 = row2 * kTrueMazeCols + col2;
//cut out walls from actual maze
//        NSLog(@"chosen nodes        : %i, %i", num1, num2);
//        NSLog(@"nodes on real maze  : %i, %i", newNum1, newNum2);

        if (num1 == num2 - 1) {
            for (int i = newNum1; i <= newNum2; i++) {
//                NSLog(@"removing  : %i", i);
                realMaze[i] = cNone;
            }
        } else if (num1 == num2 + 1) {
            for (int i = newNum2; i <= newNum1; i++) {
//                NSLog(@"removing  : %i", i);
                realMaze[i] = cNone;
            }
        } else if (num1 == num2 + cols) {
            for (int i = newNum2; i <= newNum1; i+= kTrueMazeCols) {
//                NSLog(@"removing  : %i", i);
                realMaze[i] = cNone;
            }
        } else if (num1 == num2 - cols) {
            for (int i = newNum1; i <= newNum2; i+= kTrueMazeCols) {
//                NSLog(@"removing  : %i", i);
                realMaze[i] = cNone;
            }
        } else {
            NSLog(@"when breaking down walls in true maze... found an impossible situation");
        }
         
//        [disjsets print];

    }
    [self placeCoins:[requirements numCoins]];

    return true;
}

@end