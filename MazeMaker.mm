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
#import "ObjectInfoConstants.h"

@interface MazeMaker()

-(BOOL) wallBetweenPoint1:(NSInteger)pt1 AndPoint2:(NSInteger)pt2 pointsInSmallMazeFormat:(BOOL)isItASmallMaze;

@end
@implementation MazeMaker
@synthesize smallMazeCols, smallMazeRows, largeMazeCols, largeMazeRows, mazeForScene;
@synthesize wallList;

-(id)init
{
    self = [super init];
    if (self) {
        smallMazeCols = 0;
        smallMazeRows = 0;
        largeMazeCols = 0;
        largeMazeRows = 0;
    }
    return self;
}

- (void) dealloc
{
//    NSLog(@"MazeMaker Dealloc");
    
    [wallList release];
    [fullBreakdownOptionsList release];
   
    [disjsets release];
    [fullKeysList release];
    
	[super dealloc];
}

-(id) initWithHeight: (NSInteger) windowHeight
               Width: (NSInteger) windowWidth
      WallDimensions: (Pair *) wallSpriteDimensions
        Requirements: (MazeRequirements*) reqs
                Maze: (NSMutableArray*) maze
            ForScene:(SceneTypes)scene
{
    if (self = [super init])
    {
//        NSLog(@"MazeMaker InitWithSizeAndRequirements");
        mazeForScene = scene;
        wallHeight = [wallSpriteDimensions num1];
        wallWidth = [wallSpriteDimensions num2];
        [self calculateMazeDimensionsWithHeight:windowHeight AndWidth:windowWidth];
        
        startingLocation = smallMazeSize-smallMazeCols;
        endingLocation = smallMazeCols-1;
        
        translationReturnPair = [[[Pair alloc] initWithRequirements:0 :0]retain];
        returnMazeDimensions = [[[Pair alloc] initWithRequirements:0 :0]retain];
        
        disjsets = [[Disjsets alloc] initWithSize:smallMazeRows :smallMazeCols];
        
        realMaze = maze;
        requirements = reqs;
        
        wallList = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < largeMazeSize; i++)
        {
            [realMaze insertObject:[NSNumber numberWithInt:tWall] atIndex:i];
            [wallList setObject:[[NSMutableSet alloc] init] forKey:[NSNumber numberWithInt:i]];

        }

        fullBreakdownOptionsList = [[NSMutableDictionary alloc] init];
        [self fillFullBreakdownOptionsList];
        
    }
    
    return self;
}

-(void)fillFullBreakdownOptionsList
{
    int currentNum=0;
    for (int i=0; currentNum < smallMazeSize; i++)
    {        
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
                                                 initWithRequirements:currentNum :currentNum+smallMazeCols] forKey:[NSNumber numberWithInt:i]];
        }
        else if (currentNum > 0 && currentNum < (smallMazeCols - 1)) {
            //case 1
            //            NSLog(@"case1");
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum+smallMazeCols] forKey:[NSNumber numberWithInt:i]];
        }
        else if (currentNum == smallMazeCols -1) {
            //case 2
            //            NSLog(@"case2");
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum+smallMazeCols] forKey:[NSNumber numberWithInt:i]];
        }
        else if (currentNum > 0 && currentNum < (smallMazeSize - smallMazeCols) && (currentNum % smallMazeCols) == 0) {
            //case 3
            //            NSLog(@"case3");
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum+smallMazeCols] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-smallMazeCols] forKey:[NSNumber numberWithInt:i]];                
        }
        else if (currentNum > (smallMazeCols - 1) && currentNum < (smallMazeSize - 1) && ((currentNum+1) % smallMazeCols) == 0) {
            //case 5
            //            NSLog(@"case5");
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum+smallMazeCols] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-smallMazeCols] forKey:[NSNumber numberWithInt:i]];                
        }
        else if (currentNum == (smallMazeSize - smallMazeCols)) {
            //case 6
            //            NSLog(@"case6");
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-smallMazeCols] forKey:[NSNumber numberWithInt:i]];
        }
        else if (currentNum > (smallMazeSize - smallMazeCols) && currentNum < (smallMazeSize-1)) {
            //case 7
            //            NSLog(@"case7");
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum+1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-smallMazeCols] forKey:[NSNumber numberWithInt:i]];                
        }
        else if (currentNum == (smallMazeSize - 1)) {
            //case 8
            //            NSLog(@"case8");
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-1] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-smallMazeCols] forKey:[NSNumber numberWithInt:i]];
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
                                                 initWithRequirements:currentNum :currentNum+smallMazeCols] forKey:[NSNumber numberWithInt:i]];
            i++;
            [fullBreakdownOptionsList setObject:[[Pair alloc] 
                                                 initWithRequirements:currentNum :currentNum-smallMazeCols] forKey:[NSNumber numberWithInt:i]];
        }
        currentNum++;
        
    }
}

