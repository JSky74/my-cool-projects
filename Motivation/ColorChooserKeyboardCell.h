//
//  ColorChooserKeyboardCell.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-06.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorChooserKeyboardCell : UIView

-(id) initWithFrame:(CGRect)frame
          cellColor:(UIColor *)color
             height:(CGFloat)cellHeight
              index:(int)indexOfCell;

-(void) enlarge;

@property (nonatomic, strong) UIColor *cellColor;
@property                     CGFloat cellHeight;
@property int indexOfCell;
@end
