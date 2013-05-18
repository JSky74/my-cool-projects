//
//  NewNoteViewController.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-30.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "NewNoteViewController.h"
#import "MotivationCVC.h"
#import "Settings.h"
#import "AccessoryKeyboardView.h"
#import "ColorChooserKeyboardCell.h"
@interface NewNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteText;
@property (readwrite, nonatomic) NSString *typedText;
@property (readwrite, nonatomic) NSString *colorKey;

@end

@implementation NewNoteViewController


-(void) doneEditing
{
    [self.noteText resignFirstResponder];
    MotivationCVC *presentingViewController = (MotivationCVC *)self.presentingViewController;
    NewNoteViewController *thisSegue = (NewNoteViewController *)presentingViewController.presentedViewController;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [presentingViewController saveNote:thisSegue];
    }];

}


-(NSString *) typedText
{

    if ([self.noteText.text length]) {
        return self.noteText.text;
    } else return nil;
}



-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[self.colors.noteColors objectForKey:HEAVENLY_BLUE]];
    [self setColorKey:HEAVENLY_BLUE];
    
    self.noteText.textColor = [UIColor blackColor];
    
     self.noteText.delegate = self;
     self.noteText.text = nil;
     self.noteText.font = [UIFont fontWithName:
                           [Settings retrieveFromUserDefaults:@"font_preference"] size:17];
    
    [self setAccessoryView:[[AccessoryKeyboardView alloc] initWithWidth:self.presentingViewController.view.bounds.size.width UIViewControllerPointer:self]];

    self.noteText.inputAccessoryView = self.accessoryView;
    [self.noteText becomeFirstResponder];
  
}

-(BOOL) shouldAutorotate
{
    return NO;
}

@end
