//
//  Note+Create.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-30.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "Note.h"

@interface Note (Create)

+ (Note *) noteWithContent:(NSString *)content color:(NSString *)color archived:(NSNumber *) isArchived
    inManagedObjectContext:(NSManagedObjectContext *) context;




@end
