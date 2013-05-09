//
//  NotesAbstractViewController.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-05-06.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "NotesAbstractViewController.h"

@interface NotesAbstractViewController ()
@property (strong, nonatomic) Colors *colors;
@property (readwrite, nonatomic) NSString *colorKey;
@end

@implementation NotesAbstractViewController

- (void) setBackgroundColor:(NSNumber *)index
{
    [self colorChosen:index];
}


- (void) doneEditing
{
    //Abstract
}

-(Colors *) colors
{
    if (!_colors) {
        _colors = [[Colors alloc] init];
    }
    return _colors;
}


- (void) colorChosen:(NSNumber *) indexOfColor {
    
    int index = [indexOfColor intValue];
    
    
    switch (index) {
        case 0:
            //self.image = [self.colors.noteImages objectForKey:LIGHT_YELLOW];
            self.colorKey = LIGHT_YELLOW;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:LIGHT_YELLOW];
            break;
            
        case 1:
            //self.image = [self.colors.noteImages objectForKey:LIME_GREEN];
            self.colorKey = LIME_GREEN;
            self.view.backgroundColor =[self.colors.noteColors objectForKey:LIME_GREEN] ;
            break;
            
        case 2:
            //self.image = [self.colors.noteImages objectForKey:HEAVENLY_BLUE];
            self.colorKey = HEAVENLY_BLUE;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:HEAVENLY_BLUE];
            break;
            
        case 3:
            //self.image = [self.colors.noteImages objectForKey:CARMIN_RED];
            self.colorKey = CARMIN_RED;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:CARMIN_RED];
            break;
            
        case 4:
            //self.image = [self.colors.noteImages objectForKey:WINE_RED];
            self.colorKey = WINE_RED;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:WINE_RED];
            break;
            
        case 5:
            //self.image = [self.colors.noteImages objectForKey:SANDY_YELLOW];
            self.colorKey = SANDY_YELLOW;
            self.view.backgroundColor = [self.colors.noteColors objectForKey:SANDY_YELLOW];
            break;
            
        default:
            break;
    }
}



@end
