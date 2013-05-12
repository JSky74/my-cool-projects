//
//  MotivationCollectionView.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-11.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MotivationCollectionView : UICollectionView

@property BOOL userWillStartLongPressGesture;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

-(void) addLongPressGestureRecognizer;
-(void)removeLongPressGestureRecognizer;

@end
