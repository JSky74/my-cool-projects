//
//  Note.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-13.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * archived;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * text;

@end
