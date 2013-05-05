//
//  ShowNoteViewController.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-02.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewNoteViewController.h"
#import "Note.h"

@interface ShowNoteViewController : UIViewController


@property (strong, nonatomic) Note* note;
@property (readonly, nonatomic) NSString *changedText;

- (IBAction)doneEditing;

@end
