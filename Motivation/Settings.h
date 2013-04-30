//
//  Settings.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-13.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

+ (NSString*)retrieveFromUserDefaults:(NSString*)key;
+ (void)saveToUserDefaults:(NSString*)key value:(NSString*)valueString;
@end
