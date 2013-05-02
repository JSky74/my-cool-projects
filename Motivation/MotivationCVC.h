//
//  MotivationCVC.h
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface MotivationCVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIManagedDocument *document;
@property (strong, nonatomic) NSMetadataQuery *iCloudQuery;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
