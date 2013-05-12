//
//  CellLabel.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-05.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellLabel : UIView

//@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) NSString *fontName;

@property BOOL selected;

-(id) copy;

-(id)initWithFrame:(CGRect)frame
             image:(UIImage *)image
              text:(NSString *)text
         textColor:(UIColor *)textColor
          fontName:(NSString *)fontname;
@end