-(void)calculateMazeDimensionsWithHeight:(int) windowHeight AndWidth: (int) windowWidth
{
    //for objectFactory returnObjectDimensions - num1 is height - num2 is width
    smallMazeCols = (windowWidth / wallWidth / kTrueScale)-1;
    smallMazeRows = (windowHeight / wallHeight / kTrueScale)-1;
    
    largeMazeRows = (smallMazeRows*kTrueScale)+1;
    largeMazeCols = (smallMazeCols*kTrueScale)+1;
    
    largeMazeSize = largeMazeRows*largeMazeCols;
    smallMazeSize = smallMazeRows*smallMazeCols;
}

-(BOOL) properWallRemoval: (NSInteger) wall1: (NSInteger) wall2: (NSInteger) hallwayLength
{
    /*
     goal - eliminate long hallways created in a maze
     pass in smallMaze numbers - they will be translated here
     
    */
    if ([requirements straightShot] == FALSE) {
        int t1, w1, w2, count, diff, allowedRange;
        w1 = wall1;
        w2 = wall2;
        t1=0;
        count=0;
        allowedRange = hallwayLength;
        
        diff = w1-w2;
        w1 = [self translateSmallArrayIndexToLarge:wall1];
        w2 = [self translateSmallArrayIndexToLarge:wall2];
        
        //w1 should always be larger - to make the for loops work
        if (diff < 0) {
            diff=diff*-1;
            t1 = w1;
            w1 = w2;
            w2 = t1;
        }
        /*
         when translating from small to large - there is a block inbetween the two points.
         so if you get the diff from the largeMaze numbers - it will not be the "closest" block
         thus - subtract the diff before, and change it if the blocks are on top / below eachother
         */
        if (diff != 1) {
            diff = largeMazeCols;
        }
        t1 = w1;
        /*checking the numbers greater than the larger point*/
            for (int i = 0; i < allowedRange; i++) {
                if ( [[[self wallList] objectForKey:[NSNumber numberWithInt:t1]] 
                      containsObject:[NSNumber numberWithInt:(t1+diff)]] ) {
                    count++;
                }
                t1 += diff;
            }
            if (count == allowedRange)
                return FALSE;
        
        count = 0;
        t1=w2;
        /*checking the numbers lower than the smaller point*/
            for (int i = 0; i < allowedRange; i++) {
                if ( [[[self wallList] objectForKey:[NSNumber numberWithInt:t1]] 
                      containsObject:[NSNumber numberWithInt:(t1-diff)]] ) {
                    count++;
                }
                t1 -= diff;
            }
            if (count == hallwayLength)
                return FALSE;        
    }
    
    return TRUE;
}

-(NSInteger) sameSet
{
    /*
    used with disjsets. if all of the array slots go back to the same set, then
    the maze has been created with a single track through the entire thing.
     
    disjsets relies on smallMaze array
    */
	int c=0;
	for(int i=0; i<smallMazeSize; i++)
	{
		if( [disjsets find:0] == [disjsets find:i] )
		{
			c++;	//track how many sets are in the same disjset
		}
	}
	return c;
}

