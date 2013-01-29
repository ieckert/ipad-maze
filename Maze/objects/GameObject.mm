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
        type = G_OBJET;
        body = nil;
        [self deactivate];
        worldObject = [WorldObject createSingleton];
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"wall_4.png"]];
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

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {
    CCLOG(@"updateStateWithDeltaTime method should be overridden");
}

-(CGRect)adjustedBoundingBox {
    return [self boundingBox];
}

-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                andClassName:(NSString*)className {
    
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName =
    [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    
    // 1: Get the Path to the plist file
    NSString *rootPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:className ofType:@"plist"];
    }
    
    // 2: Read in the plist file
    NSDictionary *plistDictionary =
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    // 4: Get just the mini-dictionary for this animation
    NSDictionary *animationSettings =
    [plistDictionary objectForKey:animationName];
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName:%@",animationName);
        return nil;
    }
    
    // 5: Get the delay value for the animation
    float animationDelay =
    [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:animationDelay];
    
    // 6: Add the frames to the animation
    NSString *animationFramePrefix =
    [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames =
    [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers =
    [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName =
        [NSString stringWithFormat:@"%@%@.png",
         animationFramePrefix,frameNumber];
        [animationToReturn addFrame:
         [[CCSpriteFrameCache sharedSpriteFrameCache]
          spriteFrameByName:frameName]];
    }
    
    return animationToReturn;
}

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position =
    b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    body = [worldObject getWorld]->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    b2FixtureDef fixtureDef;
    
    b2PolygonShape shape;
    shape.SetAsBox(self.contentSize.width/2/PTM_RATIO, self.contentSize.height/2/PTM_RATIO);
    
    fixtureDef.shape = &shape;
    
    fixtureDef.density = 0.0;
    
    body->CreateFixture(&fixtureDef);
}



/*Location*/


/*Visual*/
-(void)activate
{
    active = true;
    [self show];
    if (!body) {
        [self createBodyAtLocation:self.position];
    }
    
}

-(void)deactivate
{
    active = false;
    [self hide];
    if (body) {
        [worldObject getWorld]->DestroyBody(body);
        body = nil;
    }
}

-(void)changeSkin:(NSString*)image
{
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:image]];
    [self deactivate];
    [self activate];
}

-(void)show
{
    [self setVisible:TRUE];
}

-(void)hide
{
    [self setVisible:FALSE];
}

/*Data*/
-(void)removeFromPool
{
    
}

@end
