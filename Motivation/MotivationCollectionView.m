//
//  MotivationCollectionView.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-11.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "MotivationCollectionView.h"
#import "CellLabel.h"
#import "NoteCell.h"
#import "Transforms.h"
#import "ShakeLayout.h"
@interface MotivationCollectionView ()

@property (nonatomic) CGPoint locationOfTouch;

@property (strong, nonatomic) NSIndexPath *indexOfNote;
@property (strong, nonatomic) CellLabel* noteProxy;
@property (strong, nonatomic) NoteCell *note;

@end

@implementation MotivationCollectionView 

@synthesize userWillStartLongPressGesture = _userWillStartLongPressGesture;





-(BOOL)userWillStartLongPressGesture
{
    _userWillStartLongPressGesture =  self.longPressGesture.enabled;
    return _userWillStartLongPressGesture;
}
-(void)setUserWillStartLongPressGesture:(BOOL)userWillStartLongPressGesture
{
    [self.longPressGesture setEnabled:userWillStartLongPressGesture];
    _userWillStartLongPressGesture = userWillStartLongPressGesture;
    NSLog(@"LongPress***%@", self.longPressGesture);
}





-(void)handleLongPressGesture:(UILongPressGestureRecognizer *) longPress
{
    static NSIndexPath *indexToMoveTo;
    static NSIndexPath *currentIndexOfMovingProxy;
    static CGRect indexToMoveToFrame;
    static NSIndexPath *indexToMoveFrom;
    static CGPoint currentTouchLocation;
    static NSString *currentCGPointValueString;
    
    static BOOL firstTouch;
    
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        [self setLocationOfTouch:[longPress locationInView:self]];
        [self setIndexOfNote:[self indexPathForItemAtPoint:self.locationOfTouch]];
        [self setNote:(NoteCell *)[self cellForItemAtIndexPath:self.indexOfNote]];
        [self setNoteProxy:[self.note.label copy]];
        [self.noteProxy setFrame:self.note.frame];
    
        [UIView animateWithDuration:0.4 animations:^{
                            self.noteProxy.transform = [Transforms transformForView:self.noteProxy
                               rotateAndScaleWithScaleFactor:CGSizeMake([Transforms enlargementScaleFactor],
                                                                        [Transforms enlargementScaleFactor])];
        }];
        
        [self addSubview:self.noteProxy];
        currentIndexOfMovingProxy = [self indexPathForCell:self.note];
        indexToMoveFrom = currentIndexOfMovingProxy;
        indexToMoveTo = currentIndexOfMovingProxy;
        indexToMoveToFrame = self.note.frame;
        [self.note setHidden:YES];
        firstTouch = YES;
    }
    
    
    if (longPress.state == UIGestureRecognizerStateChanged) {
        
        CGPoint touchPoint = [longPress locationInView:self];
        static CGPoint offset;
        if (firstTouch) {
            offset = CGPointMake(self.noteProxy.center.x - touchPoint.x, self.note.center.y-touchPoint.y);
            self.noteProxy.center = CGPointMake(touchPoint.x-offset.x, touchPoint.y-offset.y);
            firstTouch = NO;
        } else
        {
            self.noteProxy.center = CGPointMake(touchPoint.x+offset.x, touchPoint.y+offset.y);
        }
        
        //NSIndexPath *indexToMoveFrom = currentIndexOfMovingProxy;
        currentTouchLocation = [longPress locationInView:self];
        currentCGPointValueString = NSStringFromCGPoint(currentTouchLocation);
        
        indexToMoveTo = [self indexPathForItemAtPoint:currentTouchLocation];
        if (indexToMoveTo && !([indexToMoveTo isEqual:indexToMoveFrom])) {
            if (CGRectContainsRect(self.noteProxy.frame, [self cellForItemAtIndexPath:indexToMoveTo].frame)) {
                
                NSArray *objects = [NSArray arrayWithObjects:currentCGPointValueString, indexToMoveFrom, nil];
                NSArray *keys = [NSArray arrayWithObjects:@"CurrentCGPointValueString", @"IndexToMoveFrom", nil];
                
                if ([objects count] == 2 && [keys count] ==2) {
                    
                    indexToMoveToFrame = ([self cellForItemAtIndexPath:indexToMoveTo]).frame;
                    [(ShakeLayout *)self.collectionViewLayout setLayoutShouldHideCell:[NSNumber numberWithInt:indexToMoveTo.item]];
                    currentIndexOfMovingProxy = indexToMoveTo;
                    
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"UserWillChangeLayout" object:self userInfo:[NSDictionary dictionaryWithObjects:objects forKeys:keys]];
                    
                }
            }
        }
        

        
       
}
    
    if (longPress.state ==UIGestureRecognizerStateEnded)
    {
        if (indexToMoveTo && !([indexToMoveTo isEqual:indexToMoveFrom])) {
            if (CGRectContainsRect(self.noteProxy.frame, [self cellForItemAtIndexPath:indexToMoveTo].frame)) {
                NSString *currentCGPointValueString = NSStringFromCGPoint(currentTouchLocation);
                NSArray *objects = [NSArray arrayWithObjects:currentCGPointValueString, indexToMoveFrom, nil];
                NSArray *keys = [NSArray arrayWithObjects:@"CurrentCGPointValueString", @"IndexToMoveFrom", nil];
                
                if ([objects count] == 2 && [keys count] ==2) {
                    
                    indexToMoveToFrame = ([self cellForItemAtIndexPath:indexToMoveTo]).frame;
                    [(ShakeLayout *)self.collectionViewLayout setLayoutShouldHideCell:[NSNumber numberWithInt:indexToMoveTo.item]];
                    currentIndexOfMovingProxy = indexToMoveTo;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserWillChangeLayout" object:self userInfo:[NSDictionary dictionaryWithObjects:objects forKeys:keys]];
                    
                }
            }
        }
        
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (indexToMoveTo)
                {
                    self.noteProxy.transform = CGAffineTransformIdentity;
                    self.noteProxy.frame = indexToMoveToFrame;
                } else
                {
                    self.noteProxy.frame = self.note.frame;
                }
            
        } completion:^(BOOL finished){
                            [(ShakeLayout *)self.collectionViewLayout setLayoutShouldHideCell:nil];
                            [self.noteProxy removeFromSuperview];
                            [self.note setHidden:NO];
                            [self.note enlargeCell:NO];
            
            
        }];
        
     }

}



-(void) addLongPressGestureRecognizer
{
     
    NSArray* recognizers = [self gestureRecognizers];
    
    // Make the default gesture recognizer wait until the custom one fails.
    for (UIGestureRecognizer* aRecognizer in recognizers) {
        if ([aRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
        {
            [aRecognizer requireGestureRecognizerToFail:self.longPressGesture];
           
        }
    }
    
    // Now add the gesture recognizer to the collection view.
    [self addGestureRecognizer:self.longPressGesture];  

}

-(UILongPressGestureRecognizer *)longPressGesture
{
    if (!_longPressGesture) {
     _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [_longPressGesture setEnabled:YES];
        [_longPressGesture setMinimumPressDuration:0.3];
    }
    return _longPressGesture;
}


-(void)removeLongPressGestureRecognizer
{
 
    NSArray* recognizers = [self gestureRecognizers];
    
    for (UIGestureRecognizer* aRecognizer in recognizers) {
        if ([aRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
            if ([aRecognizer isEqual:self.longPressGesture]) {
                [self removeGestureRecognizer:aRecognizer];
            }
    }
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


@end
