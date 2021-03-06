//
//  ShowNoteViewController.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-02.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesAbstractViewController.h"
#import "Note.h"

@interface ShowNoteViewController : NotesAbstractViewController


@property (strong, nonatomic) Note* note;
@property (readonly, nonatomic) NSString *changedText;


@end
