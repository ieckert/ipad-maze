//
//  AppDelegate.h
//  Maze
//
//  Created by ian on 6/24/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <CoreData/CoreData.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}
/*
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
*/
 @property (nonatomic, retain) UIWindow *window;

/*
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
*/
@end
