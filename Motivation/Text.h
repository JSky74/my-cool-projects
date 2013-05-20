//
//  Text.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-19.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Text : NSObject

+ (NSAttributedString *) attributedText:(NSString *) noteText withSize:(CGFloat)size;

@end
