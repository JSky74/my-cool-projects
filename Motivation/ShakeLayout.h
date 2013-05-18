//
//  ShakeLayout.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-07.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShakeLayout : UICollectionViewFlowLayout

@property (nonatomic) BOOL shake;
@property (nonatomic) CATransform3D transform3D;
@property (nonatomic) CATransform3D originalTransform;

@property (nonatomic, strong) NSNumber *layoutShouldHideCell;
@property (nonatomic, strong) NSIndexPath *indexPathOfMovingCell;


@end
