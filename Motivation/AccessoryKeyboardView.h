//
//  AccessoryKeyboardView.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-17.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//


#import <UIKit/UIKit.h>


#define NUMBER_OF_COLORS 6
#define NUMBER_OF_BUTTONS 1

@interface AccessoryKeyboardView : UIView

-(id)initWithWidth:(CGFloat)width UIViewControllerPointer:(UIViewController *) pointer;
-(void)setNewWidth:(CGFloat)newWidth;

@property  (nonatomic, strong) UIButton *compButton;
@property  (nonatomic, weak) UIViewController *pointerToViewController; //?? 

//UIViewController must implement doneEditing,  will send doneEditing: when done
@end 