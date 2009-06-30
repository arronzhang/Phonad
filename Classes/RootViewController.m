//
//  RootViewController.m
//  AddressNumbers
//
//  Created by mootoh on 6/28/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

#import "RootViewController.h"
#import "Database.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation RootViewController

@synthesize table_view, db, addresses;

- (void)viewDidLoad
{
   [super viewDidLoad];
   self.title = @"Search";
}


- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   self.navigationController.navigationBarHidden = YES;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
   self.navigationController.navigationBarHidden = NO;
}
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addresses.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
   NSDictionary *person = [addresses objectAtIndex:indexPath.row];
   NSString *first_name = [person objectForKey:@"first"];
   NSString *last_name = [person objectForKey:@"last"];
   cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", last_name, first_name];
   cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
   cell.detailTextLabel.text = [person objectForKey:@"phone"];

   return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSDictionary *person = [addresses objectAtIndex:indexPath.row];
   NSString *first_name = [person objectForKey:@"first"];
   NSString *last_name = [person objectForKey:@"last"];
   
   ABAddressBookRef ab = ABAddressBookCreate();
   ABRecordRef person_rec = ABAddressBookGetPersonWithRecordID(ab, [[person objectForKey:@"id"] intValue]);

   ABPersonViewController *abpvc = [[ABPersonViewController alloc] initWithNibName:nil bundle:nil];
   abpvc.title = [NSString stringWithFormat:@"%@ %@", last_name, first_name];
   abpvc.displayedPerson = person_rec;

   [self.navigationController pushViewController:abpvc animated:YES];
   [abpvc release];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc
{
   if (db) [db release];
   [addresses release];
   [super dealloc];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   NSArray *result = [db query:searchText];
   self.addresses = result;
   [self.table_view reloadData];
}

@end