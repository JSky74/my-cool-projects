//
//  CellLabel.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-05.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellLabel : UIView

@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *fontName;

@property BOOL selected;

@end
