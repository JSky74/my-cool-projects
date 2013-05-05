//
//  AccessoryKeyboardView.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-17.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ShowNoteViewController.h"
#import "UIViewController+Done.h"

@interface AccessoryKeyboardView : UIView

-(id)initWithWidth:(CGFloat)width UIViewControllerPointer:(UIViewController *) pointer;
@property  (nonatomic, strong) UISegmentedControl *colorsSegementedControl;
@property  (nonatomic, strong) UIToolbar *toolbar;
@property  (nonatomic, strong) UIButton *compButton;
@property  (nonatomic, strong) UIViewController *pointer;

@property (nonatomic, strong) NSArray* imagesArray;

//UIViewController must implement doneEditing,  will send doneEditing: when done
@end