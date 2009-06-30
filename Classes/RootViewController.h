//
//  RootViewController.h
//  AddressNumbers
//
//  Created by mootoh on 6/28/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

@class Database;

@interface RootViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
   NSArray *addresses;
   IBOutlet UITableView *table_view;
   Database *db;
}

@property (nonatomic, retain) UITableView *table_view;
@property (nonatomic, retain) Database *db;
@property (nonatomic, retain) NSArray *addresses;

@end