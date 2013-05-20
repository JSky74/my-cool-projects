//
//  CellLabel.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-05.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "CellLabel.h"
#import "Text.h"
#define CORNER_RADIUS 1.0

@implementation CellLabel

-(id)copy
{

    CellLabel *newCell = [[CellLabel alloc] initWithFrame:self.frame image:self.image text:self.text textColor:self.textColor fontName:self.fontName];
    
    [newCell setOpaque:NO];
    return  newCell;
}

-(id)initWithFrame:(CGRect)frame
             image:(UIImage *)image
              text:(NSString *)text
         textColor:(UIColor *)textColor
          fontName:(NSString *)fontname
{
    self = [self initWithFrame:frame];
    if (self) {
    _image = image;
    _text = text;
    _textColor = textColor;
    _fontName = fontname;
    }
    return self;
}

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

#define OFFSET 7.0
#define FONT_SIZE 13.0

- (void)drawRect:(CGRect)rect
{
    [self setOpaque:NO];
    [self.image drawInRect:self.bounds];
    [self.textColor set];
    
    CGRect newRect = CGRectMake(self.bounds.origin.x+[self offset], self.bounds.origin.y+[self offset], self.bounds.size.width-3*[self offset], self.bounds.size.height-3*[self offset]);
    // try to create labels and then add them to this wiew as a subview withouth using drawRect
    [[Text attributedText:self.text withSize:13.0] drawWithRect:newRect options:(NSLineBreakByTruncatingTail | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine) context:nil];
    
//     [self.text drawInRect:newRect withFont:[UIFont fontWithName:self.fontName size:[self fontSize]] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    
    
    if (self.selected) {
        
        UIBezierPath *selected = [UIBezierPath bezierPathWithRect:CGRectMake(self.bounds.origin.x+1, self.bounds.origin.y+1, self.bounds.size.width-8, self.bounds.size.height-7)];
        [[UIColor whiteColor] setStroke];
        [selected setLineWidth:2.0];
        [selected stroke];
    }
}

-(int) fontSize
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) ||
            ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft))
//             ([[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp))
        {
            return 8;
        }
    }
    return FONT_SIZE;
}
-(int) offset
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if (([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) ||
            ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft))
//             ([[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp) )
        {
            return 4;
        }
    }
    return OFFSET;
}

@end
