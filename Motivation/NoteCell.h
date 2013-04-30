//
//  NoteCell.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellLabel.h"   

@interface NoteCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet CellLabel *label;

@end