-(void) placeItem:(GameObjectType) itemType 
    NumberOfTimes:(NSInteger) number
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
    halfwayX = largeMazeCols/2;
    halfwayY = largeMazeRows/2;

    counter = 4;
    
    for (int i = 0; i < number; i++) {
        randX = 0;
        randY = 0;
        rnum = 0;
        switch (counter) {
            case 3:
                randX = arc4random()%halfwayX;
                randY = arc4random()%halfwayY;
                
                break;
            case 2:
                randX = (arc4random()%(largeMazeCols-halfwayX))+halfwayX;
                randY = arc4random()%halfwayY;
                
                break;
            case 1:
                randX = arc4random()%halfwayX;
                randY = (arc4random()%(largeMazeRows-halfwayY))+halfwayY;                

                break;
            case 4:
                randX = (arc4random()%(largeMazeCols-halfwayX))+halfwayX;                
                randY = (arc4random()%(largeMazeRows-halfwayY))+halfwayY;                
                
                break;
                
            default:
                break;
        }
        rnum = [self translateLargeXYToArrayIndex:randX :randY];
        if ([[realMaze objectAtIndex:rnum] intValue] == tNone) {
            [realMaze replaceObjectAtIndex:rnum withObject:[NSNumber numberWithInt:itemType]];
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
    fullKeysList = [[NSMutableArray alloc] initWithArray:[fullBreakdownOptionsList allKeys]];
    int max = [fullKeysList count];
    int randNum = 0;
    
    for (int i=0; i < max; i++) {
        randNum = arc4random() % max; 
        [fullKeysList exchangeObjectAtIndex:i withObjectAtIndex:randNum];
    }
}

-(void) cutOutOfRealMaze: (NSInteger) x1: (NSInteger) x2: (BOOL) specialNodes {
    /*
        input - smallMaze array index
        output - marks the path from x1 to x2 on the "real maze" or largeMaze
        also adds to wallList - container of each point on the maze and which paths are open to movement from it.
    */
    int num1 = x1;
    int num2 = x2;
    int newNum1, newNum2;

    newNum1 = [self translateSmallArrayIndexToLarge:num1];
    newNum2 = [self translateSmallArrayIndexToLarge:num2];
    
    if (!specialNodes)
    {
        if (num1 == num2 - 1) {
            for (int i = newNum1; i <= newNum2; i++) {
                [realMaze replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tNone]];
                if (i != newNum2) {
                    [[[self wallList] objectForKey:[NSNumber numberWithInt:i]] addObject:[NSNumber numberWithInt:i+1]];
                    [[[self wallList] objectForKey:[NSNumber numberWithInt:i+1]] addObject:[NSNumber numberWithInt:i]];
                }
            }
        } else if (num1 == num2 + 1) {
            for (int i = newNum2; i <= newNum1; i++) {
                [realMaze replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tNone]];
                if (i != newNum1) {
                    [[[self wallList] objectForKey:[NSNumber numberWithInt:i]] addObject:[NSNumber numberWithInt:i+1]];
                    [[[self wallList] objectForKey:[NSNumber numberWithInt:i+1]] addObject:[NSNumber numberWithInt:i]];
                }
            }
        } else if (num1 == num2 + smallMazeCols) {
            for (int i = newNum2; i <= newNum1; i+= largeMazeCols) {
                [realMaze replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tNone]];
                if (i != newNum1) {
                    [[[self wallList] objectForKey:[NSNumber numberWithInt:i]] addObject:[NSNumber numberWithInt:i+largeMazeCols]];
                    [[[self wallList] objectForKey:[NSNumber numberWithInt:i+largeMazeCols
                                             ]] addObject:[NSNumber numberWithInt:i]];
                }
            }
        } else if (num1 == num2 - smallMazeCols) {
            for (int i = newNum1; i <= newNum2; i+= largeMazeCols) {
                [realMaze replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:tNone]];
                if (i != newNum2) {
                    [[[self wallList] objectForKey:[NSNumber numberWithInt:i]] addObject:[NSNumber numberWithInt:i+largeMazeCols]];
                    [[[self wallList] objectForKey:[NSNumber numberWithInt:i+largeMazeCols]] addObject:[NSNumber numberWithInt:i]];
                }
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
}

-(Pair *) createMaze
{
    NSInteger num1, num2;

    if (smallMazeRows == 0 || smallMazeCols == 0) {
        NSLog(@"can't have rows / cols be 0");
        return NULL;
    }
    
    int hallwayRange = 1;
    while ([self sameSet] != smallMazeSize) {
        [self shuffleIndicies];
        for (id object in fullKeysList) {
            if ([self sameSet] == smallMazeSize)
                break;
            num1 = [[fullBreakdownOptionsList objectForKey:object] num1];
            num2 = [[fullBreakdownOptionsList objectForKey:object] num2];

            if ([disjsets find:num1] == [disjsets find:num2]) 
                continue;
            if ([self properWallRemoval:num1:num2:hallwayRange] == FALSE ) {
                continue;
            }
            [disjsets unionSets:[disjsets find:num1] :[disjsets find:num2]];
            [self cutOutOfRealMaze:num1 :num2 :false];
        }
        hallwayRange++;
    }
   
/*
 creates circles in the maze by looking for points that have not been broken down yet.
 they still must follow the "properWallRemoval" so that a long hallway won't be created.
 */
    hallwayRange = 1;
    /*loop through the possible walls to break down until we have enough circles*/
    for (int i=0; i < [requirements circles];) {
        [self shuffleIndicies];
        for (id object in fullKeysList) {
            if (i == [requirements circles])
                break;
            num1 = [[fullBreakdownOptionsList objectForKey:object] num1];
            num2 = [[fullBreakdownOptionsList objectForKey:object] num2];

            if (![self properWallRemoval: num1: num2: hallwayRange])
                continue;
            
            /*
             if there is a wall between the two points - break that shit down!
             prevents us from breaking down a path that is already there
             */             
            if (![self wallBetweenPoint1:num1 AndPoint2:num2 pointsInSmallMazeFormat:TRUE])
                continue;
            
            [self cutOutOfRealMaze:num1 :num2 :false];
            i++;
        }
        hallwayRange++;
    }

    /*after we create the proper maze path - add extras in the empty spaces*/
    [self cutOutOfRealMaze:startingLocation :endingLocation :true];
    [self placeItem:tCoin NumberOfTimes:[requirements numCoins]];
    [self placeItem:tEnemy NumberOfTimes:[requirements numEnemies]];
    [self placeItem:tArea NumberOfTimes:[requirements numAreas]];
    
    returnMazeDimensions.num1 = largeMazeRows;
    returnMazeDimensions.num2 = largeMazeCols;
    return returnMazeDimensions;
}

