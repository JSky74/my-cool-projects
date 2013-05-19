//
//  AccessoryKeyboardView.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-17.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//
// Underbar class! :-)

//UIViewController must implement doneEditing,  will send doneEditing: when done

#import <UIKit/UIKit.h>

#define NUMBER_OF_COLORS 6
#define NUMBER_OF_BUTTONS 1

@interface AccessoryKeyboardView : UIView

@property  (nonatomic, weak) UIViewController *pointerToViewController; //?? weak reference

-(id)initWithWidth:(CGFloat)width UIViewControllerPointer:(UIViewController *) pointer;
-(void)setNewWidth:(CGFloat)presentingViewControllerViewBounds;

@end 