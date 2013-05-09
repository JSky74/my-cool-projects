//
//  ColorChooserKeyboardCell.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-06.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "ColorChooserKeyboardCell.h"
#import "AccessoryKeyboardView.h" // to define NUMBER_OF_COLORS



@implementation ColorChooserKeyboardCell

-(id) initWithFrame:(CGRect)frame
          cellColor:(UIColor *)color
             height:(CGFloat)cellHeight
              index:(int)indexOfCell;
{
    self = [super initWithFrame:frame];
    if (self) {
        _cellColor = color;
        _cellHeight = cellHeight;
        _indexOfCell = indexOfCell;
    }
    return self;
}

-(void) enlarge
{
    [self setFrame:CGRectMake(0, 0, self.frame.size.width+50, self.cellHeight+50)];
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    UIBezierPath *cell = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.frame.size.width, self.cellHeight)];
    
    [self.cellColor setFill];
    [cell fill];
    
    [[UIColor whiteColor] setStroke];
    [cell stroke];

}


@end
