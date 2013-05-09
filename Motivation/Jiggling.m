//
//  Jiggling.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-08.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "Jiggling.h"

@interface Jiggling ()

@property CGAffineTransform transform;
@property CGAffineTransform conCatTransform;
@end

@implementation Jiggling

#define kAnimationRotateDeg 0.5
#define kAnimationTranslateX 1.0
#define kAnimationTranslateY 1.0


-(void)startJiggling
{
    int count = 1;
    
    CGAffineTransform leftWobble = CGAffineTransformMakeRotation([self degreesToRadians:kAnimationRotateDeg * (count%2 ? +1 : -1)]); //angle
    CGAffineTransform rightWobble = CGAffineTransformMakeRotation([self degreesToRadians:kAnimationRotateDeg * (count%2 ? +1 : -1)]); //angle
    CGAffineTransform moveTransform = CGAffineTransformTranslate(rightWobble, -kAnimationTranslateX, -kAnimationTranslateY);
    CGAffineTransform conCatTransform = CGAffineTransformConcat(rightWobble, moveTransform);
    
    self.transform = leftWobble; //starting point
    _conCatTransform = conCatTransform;
    
    [UIView animateWithDuration:0.1 delay:(count * 0.08)
                        options:UIViewAnimationOptionAllowUserInteraction |             UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{self.transform = conCatTransform;} completion:nil];
    
    
}



-(double) degreesToRadians:(double) radians
{
    return (M_PI *(radians) / 180);
}

@end


