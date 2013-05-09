//
//  AccessoryKeyboardView.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-17.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ShowNoteViewController.h"
#import "NotesAbstractViewController.h"

#define NUMBER_OF_COLORS 6
#define NUMBER_OF_BUTTONS 1

@interface AccessoryKeyboardView : UIView

-(id)initWithWidth:(CGFloat)width UIViewControllerPointer:(NotesAbstractViewController *) pointer;


@property  (nonatomic, strong) UIButton *compButton;
@property  (nonatomic, strong) NotesAbstractViewController *pointerToViewController;



//UIViewController must implement doneEditing,  will send doneEditing: when done
@end