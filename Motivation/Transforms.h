//
//  Transforms.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-13.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transforms : NSObject

+ (CGAffineTransform) transformForView:(UIView *) view
         rotateAndScaleWithScaleFactor:(CGSize) scaleFactor;

+  (CGFloat) enlargementScaleFactor;

@end
