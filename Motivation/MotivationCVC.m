//
//  MotivationCVC.m
//  Motivation
//
//  Created by Jasko Demirovic on 2013-03-31.
//  Copyright (c) 2013 Jasko Demirovic. All rights reserved.
//

#import "ShowNoteViewController.h"
#import "MotivationCVC.h"
#import "NoteCell.h"
#import "Colors.h"
#import "Note.h"
#import "Settings.h"
#import "NewNoteViewController.h"
#import "DocumentManager.h"
#import "Note+Create.h"


@interface MotivationCVC ()

@property (nonatomic, strong) NSArray *arrayOfNotesFromCoreData;
@property (nonatomic, strong) Colors *color;
@property BOOL userRequestedChange;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *changeButton;

@end



@implementation MotivationCVC

#pragma mark  ------------------ delegate methodes collection view -------------------------------

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.userRequestedChange){
        [self performSegueWithIdentifier:@"setNote:" sender:indexPath];
    }
    else if (self.userRequestedChange)
    {
        [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayOfNotesFromCoreData count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Note Cell" forIndexPath:indexPath];
    
    Note *note;
    if ([cell isKindOfClass:[NoteCell class]]) {
        NoteCell *noteCell = (NoteCell *)cell;
        note =  (Note *) self.arrayOfNotesFromCoreData[indexPath.item];
        noteCell.label.text = note.text;
        noteCell.label.textColor = [UIColor darkTextColor];
        [noteCell.label setImage:[self.color.noteImages objectForKey:note.color]];
        [noteCell.label setFontName:[Settings retrieveFromUserDefaults:@"font_preference"]];
        
    }
    return cell;
}


#pragma mark  ------------------ user interface -------------------------------

-(UIActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete notes" otherButtonTitles:nil,  nil];
    }
    return _actionSheet;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 

{
    NSMutableArray *archivedNotes = [[NSMutableArray alloc] init];
    NSMutableIndexSet *mutableIndexSet = [[NSMutableIndexSet alloc] init];
    
    if (buttonIndex == 0) {
    NSArray *selectedItems =  [self.collectionView indexPathsForSelectedItems];
                        for (int i = 0; i<[selectedItems count]; i++)
                                {
                                            for (id note in self.arrayOfNotesFromCoreData) {
                                                        if ([self.arrayOfNotesFromCoreData indexOfObject:note] == ((NSIndexPath *)selectedItems[i]).item)
                                                            {
                                                            
                                                            [archivedNotes addObject:(Note *)note];
                                                            [mutableIndexSet addIndex:((NSIndexPath *)selectedItems[i]).item];
                                                                
                                                            }
                                            }
                                    }
    
    
        if ([archivedNotes count]) {
            //erase from array in the model and update the collection view;
            NSMutableArray *mutableArrayOfNotes =  [self.arrayOfNotesFromCoreData mutableCopy];
            [mutableArrayOfNotes removeObjectsAtIndexes:[mutableIndexSet copy]];
            self.arrayOfNotesFromCoreData = [mutableArrayOfNotes copy];
            [self.collectionView deleteItemsAtIndexPaths:selectedItems];
            
            self.changeButton.tintColor = nil;
            self.collectionView.allowsMultipleSelection = NO;
            self.trashButton.enabled = NO;
            self.userRequestedChange = !self.userRequestedChange;

        }
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        for (id note in archivedNotes) {
            [dateArray addObject:((Note *) note).date];
        }
    
    //mark archived
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    request.predicate = [NSPredicate predicateWithFormat:@"date IN %@", dateArray];
    NSError *error = nil;
    NSArray *arrayOfPhotosToArchive = [self.document.managedObjectContext executeFetchRequest:request error:&error];
        for (id note in arrayOfPhotosToArchive) {
            ((Note *)note).archived = [NSNumber numberWithBool:YES];
            //[self.context save:NULL];
            [self fetchNotes];
        }
    }
}


- (IBAction)deleteButton:(UIBarButtonItem *)sender {
    if (self.userRequestedChange) {
            [self.actionSheet showFromBarButtonItem:sender animated:YES];
    }
}


- (IBAction)userRequestsChangeButton:(UIBarButtonItem *)sender {
    self.userRequestedChange = !self.userRequestedChange;
    if (self.userRequestedChange) {
        sender.tintColor = [UIColor blueColor];
        self.collectionView.allowsMultipleSelection = YES;
        self.trashButton.enabled = YES;
    } else {
        sender.tintColor = nil;
        self.collectionView.allowsMultipleSelection = NO;
        self.trashButton.enabled = NO;
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[NSIndexPath class]]) {
        if ([segue.identifier isEqualToString:@"setNote:"]) {
            if ([segue.destinationViewController isKindOfClass:[ShowNoteViewController class]]) {
                [segue.destinationViewController performSelector:@selector(setNote:) withObject:[self.arrayOfNotesFromCoreData objectAtIndex:((NSIndexPath *)sender).item]];
            }
        }
    }
}


