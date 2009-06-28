//
//  Database.m
//  AddressNumbers
//
//  Created by mootoh on 6/28/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "Database.h"
#import <AddressBook/AddressBook.h>
//#import <AddressBookUI/AddressBookUI.h>

@implementation Database

- (id) init
{
   if (self = [super init]) {
      dictionary = [[NSMutableDictionary dictionary] retain];
   }
   return self;
}

- (void) dealloc
{
   [dictionary release];
   [super dealloc];
}

- (void) prepare
{
   ABAddressBookRef ab = ABAddressBookCreate();
   NSArray *all_people = (NSArray *)ABAddressBookCopyArrayOfAllPeople(ab);

   size_t N = all_people.count;
   for (size_t i=0; i<N; i++) {
      ABRecordRef person = [all_people objectAtIndex:i];
      ABRecordID rec_id = ABRecordGetRecordID(person);
      //NSString* name = (NSString *)ABRecordCopyValue(person_one, kABPersonFirstNameProperty);
   
      const ABMultiValueRef *abmvr = ABRecordCopyValue(person, kABPersonPhoneProperty);
      NSArray *phone_numbers = (NSArray *)ABMultiValueCopyArrayOfAllValues(abmvr);
      for (NSString *phone_number in phone_numbers) {
         [dictionary setObject:[NSNumber numberWithInt:rec_id] forKey:phone_number];
         NSLog(@"phone number = %@", phone_number);
      }
   }
}

@end