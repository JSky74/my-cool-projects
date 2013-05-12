//
//  NotesAbstractViewController.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-06.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colors.h"

@interface NotesAbstractViewController : UIViewController

- (void) doneEditing; //abstract

- (void) setBackgroundColor:(NSNumber *)index;
- (void) colorChosen:(NSNumber *) indexOfColor;
- (Colors *) colors;

@property (readonly, nonatomic) NSString *colorKey;
 
@end




