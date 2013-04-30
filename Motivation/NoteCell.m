//
//  NoteCell.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "NoteCell.h"


@implementation NoteCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self.label setSelected:selected];
    [self.label setNeedsDisplay];
    
}
@end
