//
//  NewNoteViewController.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-30.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "NewNoteViewController.h"
#import "Settings.h"

@interface NewNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *noteText;
@property (readwrite, nonatomic) NSString *typedText;
@property (readwrite, nonatomic) NSString *colorKey;
@property (strong, nonatomic) Colors *colors;
@property (strong, nonatomic) UIImage *image;

@end

@implementation NewNoteViewController

- (IBAction)segmentedControlNoteChooser:(UISegmentedControl *)sender {
    
    self.noteText.textColor = [UIColor blackColor];
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.image = [self.colors.noteImages objectForKey:LIGHT_YELLOW];
            self.colorKey = LIGHT_YELLOW;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:LIGHT_YELLOW];
            break;
            
        case 1:
            self.image = [self.colors.noteImages objectForKey:LIME_GREEN];
            self.colorKey = LIME_GREEN;
            self.view.backgroundColor =[self.colors.noteColors objectForKey:LIME_GREEN] ;
            break;
            
        case 2:
            self.image = [self.colors.noteImages objectForKey:HEAVENLY_BLUE];
            self.colorKey = HEAVENLY_BLUE;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:HEAVENLY_BLUE];
            break;
            
        case 3:
            self.image = [self.colors.noteImages objectForKey:CARMIN_RED];
            self.colorKey = CARMIN_RED;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:CARMIN_RED];
            break;
            
        case 4:
            self.image = [self.colors.noteImages objectForKey:WINE_RED];
            self.colorKey = WINE_RED;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:WINE_RED];
            break;
            
        case 5:
            self.image = [self.colors.noteImages objectForKey:SANDY_YELLOW];
            self.colorKey = SANDY_YELLOW;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:SANDY_YELLOW];
            break;
            
        default:
            break;
    }
}


-(Colors *) colors
{
    if (!_colors) {
        _colors = [[Colors alloc] init];
    }
    return _colors;
}


-(void) textViewDidEndEditing:(UITextView *)textView
{
    [self.noteText resignFirstResponder];
}


-(void) textViewDidBeginEditing:(UITextView *)textView
{
    
}

-(NSString *) typedText
{
    return self.noteText.text;
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
     self.noteText.delegate = self;
     self.noteText.text = nil;
     self.noteText.font = [UIFont fontWithName:
                           [Settings retrieveFromUserDefaults:@"font_preference"] size:17];
    [self.noteText becomeFirstResponder];

}

@end
