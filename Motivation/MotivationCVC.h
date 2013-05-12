//
//  MotivationCVC.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "MotivationCollectionView.h"

@interface MotivationCVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate>

@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSMetadataQuery *iCloudQuery;

@property (strong, nonatomic) IBOutlet MotivationCollectionView *motivationCollectionView;

-(void) saveNote:(UIViewController *)sender;

@end
