//
//  CellLabel.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-05.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "CellLabel.h"
#define CORNER_RADIUS 1.0

@implementation CellLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setUp];
    return self;
}

-(void) setUp {}

-(void) awakeFromNib
{
    [self setUp];
}

#define OFFSET 10.0
#define FONT_SIZE 13.0

- (void)drawRect:(CGRect)rect
{
    [self.image drawInRect:self.bounds];
    [self.textColor set];
    
    CGRect newRect = CGRectMake(self.bounds.origin.x+OFFSET, self.bounds.origin.y+OFFSET, self.bounds.size.width-3*OFFSET, self.bounds.size.height-3*OFFSET);
                            
    [self.text drawInRect:newRect withFont:[UIFont fontWithName:self.fontName size:FONT_SIZE] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    
    if (self.selected) {
        
        UIBezierPath *selected = [UIBezierPath bezierPathWithRect:CGRectMake(self.bounds.origin.x+1, self.bounds.origin.y+1, self.bounds.size.width-8, self.bounds.size.height-7)];
        [[UIColor whiteColor] setStroke];
        [selected setLineWidth:2.0];
        [selected stroke];
    }
}

@end
