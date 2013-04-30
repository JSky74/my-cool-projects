//
//  AccessoryKeyboardView.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-17.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowNoteViewController.h"

@interface AccessoryKeyboardView : UIView

-(id)initWithWidth:(CGFloat)width ShowNotePointer:(ShowNoteViewController *) pointer;

@property  (nonatomic, strong) UIButton *compButton;
@property  (nonatomic, strong) ShowNoteViewController *pointer;
@end