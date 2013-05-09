//
//  DocumentManager.m
//  MyPhotomania
//
//  Created by Jasko Demirovic on 2013-03-24.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "DocumentManager.h"
#import <CoreData/CoreData.h>

#define DOCUMENT_NAME @"MotivationDocument3"
#define TRANSACTION_LOG @"Transactions3"

@interface DocumentManager ()
@end

@implementation DocumentManager



+ (UIManagedDocument *) useMotivationDocument
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                         inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:DOCUMENT_NAME];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] ubiquityIdentityToken]) //user is signed to iCloud
    {
        //ask user to enable iCloud, maybe a swtich in Settings to save that choice
        [DocumentManager setPersistentStoreOptionsInDocument:document];
    }
    
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        // create
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                if(success) { NSLog(@"####ManagedDocument created sucessfully");}
            }];
    } else if (document.documentState == UIDocumentStateClosed) {
        //open it
            [document openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"###ManagedDocument was closed, opened sucessfully");
                    //[DocumentManager moveDocumentToCloud:document];
                }
                    else  if (!success) { NSLog(@"###Failed to open a closed document");}
        }];
    }
    else if (document.documentState == UIDocumentStateInConflict)
    {
        NSLog(@"####ManagedDocument in conflict!!");
    }
    else if (document.documentState == UIDocumentStateSavingError)
    {
        NSLog(@"####ManagedDocument saving error!!!");
    } else if (document.documentState == UIDocumentStateEditingDisabled)
    {
        NSLog(@"####ManagedDocument editing disabled!!!");
    }
    
    else
    { NSLog(@"Cannot open managed document, trying to use it");}
    
    return document;
}


+ (BOOL) saveDocument:(UIManagedDocument *) document
{
    BOOL saved __block;
    saved = NO;
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:DOCUMENT_NAME];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        NSLog(@"No document!");
        //exit(1);
    }
    if (document.documentState == UIDocumentStateNormal) {
         NSLog(@"Document is open/normal , trying to save ...");
         [document saveToURL:url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
         if (success) {
         NSLog(@"Saved for overwriting successfully!");
             saved = YES;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"MyNotificationDocumentIsSaved" object:document];
         } else if (!success) {
             
             saved = NO;
             NSLog(@"Failed to save the document");
             NSLog(@"Something is wrong");
         }}];
    }
    
    return saved;
}

    //First two (migrate and mapping) are unrelated to iCloud, just migration schema
+(void) setPersistentStoreOptionsInDocument:(UIManagedDocument *) document
{
 
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    NSString *documentName;
    NSURL *sharedChangeLog;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]])
    {
        NSURL *metaData = [document.fileURL URLByAppendingPathComponent:@"DocumentMetadata.plist"];
        NSDictionary *optionsDictionary = [NSDictionary dictionaryWithContentsOfFile:[metaData path]];
        documentName = [optionsDictionary objectForKey:NSPersistentStoreUbiquitousContentNameKey];
        sharedChangeLog = [optionsDictionary objectForKey:NSPersistentStoreUbiquitousContentURLKey];
    }
    
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
    
    //iCloud related:
    if (!documentName) {
        documentName = [document.fileURL lastPathComponent];
    }
    
    [options setObject:documentName forKey:NSPersistentStoreUbiquitousContentNameKey];
    
    if (!sharedChangeLog) {
        NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        sharedChangeLog = [ubiquityURL URLByAppendingPathComponent:TRANSACTION_LOG];
    }
    
    [options setObject:sharedChangeLog forKey:NSPersistentStoreUbiquitousContentURLKey];
    
    [document setPersistentStoreOptions:options];
    
    //merge policy
    [document.managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy]; //??
    //EXPERIMENTAL
    //[document.managedObjectContext setRetainsRegisteredObjects:YES];
    
    //This policy merges conflicts between the persistent store’s version of the object and the current in-memory version, giving priority to in-memory changes.
    
    //OMG BUG IN THE API!
    // https://devforums.apple.com/message/785558#785558
    
}


+(void) moveDocumentToCloud2:(UIDocument *) document
{
    // DETTA LYCKADES EFTER STEGVIS GENOMGÅNG !!!
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        NSURL *localURL = document.fileURL; // url of document to transfer to iCloud
         NSLog(@"localURL %@", [localURL path]);
        NSString *name = [localURL lastPathComponent];
        NSURL *iCloudURL = [ubiquityURL URLByAppendingPathComponent:name];
        NSLog(@"iCloudURL %@", [iCloudURL path]);
        NSError *error = nil;
        
        
        BOOL success;
                    
            success = [[[NSFileManager alloc] init] setUbiquitous:YES
                                                        itemAtURL:localURL
                                                   destinationURL:iCloudURL
                                                            error:&error]; // move the document
            
    
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"File moved to iCloud");
            } else
                NSLog(@"No success moving file to iCloud");
                
            
        });
        
    });
    
}


+(void) moveDocumentToCloud:(UIDocument *) document
{
    // DETTA LYCKADES EFTER STEGVIS GENOMGÅNG !!!
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        NSURL *localURL = document.fileURL; // url of document to transfer to iCloud
        NSString *name = [localURL lastPathComponent];
        NSURL *iCloudURL = [ubiquityURL URLByAppendingPathComponent:@"Documents"];
        iCloudURL = [iCloudURL URLByAppendingPathComponent:name];
        
        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        NSError *coordinationError;
        
        BOOL success __block;
        
        [coordinator coordinateWritingItemAtURL:iCloudURL options:NSFileCoordinatorWritingForReplacing error:&coordinationError byAccessor:^(NSURL *writeURL){
            
            success = [[[NSFileManager alloc] init] setUbiquitous:YES
                                                        itemAtURL:localURL
                                                   destinationURL:writeURL
                                                            error:nil]; // move the document
            
        }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"File moved to iCloud");
            } else
                NSLog(@"No success moving file to iCloud");
        });
        
    });
    
}


@end