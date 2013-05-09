//
//  Colors.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colors : NSObject

#define LIGHT_YELLOW    @"lightYellow"
#define LIME_GREEN      @"limeGreen"
#define HEAVENLY_BLUE   @"heavenlyBlue"
#define CARMIN_RED      @"carminRed"
#define WINE_RED        @"wineRed"
#define SANDY_YELLOW    @"sandyYellow"


@property (strong, nonatomic) NSDictionary *noteImages;
@property (strong, nonatomic) NSDictionary *noteColors;
@property (strong, nonatomic) NSArray *colorsArray;

@end
