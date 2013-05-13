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
@interface MotivationCollectionView ()

@property (nonatomic) CGPoint locationOfTouch;
@property (strong, nonatomic) NSIndexPath *cellToMove;

@property (strong, nonatomic) CellLabel* cell;
@property (strong, nonatomic) NoteCell *note;


@end

@implementation MotivationCollectionView 

@synthesize userWillStartLongPressGesture = _userWillStartLongPressGesture;
#define ENLARGMENT_SCALEFACTOR 1.1 //Defined in NoteCell as well


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

-(void)handeLongPressGesture:(UILongPressGestureRecognizer *) longPress
{

if (longPress.state == UIGestureRecognizerStateBegan) {
    
    [self setLocationOfTouch:[longPress locationInView:self]];
    [self setCellToMove:[self indexPathForItemAtPoint:self.locationOfTouch]];
    
    [self setNote:(NoteCell *)[self cellForItemAtIndexPath:self.cellToMove]];
    [self.note enlargeCell:YES];
    [self setCell:[self.note.label copy]];
     
    [self.cell setHidden:YES];
    
    self.cell.transform = [Transforms transformForView:self.cell rotateAndScaleWithScaleFactor:CGSizeMake(ENLARGMENT_SCALEFACTOR, ENLARGMENT_SCALEFACTOR)];
    [self addSubview:self.cell];
    
    
    }
    
    
    if (longPress.state ==UIGestureRecognizerStateChanged) {
        
        
        //[self deleteItemsAtIndexPaths:[NSArray arrayWithObject:self.cellToMove]];
        
        self.cell.center = [longPress locationInView:self];
        [self.cell setHidden:NO];
        [self.note setHidden:YES];
        
    }
    if (longPress.state ==UIGestureRecognizerStateEnded)
    {
        CGPoint gestureEndedInPoint = [longPress locationInView:self];
        //CGPoint offsetYEndPoint = CGPointMake(gestureEndedInPoint.x, gestureEndedInPoint.y+self.cell.bounds.size.height/2);
        NSString *pointValue = NSStringFromCGPoint(gestureEndedInPoint);
        NSIndexPath *indexToDelete = [self indexPathForCell:self.note];
        
        NSArray *objects = [NSArray arrayWithObjects:pointValue, indexToDelete,nil];
        NSArray *keys = [NSArray arrayWithObjects:@"GestureEndedAtPoint", @"IndexToDelete", nil];
        
        NSIndexPath *insertAtIndex = [self indexPathForItemAtPoint:gestureEndedInPoint];
        //NSIndexPath *modifiedInsertAtIndex = [self indexPathForItemAtPoint:x]
        if (insertAtIndex && !([insertAtIndex isEqual:indexToDelete])) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserWillChangeLayout" object:self userInfo:[NSDictionary dictionaryWithObjects:objects forKeys:keys]];

        } 
        
        //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (insertAtIndex) {
                //self.cell.frame = [self cellForItemAtIndexPath:insertAtIndex].frame;
            } else
            {
                self.cell.frame = self.note.frame;
                
            }
            
            
        } completion:^(BOOL finished){
                        //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
                        [self.cell removeFromSuperview];
        
                            [self.note setHidden:NO];
                            [self.note enlargeCell:NO];
            
        }];
        
     }
}


//-(void) restoreNoteCell:(NSIndexPath *) indexPathOfCell
//{
//    
//    NoteCell *noteCell = (NoteCell *)[self cellForItemAtIndexPath:indexPathOfCell];
//    
//    [noteCell enlargeCell:NO]; //same as in did Unhighlight, restore to the original values.
//    noteCell.label.selected = !noteCell.label.selected;
//
//}

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
     _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handeLongPressGesture:)];
        [_longPressGesture setEnabled:YES];
        [_longPressGesture setMinimumPressDuration:0.1];
       
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