-(Colors *) color
{
    if (!_color) {
        _color = [[Colors alloc] init];
    }
    return _color;
}


-(NSArray *) arrayOfNotesFromCoreData
{
    if (!_arrayOfNotesFromCoreData) _arrayOfNotesFromCoreData = [[NSArray alloc] init];
    return _arrayOfNotesFromCoreData;
}

-(void) setDocument:(UIManagedDocument *)document
{
    _document = document;
}






#pragma mark  ------------------ data manipulation -------------------------------


-(void) dataImported:(NSNotification *)notification
{
    NSLog(@"NSPersistentStoreDidImportUbiquitousContentChangesNotification");
    NSLog(@"%@",notification);
    
    [self.document.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    
    // possible solution
    // if notification.userInfo is empty, send back a message and try to create again!
    /*{
	    deleted = "{(\n)}";
	    inserted = "{(\n)}";
	    updated = "{(\n)}";
	}*/
    
    [self saveDocument]; // Save new version of the document in the persistent Store on Device
}



-(NSError *) fetchNotes
{
    NSError *error = nil;
    if (self.document.managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"archived == %@", [NSNumber numberWithBool:NO]];
        self.arrayOfNotesFromCoreData = [self.document.managedObjectContext executeFetchRequest:request error:&error];
        
    }
   return error; 
}


-(IBAction) dismissNote:(UIStoryboardSegue *) sender
{
    [self fetchNotes];
    [self.collectionView reloadData];
}


-(IBAction) saveNote:(UIStoryboardSegue *)sender
{
    if ([sender.sourceViewController isKindOfClass:[ShowNoteViewController class]]) {
        ShowNoteViewController *noteVC = sender.sourceViewController;
        //if (![noteVC.changedText isEqualToString:noteVC.note.text]) { WILL ALWAYS UPDATE TEXT - WORKS
            noteVC.note.text = noteVC.changedText;
              }
        else {
            NewNoteViewController *newNote = sender.sourceViewController;
            [Note noteWithContent:newNote.typedText
                        color:newNote.colorKey
                     archived:[NSNumber numberWithBool:NO]
           inManagedObjectContext:self.document.managedObjectContext];
    
    }
    
    [self saveDocument];
    

}
-(void)saveDocument
{
     [DocumentManager saveDocument:self.document];
}



-(void) updateUI:(NSNotification *)documentSaved
{
    [self.document.managedObjectContext reset]; //This updates the UI properly if the import Notification is not empty
    [self fetchNotes];
    [self.collectionView reloadData];
    NSLog(@"UI updated");
}



-(void) documentStateChanged:(NSNotification *)notification
{
    if (self.document.documentState == UIDocumentStateNormal) {
        NSLog(@"###ManagedDocument state is Open/Normal!");
        //[self moveDocumentToCloud];
        [self fetchNotes];
        [self.collectionView reloadData];
    }
    else NSLog(@"-(void) documentStateChanged:(NSNotification *)notification %@", notification);    
    if (self.document.documentState & UIDocumentStateInConflict) {
            // look at the changes in notification's userInfo and resolve conflicts
            //   or just take the latest version (by doing nothing)
            // in any case (even if you do nothing and take latest version),
            //   mark all old versions resolved ...
        NSLog(@"DocumentStateinConflict");
            NSArray *conflictingVersions = [NSFileVersion unresolvedConflictVersionsOfItemAtURL:self.document.fileURL];
            for (NSFileVersion *version in conflictingVersions) {
                version.resolved = YES;
            }
            // ... and remove the old version files in a separate thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
                NSError *error;
                [coordinator coordinateWritingItemAtURL:self.document.fileURL options:NSFileCoordinatorWritingForDeleting error:&error byAccessor:^(NSURL *newURL) {
                    [NSFileVersion removeOtherVersionsOfItemAtURL:self.document.fileURL error:NULL];
                }];
                if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription, error.localizedFailureReason);
            });
        NSLog (@"Removing the old version files in a separate thread");
        } else if (self.document.documentState & UIDocumentStateSavingError) {
            // try again?
            NSLog(@"Unable to save document, saving error trying again ...");
            [self saveDocument];
            
    }
}




