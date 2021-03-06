//
//  RootViewController.m
//  Maze
//
//  Created by ian on 1/21/13.
//  Copyright 2013 Ian Eckert. See LICENSE for details.
//

#import "cocos2d.h"
#import "RootViewController.h"
#import "GameConfig.h"

@implementation RootViewController

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // There are 2 ways to support auto-rotation:
    //  - The OpenGL / cocos2d way
    //     - Faster, but doesn't rotate the UIKit objects
    //  - The ViewController way
    //    - A bit slower, but the UiKit objects are placed in the right place
    
#if GAME_AUTOROTATION==kGameAutorotationNone
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
    
	return interfaceOrientation == UIInterfaceOrientationPortrait;
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	// EAGLView will be rotated by cocos2d
    //
	// Sample: Autorotate only in landscape mode
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight)
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return interfaceOrientation == UIInterfaceOrientationPortrait;
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	// Should not happen
    assert(false);
	return false;
}

// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;
	
	if ((toInterfaceOrientation == UIInterfaceOrientationPortrait) ||
        (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
		rect = screenRect;
	
	else if((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) ||
            (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
		rect.size = CGSizeMake(screenRect.size.height, screenRect.size.width);
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
    
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    // TODO: Remove if unnecessary, currently deprecated
    [super viewDidUnload];
}

- (void)dealloc
{
    [super dealloc];
}

@end