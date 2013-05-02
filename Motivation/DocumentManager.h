//
//  DocumentManager.h
//  MyPhotomania
//
//  Created by Jasko Demirovic on 2013-03-24.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentManager : NSObject


+ (UIManagedDocument *) useMotivationDocument;
+ (BOOL) saveDocument:(UIManagedDocument *) document;

@end
