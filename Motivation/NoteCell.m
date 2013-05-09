//
//  NoteCell.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "NoteCell.h"

@interface NoteCell ()
@property CGAffineTransform conCatTransform;

@end




@implementation NoteCell

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
    
    if (enlarge)
    {
        xScale = 1.1;
        yScale = 1.1;
    } else
        {
             xScale = 1.0;
             yScale = 1.0;
        }
        
        

        
    CGAffineTransform scale = CGAffineTransformMakeScale(xScale, yScale);
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform  = scale;
    } completion:^(BOOL finished){
        
    }];

}





-(void)setJigglingEnabled:(NSNumber *)jigglingEnabled
{
    _jigglingEnabled = jigglingEnabled;
    [self startJiggling];
  
}

-(void)startJiggling
{
 
#define kAnimationRotateDeg 0.5
#define kAnimationTranslateX 1.0
#define kAnimationTranslateY 1.0
    
    if ([self.jigglingEnabled boolValue]) {
        
    int count = 1;
    
    CGAffineTransform leftWobble = CGAffineTransformMakeRotation([self degreesToRadians:kAnimationRotateDeg * (count%2 ? +1 : -1)]); //angle
    CGAffineTransform rightWobble = CGAffineTransformMakeRotation([self degreesToRadians:kAnimationRotateDeg * (count%2 ? +1 : -1)]); //angle
    CGAffineTransform moveTransform = CGAffineTransformTranslate(rightWobble, -kAnimationTranslateX, -kAnimationTranslateY);
    CGAffineTransform conCatTransform = CGAffineTransformConcat(rightWobble, moveTransform);
    
    self.transform = leftWobble; //starting point
    _conCatTransform = conCatTransform;
    
    [UIView animateWithDuration:0.1 delay:(count * 0.08)
                        options:UIViewAnimationOptionAllowUserInteraction |             UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{self.transform = conCatTransform;} completion:NULL];
    } 
    
}


-(double) degreesToRadians:(double) radians
{
    return (M_PI *(radians) / 180);
}



@end
