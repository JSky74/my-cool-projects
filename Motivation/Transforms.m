//
//  Transforms.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-13.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "Transforms.h"
#define ENLARGMENT_SCALEFACTOR 1.2

@implementation Transforms

+ (CGAffineTransform) transformForView:(UIView *) view
         rotateAndScaleWithScaleFactor:(CGSize) scaleFactor
{
    
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor.width, scaleFactor.height);
    CGAffineTransform rotate = CGAffineTransformIdentity;
    if (scaleFactor.height != 1.0){
        rotate = CGAffineTransformMakeRotation([self degreesToRadians:3.0]);}
    CGAffineTransform scaleAndRotate =  CGAffineTransformConcat(scale, rotate);

    
    return scaleAndRotate;
}


//+ (CGAffineTransform) transformJigglingForView:(UIView *)view
//{
//
//#define kAnimationRotateDeg 0.5
//#define kAnimationTranslateX 1.0
//#define kAnimationTranslateY 1.0
//    
//   
//        int count = 1;
//        
//        CGAffineTransform leftWobble = CGAffineTransformMakeRotation([self degreesToRadians:kAnimationRotateDeg * (count%2 ? +1 : -1)]); //angle
//        CGAffineTransform rightWobble = CGAffineTransformMakeRotation([self degreesToRadians:kAnimationRotateDeg * (count%2 ? +1 : -1)]); //angle
//        CGAffineTransform moveTransform = CGAffineTransformTranslate(rightWobble, -kAnimationTranslateX, -kAnimationTranslateY);
//        CGAffineTransform conCatTransform = CGAffineTransformConcat(rightWobble, moveTransform);
//        
//        self.transform = leftWobble; //starting point
//        _conCatTransform = conCatTransform;
//    
//    
//
//}




+ (double) degreesToRadians:(double) degrees
{
    return (M_PI *(degrees) / 180);
}

+ (double) scaleFactor
{
    return ENLARGMENT_SCALEFACTOR;
}
@end
