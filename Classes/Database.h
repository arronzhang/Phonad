//
//  Database.h
//  AddressNumbers
//
//  Created by mootoh on 6/28/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Database : NSObject
{
   NSMutableDictionary *dictionary;
}

// collect all phone numbers and create index
- (void) prepare;

@end