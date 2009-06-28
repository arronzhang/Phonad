//
//  AddressNumbersAppDelegate.h
//  AddressNumbers
//
//  Created by mootoh on 6/28/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

@class Database;

@interface AddressNumbersAppDelegate : NSObject <UIApplicationDelegate>
{
   UIWindow *window;
   UINavigationController *navigationController;
   Database *db;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) Database *db;

@end