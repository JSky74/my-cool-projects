//
//  Note+Create.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-30.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "Note+Create.h"

@implementation Note (Create)

+ (Note *) noteWithContent:(NSString *)content color:(NSString *)color archived:(NSNumber *)isArchived
    inManagedObjectContext:(NSManagedObjectContext *) context

{
    Note *note = nil;
    note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
   
    note.text = content;
    note.date = [NSDate date];
    note.color = color;
    note.archived = isArchived;
   
    return  note;

}

@end
