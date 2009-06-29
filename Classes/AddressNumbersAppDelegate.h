//
//  AddressNumbersAppDelegate.h
//  AddressNumbers
//
//  Created by mootoh on 6/28/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

@class Database;
@class RootViewController;

@interface AddressNumbersAppDelegate : NSObject <UIApplicationDelegate>
{
   UIWindow *window;
   RootViewController *rootViewController;
   Database *db;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) Database *db;

@end