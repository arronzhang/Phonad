//
//  Database.m
//  AddressNumbers
//
//  Created by mootoh on 6/28/09.
//  Copyright 2009 deadbeaf.org. All rights reserved.
//

#import "Database.h"
#import <AddressBook/AddressBook.h>

@interface Database (Private)
- (NSString *) normalize:(NSString *)src;
@end

@implementation Database (Private)

- (NSString *) normalize:(NSString *)src
{
   NSString *ret = [src stringByReplacingOccurrencesOfString:@" " withString:@""];
   ret = [ret stringByReplacingOccurrencesOfString:@"(" withString:@""];
   ret = [ret stringByReplacingOccurrencesOfString:@")" withString:@""];
   ret = [ret stringByReplacingOccurrencesOfString:@"-" withString:@""];
   return ret;
}

@end

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
      NSString *first_name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
      NSString *last_name  = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
      NSString *name = last_name ? [NSString stringWithFormat:@"%@", last_name] : @"";
      if (first_name)
         name = [name stringByAppendingString:first_name];

      const ABMultiValueRef *abmvr = ABRecordCopyValue(person, kABPersonPhoneProperty);

      NSArray *phone_numbers = (NSArray *)ABMultiValueCopyArrayOfAllValues(abmvr);
      for (NSString *phone_number in phone_numbers) {
         NSArray *keys = [NSArray arrayWithObjects:@"id", @"name", @"phone", nil];
         NSArray *vals = [NSArray arrayWithObjects:[NSNumber numberWithInt:rec_id], name, phone_number, nil];
         NSDictionary *person_dict = [NSDictionary dictionaryWithObjects:vals forKeys:keys];
         
         phone_number = [self normalize:phone_number];
         [dictionary setObject:person_dict forKey:phone_number];
      }
   }
}

// FIXME: too slow search
- (NSArray *)query:(NSString *)number_prefix
{
   NSMutableArray *result = [NSMutableArray array];
    for (NSString *number in dictionary){
        NSString *name = [[dictionary objectForKey:number] objectForKey:@"name"];
        
       if (!number_prefix.length || [number rangeOfString:number_prefix].location != NSNotFound || [name rangeOfString:number_prefix].location != NSNotFound) {
         [result addObject:[dictionary objectForKey:number]];
       }
    }
   return result;
}


@end