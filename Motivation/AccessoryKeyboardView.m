//
//  AccessoryKeyboardView.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-17.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "AccessoryKeyboardView.h"
#import "NewNoteViewController.h"
#import "ColorChooserKeyboardCell.h"
#import "Colors.h"



@interface AccessoryKeyboardView ()
@property (nonatomic) int buttonHeight;
@property (nonatomic) CGFloat newWidth;
@property (nonatomic, strong) NSArray* arrayOfColorChoosers;
@end




@implementation AccessoryKeyboardView


- (int) buttonHeight
{
    if (!_buttonHeight) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            _buttonHeight = 30;
        } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            _buttonHeight = 40;
        }
    }
    return _buttonHeight;
}

-(id)initWithWidth:(CGFloat)width UIViewControllerPointer:(NotesAbstractViewController *)pointer
{
    CGRect accessFrame = CGRectMake(0.0, 0.0, width, self.buttonHeight);
    self = [super initWithFrame:accessFrame];
    if (self) {
        _pointerToViewController = pointer;
        _newWidth = width;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                    initWithTarget:self  action:@selector(tapGesture:)]];
        [self setUp];
    }
    return self;
}

-(void)setNewWidth:(CGFloat)newWidth
{
    self.frame = CGRectMake(0.0, 0.0, newWidth, self.buttonHeight);
    self.compButton = nil;
    self.arrayOfColorChoosers = nil;
    [self setNeedsDisplay];
    [self setUp];
    [self setNeedsDisplay];
}

-(UIButton *) compButton
{
    if (!_compButton) {
        _compButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _compButton.backgroundColor = [UIColor whiteColor];
    }
    return _compButton;
}


-(void) setUp
{

    self.backgroundColor = [UIColor whiteColor];
    CGFloat buttonWidth = self.frame.size.width / (NUMBER_OF_COLORS+NUMBER_OF_BUTTONS);
    self.compButton.frame = CGRectMake(self.bounds.size.width-buttonWidth, 0, buttonWidth, self.buttonHeight);

    [self.compButton setTitle: @"Done" forState:UIControlStateNormal];
    self.compButton.tintColor = [UIColor grayColor];
    [self.compButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.compButton addTarget:self action:@selector(resign)
        forControlEvents:UIControlEventTouchUpInside];

    for (int i = 0; i<NUMBER_OF_COLORS; i++) {
        [self addSubview:[self.arrayOfColorChoosers objectAtIndex:i]];
        }
    [self addSubview:self.compButton];
}


-(NSArray *) arrayOfColorChoosers
{
if (!_arrayOfColorChoosers)
{
    CGFloat cellLength = self.frame.size.width / (NUMBER_OF_COLORS+NUMBER_OF_BUTTONS);
    NotesAbstractViewController *parentView = (NotesAbstractViewController *)self.pointerToViewController;
    NSMutableArray *mutableArrayOfColorChoosers  = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<NUMBER_OF_COLORS; i++) {
    ColorChooserKeyboardCell *cell =    [[ColorChooserKeyboardCell alloc] initWithFrame:CGRectMake(self.frame.origin.x + i*cellLength, self.frame.origin.y, cellLength, self.buttonHeight) cellColor:[parentView.colors.colorsArray objectAtIndex:i]  height:self.buttonHeight index:i];
        [mutableArrayOfColorChoosers addObject:cell];
        _arrayOfColorChoosers = mutableArrayOfColorChoosers;
        }
}
   return [_arrayOfColorChoosers copy];
}

-(void) tapGesture:(UITapGestureRecognizer *) tapGesture
{
    CGPoint tapLocation = [tapGesture locationInView:self];
    for (ColorChooserKeyboardCell* cell in self.arrayOfColorChoosers)
    {
        CGPoint cellView =  [cell convertPoint:tapLocation fromView:self];
        if ([cell pointInside:cellView withEvent:nil]) {
            [self animateView:(cell)];
        }
    }
}

-(void)animateView:(ColorChooserKeyboardCell*)view
{
    CGRect originalRect = view.frame;
    [self bringSubviewToFront:view];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationCurveEaseOut animations:^(void)
    {
        CGPoint translatedOrigin = [self translateToParentView:view];
        [view setFrame:CGRectMake(translatedOrigin.x-10, translatedOrigin.y-10, view.frame.size.width+20, view.frame.size.height+20)];
    }
completion:^(BOOL finished){
    
    [UIView animateWithDuration:0.2 animations:^{
    [view setFrame:originalRect];
        NSNumber *objectIndex = [NSNumber numberWithInt:view.indexOfCell];
        [self.pointerToViewController performSelector:@selector(setBackgroundColor:) withObject:objectIndex];
    }];

}];
}

-(CGPoint)translateToParentView:(UIView*)view
{
    CGPoint origin = [self convertPoint:view.bounds.origin fromView:view];

    return origin;
}

-(void) resign //called by Done button
{
    
    [self performSelector:@selector(dismissKeyboard) withObject:self afterDelay:0.1];
}
     

-(void) dismissKeyboard
{
    [(NotesAbstractViewController *)self.pointerToViewController doneEditing];
}



@end
