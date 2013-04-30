//
//  NewNoteViewController.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-30.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "Colors.h"
#import <UIKit/UIKit.h>

@interface NewNoteViewController : UIViewController <UITextViewDelegate>

@property (readonly, nonatomic) NSString *typedText;
@property (readonly, nonatomic) NSString *colorKey;

@end
