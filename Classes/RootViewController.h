//
//  RootViewController.h
//  AddressNumbers
//
//  Created by mootoh on 6/28/09.
//  Copyright deadbeaf.org 2009. All rights reserved.
//

// 图片名称
//#define PNG_BUTTON_NORMAL	@"commonnormal.png"
//#define PNG_BUTTON_PRESSED	@"commondown.png"
#define PNG_CONTENT_BACK	@"editbox.png"

//#define H_CONTROL_FRAME CGRectMake(20, 70, 282, 210)
#define H_CONTROL_ORIGIN CGPointMake(20, 70)

//此appid为您所申请,请勿随意修改
#define APPID @"4ef1e1cd"
#define ENGINE_URL @"http://dev.voicecloud.cn:1028/index.htm"

#define KEYWORD_ID @"\\\\192.168.72.37\\usr_gr/masr_007db_041508-03-25_11-59-48-271.abnf"

#import "iFlyISR/IFlyRecognizeControl.h"



@class Database;

@interface RootViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, IFlyRecognizeControlDelegate>
{
   NSArray *addresses;
   IBOutlet UITableView *table_view;
   IBOutlet UISearchBar *search_bar;
   Database *db;
    IFlyRecognizeControl		*_iFlyRecognizeControl;
    NSString					*_keywordID;
    BOOL    isUpload;
}

@property (nonatomic, retain) UITableView *table_view;
@property (nonatomic, retain) Database *db;
@property (nonatomic, retain) NSArray *addresses;

- (void)searchText: (NSString *)text;

- (IBAction)startSay:(id)sender;

- (void)onRecognizeResult:(NSArray *)array;

@end