//
//  ShowNoteViewController.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-04-02.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "ShowNoteViewController.h"
#import "Colors.h"
#import "AccessoryKeyboardView.h"

@interface ShowNoteViewController ()

@property (weak, nonatomic) IBOutlet      UITextView *noteTextView;
@property (readwrite, nonatomic)            NSString *typedText;
@property (strong, nonatomic)                 Colors *colors;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *undoButton;
@property (readwrite, nonatomic) NSString *colorKey;

@end

@implementation ShowNoteViewController

#define EMPTY_SPACE @"\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
#define LEADING_SPACE @"\n\n\n\n"


- (IBAction)edit:(UIBarButtonItem *)sender {
    
    [self editingWillHappen:YES];
    
   NSRange textRange = NSMakeRange([self.noteTextView.text length]+1, 0); //place cursor at the end of the text
    self.noteTextView.text = [self.noteTextView.text stringByAppendingFormat:EMPTY_SPACE];
    [self.noteTextView setSelectedRange:textRange];
}


-(Colors *) colors
{
    if (!_colors) {
            _colors = [[Colors alloc] init];
    } return _colors;
}



-(void) viewDidLoad
{

    self.undoButton.enabled = NO;
    self.view.backgroundColor = [self.colors.noteColors objectForKey:self.note.color];
    
    self.noteTextView.text = self.note.text;
    self.noteTextView.textColor = [UIColor darkTextColor];
    self.noteTextView.backgroundColor = [self.colors.noteColors objectForKey:self.note.color];
    self.noteTextView.font = [UIFont fontWithName:[[NSUserDefaults standardUserDefaults] stringForKey:@"font_preference"] size:17];
    self.noteTextView.inputAccessoryView = [[AccessoryKeyboardView alloc] initWithWidth:self.view.bounds.size.width ShowNotePointer:self];
    [self setColorKey:self.note.color];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addLeadingSpace];
}



- (IBAction)doneEditing:(id)sender;
{
    
    [self editingWillHappen:NO];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:EMPTY_SPACE];
    self.noteTextView.text = [self.noteTextView.text stringByTrimmingCharactersInSet:characterSet];
    [self addLeadingSpace];
}


-(void) editingWillHappen:(BOOL)editingNeeded
{
    self.noteTextView.editable = editingNeeded;
    if (editingNeeded)
    {
        [self.noteTextView becomeFirstResponder];
    } else
    {
        [self.noteTextView resignFirstResponder];
        [self addLeadingSpace];
        //[self.noteTextView setSelectedRange:NSMakeRange(0, [LEADING_SPACE length])];
        [self.undoButton setEnabled:YES];
    }
}


- (IBAction)undoLatestTextChangeButton:(UIBarButtonItem *)sender {
    self.noteTextView.text = self.note.text;
    self.undoButton.enabled = NO;
}




-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self removeLeadingSpace];
    self.typedText =  self.noteTextView.text;
}





-(void) addLeadingSpace
{
    NSRange textBegining = NSMakeRange(0,0);
    self.noteTextView.text = [self.noteTextView.text stringByReplacingCharactersInRange:textBegining withString:LEADING_SPACE];
    
}

-(void) removeLeadingSpace
{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:LEADING_SPACE];
    self.noteTextView.text = [self.noteTextView.text stringByTrimmingCharactersInSet:characterSet];
}



@end
