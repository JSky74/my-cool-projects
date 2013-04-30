//
//  Colors.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "Colors.h"

@interface Colors ()
@end


@implementation Colors

-(id) init
{
    self = [super init];
    if (self) {
        _noteImages = [[NSDictionary alloc] initWithObjectsAndKeys:
                   [UIImage  imageNamed:@"LightYellow.png"], @"lightYellow",
                   [UIImage  imageNamed:@"LimeGreen.png"],@"limeGreen",
                   [UIImage  imageNamed:@"HeavenlyBlue.png"], @"heavenlyBlue",
                   [UIImage imageNamed:@"CarminRed.png"],@"carminRed",
                   [UIImage imageNamed:@"WineRed.png"], @"wineRed",
                   [UIImage imageNamed:@"SandyYellow.png"],@"sandyYellow",
                    nil];
        
        
        _noteColors = [[NSDictionary alloc] initWithObjectsAndKeys:
                   [UIColor colorWithRed:220.0/255.0 green:215.0/255.0 blue:144.0/255.0 alpha:1.0], @"lightYellow",
                   [UIColor colorWithRed:169.0/255.0 green:216.0/255.0 blue:139.0/255.0 alpha:1.0], @"limeGreen",
                   [UIColor colorWithRed:158.0/255.0 green:197.0/255.0 blue:231.0/255.0 alpha:1.0], @"heavenlyBlue",
                   [UIColor colorWithRed:208.0/255.0 green:151.0/255.0 blue:225.0/255.0 alpha:1.0], @"carminRed",
                   [UIColor colorWithRed:244.0/255.0 green:167.0/255.0 blue:153.0/255.0 alpha:1.0], @"wineRed",
                   [UIColor colorWithRed:228.0/255.0 green:200.0/255.0 blue:138.0/255.0 alpha:1.0], @"sandyYellow",
                    nil];
    }
   return self;
}
@end
