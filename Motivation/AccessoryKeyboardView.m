//
//  AccessoryKeyboardView.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-17.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "AccessoryKeyboardView.h"

#define BUTTON_HEIGHT 30

@implementation AccessoryKeyboardView

-(id)initWithWidth:(CGFloat) width ShowNotePointer:(ShowNoteViewController *)pointer
{
    CGRect accessFrame = CGRectMake(0.0, 0.0, width, BUTTON_HEIGHT);
    self = [super initWithFrame:accessFrame];
    if (self) {
        _pointer = pointer;
        [self setUp];
    }
    return self;

    
    
}

- (id)initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(UIButton *) compButton
{
    if (!_compButton) {
        _compButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    return _compButton;
}

-(void) setUp
{
    
    self.backgroundColor = [UIColor clearColor];
    self.compButton.frame = CGRectMake(self.bounds.size.width-70, self.bounds.size.height/2-30/2, 70.0, BUTTON_HEIGHT);

    [self.compButton setTitle: @"Done" forState:UIControlStateNormal];
    self.compButton.tintColor = [UIColor blueColor];
    [self.compButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    [self.compButton addTarget:self action:@selector(resign)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.compButton];

}

-(void) resign
{
    [self.pointer doneEditing:self];
}



@end