-(BOOL) wallBetweenPoint1:(NSInteger)pt1 AndPoint2:(NSInteger)pt2 pointsInSmallMazeFormat:(BOOL)isItASmallMaze
{
    int tmp, p1, p2, diff;
    p1 = pt1;
    p2 = pt2;
    
    diff = p2 - p1;
    
    /*need to have p1 < p2*/
    if (diff < 0) {
        diff=diff*-1;
        tmp = p1;
        p1 = p2;
        p2 = tmp;
    }
    
    if (diff != 1) {
        diff = largeMazeCols;
    }
    
    /*if the points come in as 'smallMaze points' bring them up*/
    /*otherwise, keep the points in their large format*/
    if (isItASmallMaze) {
        p1 = [self translateSmallArrayIndexToLarge:p1];
        p2 = [self translateSmallArrayIndexToLarge:p2];
    }
    
    for (int i = p1; i < p2; i+=diff) {
        if ([[realMaze objectAtIndex:i]intValue] == tWall)
            return TRUE;
    }
    return FALSE;
}

-(NSInteger) translateSmallArrayIndexToLarge:(NSInteger) smallArrIndex
{
    int num1 = smallArrIndex;
    int row1, col1;
    int largeArrIndex;
    //get a x,y of the cells we are joining        
    row1 = num1 / smallMazeCols;
    col1 = num1 - (row1 * smallMazeCols);
    //translate that to the larger - x,y coords
    row1 = (row1 * kTrueScale) + 1;
    col1 = (col1 * kTrueScale) + 1;
    //translate that to the larger graph - single num coord
    largeArrIndex = row1 * largeMazeCols + col1;
    return largeArrIndex;
}

-(NSInteger) translateLargeArrayIndexToSmall:(NSInteger) largeArrIndex
{
    int num1 = largeArrIndex;
    int row1, col1;
    int smallArrIndex;

    row1 = [self translateLargeArrayIndexToXY:num1 ].num1;
    col1 = [self translateLargeArrayIndexToXY:num1 ].num2;

    row1 = (row1 / kTrueScale) - 1;
    col1 = (col1 / kTrueScale) - 1;

    smallArrIndex = row1 * (smallMazeCols) + col1;
    return smallArrIndex;
}

-(Pair *) translateLargeArrayIndexToXY:(NSInteger) num1
{
    int X, Y;
    Y = num1 / largeMazeCols;
    X = num1 - (Y * largeMazeCols);
    translationReturnPair.num1 = X;
    translationReturnPair.num2 = Y;
    return translationReturnPair;
}

-(Pair *) translateSmallArrayIndexToXY:(NSInteger) num1
{
    int X, Y;
    Y = num1 / (smallMazeCols);
    X = num1 - (Y * (smallMazeCols));
    translationReturnPair.num1 = X;
    translationReturnPair.num2 = Y;
    return translationReturnPair;    
}

-(NSInteger) translateLargeXYToArrayIndex: (NSInteger) X :(NSInteger) Y
{
    return (Y * largeMazeCols) + X;
}

-(NSInteger) translateSmallXYToArrayIndex: (NSInteger) X :(NSInteger) Y
{
    return (Y * smallMazeCols) + X;
}

-(NSInteger) returnLargeMazeStartingLocation
{
    return [self translateSmallArrayIndexToLarge:startingLocation];
}

-(NSInteger) returnLargeMazeEndingLocation
{
    return [self translateSmallArrayIndexToLarge:endingLocation];
}

-(NSInteger) returnEmptySlotInMaze
{
    NSInteger emptySlot;
    emptySlot = arc4random()%largeMazeSize;
    while ([[realMaze objectAtIndex:emptySlot] intValue] != tNone) {
        emptySlot = arc4random()%largeMazeSize;
    }

    return emptySlot;
}

-(NSInteger) returnContentsOfMazePosition:(NSInteger)position
{
    return [[realMaze objectAtIndex:position] intValue];
}

@end