-(void) applicationIsActiveAgain:(NSNotification *) notification
{
    [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDocumentStateChangedNotification object:self.document];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                  object:self.document.managedObjectContext.persistentStoreCoordinator];
}


- (void)processQueryUpdates:(NSNotification *)notification
{
[self.iCloudQuery disableUpdates];
    NSLog(@"%@", [notification description]);
int resultCount = [self.iCloudQuery resultCount];
for (int i = 0; i < resultCount; i++) {
    NSMetadataItem *item = [self.iCloudQuery resultAtIndex:i];
    NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
    NSLog(@"%@", [url path]);
    // do something with the urls here
    // but remember that these are URLs of the files inside the file wrapper!
    id resourceValue;
    if(![url getResourceValue:&resourceValue forKey:NSURLUbiquitousItemIsDownloadedKey error:nil])
       [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:url error:nil];
     NSLog(@"Started downloading %@", [url path]);
}

    
[self.iCloudQuery enableUpdates];
}

-(void) persistentStoreUpdated:(NSNotification *)notification
{
    NSLog(@"persistenStoreUpdate: %@", notification);
}

-(NSMetadataQuery *) iCloudQuery
{
    if (!_iCloudQuery) {
        _iCloudQuery = [[NSMetadataQuery alloc] init];
        _iCloudQuery.searchScopes = [NSArray arrayWithObjects: NSMetadataQueryUbiquitousDocumentsScope, nil];
        _iCloudQuery.predicate = [NSPredicate predicateWithFormat:@"%K like '*'", NSMetadataItemFSNameKey];// all  ----   @"%K like '*'"
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processQueryUpdates:)
                                                     name:NSMetadataQueryDidFinishGatheringNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processQueryUpdates:)
                                                     name:NSMetadataQueryDidUpdateNotification object:nil];
        
        }
    return _iCloudQuery;
}



-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.iCloudQuery disableUpdates];
    [self.iCloudQuery stopQuery];
}





-(void) managedObjectsDidChange:(NSNotification *)changeNotification
{
    NSLog(@"managedObjectsDidChange:  %@", changeNotification.userInfo);
    
}


-(void) viewDidLoad
{
 [super viewDidLoad];
    
    while (!self.document.managedObjectContext) {
        NSLog(@"Document not ready");
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(documentStateChanged:)
                                                 name:UIDocumentStateChangedNotification
                                               object:self.document];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationIsActiveAgain:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataImported:)
                                                 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                               object:self.document.managedObjectContext.persistentStoreCoordinator];
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(persistentStoreUpdated:)
                                                 name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                               object:self.context.persistentStoreCoordinator];*/
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:self.document.managedObjectContext];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectsDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"MyNotificationDocumentIsSaved" object:self.document];
    
    
    BOOL started = [self.iCloudQuery startQuery];
    if (started)
        NSLog(@"Query started ...");
    [self.iCloudQuery enableUpdates];
    
 

    
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.actionSheet.delegate  = self;
  self.trashButton.enabled = NO;
  [self.document.managedObjectContext setStalenessInterval:0.0];
  [self.document.managedObjectContext setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
 
}


-(void) moveDocumentToCloud
{
    // DETTA LYCKADES EFTER STEGVIS GENOMGÅNG !!!
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *ubiquityURL = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        NSURL *localURL = self.document.fileURL; // url of document to transfer to iCloud
        NSString *name = [localURL lastPathComponent];
        NSURL *iCloudURL = [ubiquityURL URLByAppendingPathComponent:name];
        //NSError *error = nil;
        
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


/*-(void) managedObjectContextDidSave:(NSNotification *)saveNotification
 {
 NSManagedObjectContext *context = [saveNotification object];
 [context performBlock:^{
 // merging changes causes the fetched results controller to update its results
 NSError *error = nil;
 
 [self fetchNotes]; //doing fetch cancels import somehow
 NSLog(@"NSManagedObjectContextDidSaveNotification %@", [error userInfo]);
 
 [self.collectionView reloadData];
 }];
 
 
 }*/


@end
