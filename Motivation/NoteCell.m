//
//  NoteCell.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "NoteCell.h"
#import "MotivationCollectionView.h"
#import "Transforms.h"

@interface NoteCell ()
@property CGAffineTransform conCatTransform;
@property (nonatomic) BOOL enlarged;

@end




@implementation NoteCell

#define ENLARGMENT_SCALEFACTOR 1.1 //Defined in CollectioView as well

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self.label setSelected:selected];
    [self.label setNeedsDisplay];
    
}



-(void) enlargeCell:(BOOL) enlarge
{
    double xScale =1.0;
    double yScale =1.0;
    
    [self setEnlarged:enlarge];
    
    if (self.enlarged)
    {
        xScale = ENLARGMENT_SCALEFACTOR;
        yScale = ENLARGMENT_SCALEFACTOR;
    } else
        {
             xScale = 1.0;
             yScale = 1.0;
        }
        
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn animations:^{
        self.transform  = [Transforms transformForView:self rotateAndScaleWithScaleFactor:CGSizeMake(xScale, yScale)];
    } completion:^(BOOL finished){ }];
}





-(void)setJigglingEnabled:(NSNumber *)jigglingEnabled
{

    _jigglingEnabled = jigglingEnabled;
    [self startJiggling];
   
}

-(void)startJiggling
{
if ([self.jigglingEnabled boolValue]) {
            
#define kAnimationRotateDeg 0.5
#define kAnimationTranslateX 1.0
#define kAnimationTranslateY 1.0
    
    
        
    int count = 1;
    
    CGAffineTransform leftWobble = CGAffineTransformMakeRotation([self degreesToRadians:kAnimationRotateDeg * (count%2 ? +1 : -1)]); //angle
    CGAffineTransform rightWobble = CGAffineTransformMakeRotation([self degreesToRadians:kAnimationRotateDeg * (count%2 ? +1 : -1)]); //angle
    CGAffineTransform moveTransform = CGAffineTransformTranslate(rightWobble, -kAnimationTranslateX, -kAnimationTranslateY);
    CGAffineTransform conCatTransform = CGAffineTransformConcat(rightWobble, moveTransform);
    
    self.transform = leftWobble; //starting point //could be omitted if I want to have this code in Transforms
    _conCatTransform = conCatTransform;
    
    [UIView animateWithDuration:0.1 delay:(count * 0.08)
                        options:UIViewAnimationOptionAllowUserInteraction |             UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{self.transform = conCatTransform;}
                     completion:^(BOOL finished){ //completion can be removed
                         if(![self.jigglingEnabled boolValue]){
                             [self.layer removeAllAnimations];
                             self.transform = CGAffineTransformIdentity;
                                                       }
                     }];
} else {
        [self.layer removeAllAnimations];
        self.transform = CGAffineTransformIdentity;

        }
    
}


-(double) degreesToRadians:(double) degrees
{
    return (M_PI *(degrees) / 180);
}



@end
