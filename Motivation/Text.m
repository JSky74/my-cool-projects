//
//  Text.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-19.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "Text.h"


@implementation Text

+ (NSAttributedString *) attributedText:(NSString *) noteText withSize:(CGFloat)size
{
    int boldWords = 4;
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[UIFont fontWithName:@"Helvetica-Bold" size:size] forKey:NSFontAttributeName];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:noteText];
    NSMutableAttributedString *mutableAttributed = [[NSMutableAttributedString alloc] initWithString:noteText];
    
    [mutableAttributed addAttributes:attributes range:[self wordsToMakeBold:boldWords withString:noteText]];
    
    [attributes setObject:[UIFont fontWithName:@"Helvetica" size:size] forKey:NSFontAttributeName];
    
    [mutableAttributed addAttributes:attributes range:NSMakeRange([self wordsToMakeBold:boldWords withString:noteText].length, [noteText length]-[self wordsToMakeBold:boldWords withString:noteText].length)];
    
    
    attributedString = [mutableAttributed copy];
    return attributedString;
    
}

+ (NSRange) wordsToMakeBold:(int)amount withString:(NSString *) string
{
    NSArray *countWords = [[NSArray alloc] init];
    countWords = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSMutableString *rangeString = [[NSMutableString alloc] init];
    if (amount > [countWords count]) {
        amount = [countWords count];
    }
    
    for (int i=0; i<amount; i++) {
        [rangeString appendString:countWords[i]];
        [rangeString appendString:@" "];
    }
    [rangeString deleteCharactersInRange:NSMakeRange([rangeString length]-1, 1)];
    return NSMakeRange(0,[rangeString length]);
}
@end

