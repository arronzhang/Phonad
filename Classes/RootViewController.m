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
//   [search_bar becomeFirstResponder];
    
    NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
	// 识别控件
	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc]initWithOrigin:H_CONTROL_ORIGIN theInitParam:initParam];
	[_iFlyRecognizeControl setSampleRate:16000];
    [initParam release];
	_iFlyRecognizeControl.delegate = self;
	[self.view addSubview:_iFlyRecognizeControl];
    
    [_iFlyRecognizeControl setEngine:@"sms" theEngineParam:nil theGrammarID:nil];

    [self searchText:@""];
    NSString *str = @"";

    if ([addresses count]) {
        for (NSInteger i = 0; i < [addresses count]; i++) {
            str = [NSString stringWithFormat:@"%@,%@", str, [[addresses objectAtIndex:i] objectForKey:@"name"]];
        }
    }
    NSLog(@"address %@", str);
}


- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   [self.navigationController setNavigationBarHidden:YES animated:YES];
//   if (addresses.count == 0)
//      table_view.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (IBAction)startSay:(id)sender{
//    NSLog(@"say...");
    [search_bar resignFirstResponder];
    if([_iFlyRecognizeControl start])
	{
	}
}

- (void)searchText: (NSString *)text{
    search_bar.text = text;
    [self searchBar:search_bar textDidChange:text];
}

#pragma mark 
#pragma mark 接口回调

//	识别结束回调
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
	NSLog(@"识别结束回调finish.....");
	NSLog(@"getUpflow:%d,getDownflow:%d",[iFlyRecognizeControl getUpflow],[iFlyRecognizeControl getDownflow]);
	
}

- (void)onUpdateTextView:(NSString *)sentence
{
	
    [self searchText:sentence];
	NSLog(@"str %@", sentence);
}

- (void)onRecognizeResult:(NSArray *)array
{
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:
	 [[array objectAtIndex:0] objectForKey:@"NAME"] waitUntilDone:YES];
}

- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
    NSLog(@"onResult %@", resultArray);
	[self onRecognizeResult:resultArray];	
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return addresses.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    
   NSDictionary *person = [addresses objectAtIndex:indexPath.row];
   NSString *name = [person objectForKey:@"name"];
   cell.textLabel.text = name;
   cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
   cell.detailTextLabel.text = [person objectForKey:@"phone"];

   return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSDictionary *person = [addresses objectAtIndex:indexPath.row];
   NSString *name = [person objectForKey:@"name"];
   
   ABAddressBookRef ab = ABAddressBookCreate();
   ABRecordRef person_rec = ABAddressBookGetPersonWithRecordID(ab, [[person objectForKey:@"id"] intValue]);

   ABPersonViewController *abpvc = [[ABPersonViewController alloc] initWithNibName:nil bundle:nil];
   abpvc.title = name;
   abpvc.displayedPerson = person_rec;

   [self.navigationController pushViewController:abpvc animated:YES];
   [abpvc release];
   [self.table_view deselectRowAtIndexPath:indexPath animated:NO];
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

//   table_view.hidden = (addresses.count == 0);
   [self.table_view reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

@end