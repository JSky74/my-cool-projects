//
//  AccessoryKeyboardView.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-17.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "AccessoryKeyboardView.h"
#import "NewNoteViewController.h"

#define BUTTON_HEIGHT 30

@implementation AccessoryKeyboardView

-(id)initWithWidth:(CGFloat) width UIViewControllerPointer:(UIViewController *)pointer
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
    return self;
}

-(UIButton *) compButton
{
    if (!_compButton) {
        _compButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    }
    return _compButton;
}

- (NSArray *) imagesArray
{
    if (!_imagesArray) {
        _imagesArray = [NSArray arrayWithObjects:  [UIImage imageNamed:@"LightYellow46"],
                                    [UIImage imageNamed:@"LimeGreen46"],
                                    [UIImage imageNamed:@"HeavenlyBlue46"],
                                    [UIImage imageNamed:@"CarminRed46"],
                                    [UIImage imageNamed:@"WineRed46"],
                                    [UIImage imageNamed:@"SandyYellow46"],
         nil];
    
    }
    return _imagesArray;
}

- (UISegmentedControl *) colorsSegementedControl
{
    if (!_colorsSegementedControl){
            _colorsSegementedControl = [[UISegmentedControl alloc] initWithItems:self.imagesArray];
        //_colorsSegementedControl.apportionsSegmentWidthsByContent = YES;
        _colorsSegementedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        
        //[[UISegmentedControl appearance] setContentMode:UIViewContentModeScaleToFill];
        [_colorsSegementedControl setWidth:40 forSegmentAtIndex:0];
        [_colorsSegementedControl setWidth:40 forSegmentAtIndex:1];
        [_colorsSegementedControl setWidth:40 forSegmentAtIndex:2];
        [_colorsSegementedControl setWidth:40 forSegmentAtIndex:3];
        [_colorsSegementedControl setWidth:40 forSegmentAtIndex:4];
        [_colorsSegementedControl setWidth:40 forSegmentAtIndex:5];
        
        _colorsSegementedControl.frame = CGRectMake(self.colorsSegementedControl.frame.size.width, self.colorsSegementedControl.frame.origin.y-15, self.colorsSegementedControl.frame.size.width, self.colorsSegementedControl.frame.size.height); //vet inte varför detta centrerar
        
        [_colorsSegementedControl addTarget:self.pointer action:@selector(segmentedControlNoteChooser:) forControlEvents:UIControlEventValueChanged];
                 
    }
    return _colorsSegementedControl;
}

-(void) setUp
{
    
    self.backgroundColor = [UIColor clearColor];
    self.compButton.frame = CGRectMake(self.bounds.size.width-70, self.bounds.size.height/2-30/2, 70.0, BUTTON_HEIGHT);

    [self.compButton setTitle: @"Done" forState:UIControlStateNormal];
    self.compButton.tintColor = [UIColor grayColor];
    [self.compButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.compButton addTarget:self action:@selector(resign)
        forControlEvents:UIControlEventTouchUpInside];

    _toolbar = [[UIToolbar alloc] initWithFrame:self.frame];
    [_toolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    
    [self addSubview:self.toolbar];
    [self addSubview:self.compButton];
    
    if ([self.pointer isKindOfClass:[NewNoteViewController class]]) {
        [self.toolbar addSubview:self.colorsSegementedControl];
    }
    

    
}

-(void) resign //called by Done button
{
    [self.pointer doneEditing];
}



@end
