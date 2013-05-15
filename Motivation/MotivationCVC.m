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
#import "ShakeLayout.h"


@interface MotivationCVC ()

@property (nonatomic, strong) NSArray *arrayOfNotesFromCoreData;
@property (nonatomic, strong) Colors *color;
@property BOOL userRequestedChange;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *changeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *composeBarButton;
@property (strong, nonatomic) ShakeLayout* myLayout;
@property (strong, nonatomic) NSNumber *cellsAreJiggling;
@property (strong, nonatomic) NSMutableArray *tempArray;


@property BOOL noteInserted;
@end



@implementation MotivationCVC



-(NSMutableArray *) tempArray
{
    if (_tempArray) {
        _tempArray = [[NSMutableArray alloc] init];
    }
    return _tempArray;
}

#pragma mark  ------------------ delegate methodes collection view -------------------------------

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize sizeOfCell = CGSizeZero;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
         sizeOfCell = CGSizeMake(168, 125); //168,125
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        sizeOfCell = CGSizeMake(190, 150);
    }
   
    return sizeOfCell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50.0, 50.0, 50.0, 30.0);
}

-(ShakeLayout *)myLayout
{
    if (!_myLayout) {
        _myLayout = [[ShakeLayout alloc] init];
    }
    return _myLayout;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.userRequestedChange){
        [self performSegueWithIdentifier:@"setNote:" sender:indexPath];
    }
    else if (self.userRequestedChange)
    {
        [self.motivationCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
       
    }

}


-(void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.trashButton.enabled)
    {
        //NoteCell *cell = ((NoteCell *)[self.motivationCollectionView cellForItemAtIndexPath:indexPath]);
        //[self.motivationCollectionView restoreNoteCell:indexPath];
    }
}


-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.trashButton.enabled)
  {
//    NoteCell *cell = ((NoteCell *)[self.motivationCollectionView cellForItemAtIndexPath:indexPath]);
//    [cell enlargeCell:YES];
      
  }
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayOfNotesFromCoreData count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Note Cell" forIndexPath:indexPath];
    
    [self updateCell:cell usingNote:self.arrayOfNotesFromCoreData[indexPath.item]];
    return cell;
}

-(void) updateCell:(UICollectionViewCell *) cell usingNote:(Note *) note
{
    if ([cell isKindOfClass:[NoteCell class]]) {
        NoteCell *noteCell = (NoteCell *)cell;
        
        [noteCell setJigglingEnabled:self.cellsAreJiggling];

        noteCell.label.text = note.text;
        noteCell.label.textColor = [UIColor darkTextColor];
        [noteCell.label setImage:[self.color.noteImages objectForKey:note.color]];
        [noteCell.label setFontName:[Settings retrieveFromUserDefaults:@"font_preference"]];
        [noteCell setSelected:NO]; ///???
    
    }

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
    NSArray *selectedItems =  [self.motivationCollectionView indexPathsForSelectedItems];
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
            [self.motivationCollectionView deleteItemsAtIndexPaths:selectedItems];
            
            self.changeButton.tintColor = nil;
            self.motivationCollectionView.allowsMultipleSelection = NO;
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

    
    if (!self.trashButton.enabled) {
        sender.tintColor = [UIColor blueColor];
        self.motivationCollectionView.allowsMultipleSelection = YES;
        self.trashButton.enabled = YES;
        self.composeBarButton.enabled = NO;
        [self.motivationCollectionView.visibleCells makeObjectsPerformSelector:@selector(setJigglingEnabled:) withObject:[NSNumber numberWithBool:YES]];
        [self setCellsAreJiggling:[NSNumber numberWithBool:YES]];
        [self.motivationCollectionView addLongPressGestureRecognizer];
       
    } else if(self.trashButton.enabled) {
        [self.composeBarButton setEnabled:YES];
        sender.tintColor = nil;
        self.motivationCollectionView.allowsMultipleSelection = NO;
        self.trashButton.enabled = NO;
        [self setCellsAreJiggling:[NSNumber numberWithBool:NO]];
        
        [self.motivationCollectionView.visibleCells makeObjectsPerformSelector:@selector(setJigglingEnabled:) withObject:[NSNumber numberWithBool:NO]];
        
        [self.motivationCollectionView removeLongPressGestureRecognizer];

        
    }
}




-(void )userWillChangeLayout:(NSNotification *) pointDictionary
{
      CGPoint currentPoint = CGPointFromString([pointDictionary.userInfo valueForKey:@"CurrentCGPointValueString"]);
      NSIndexPath *indexToMoveFrom =           [pointDictionary.userInfo valueForKey:@"IndexToMoveFrom"];
      
      NSIndexPath *newLocation = [self.motivationCollectionView indexPathForItemAtPoint:currentPoint];
      
      if (newLocation)
      {
          NSMutableArray *dataModel = [[NSMutableArray alloc] initWithArray:self.arrayOfNotesFromCoreData];
          Note *noteToMove = (Note *)[self.arrayOfNotesFromCoreData objectAtIndex:indexToMoveFrom.item];
          
          [dataModel removeObjectAtIndex:indexToMoveFrom.item];
          [dataModel insertObject:noteToMove atIndex:newLocation.item];
          
          self.arrayOfNotesFromCoreData = [dataModel copy];
          [self.motivationCollectionView moveItemAtIndexPath:indexToMoveFrom toIndexPath:newLocation];
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





-(NSArray *) arrayOfNotesFromCoreData
{
    if (!_arrayOfNotesFromCoreData)
    {
        _arrayOfNotesFromCoreData = [[NSArray alloc] init];
    }
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
//    [self.document.managedObjectContext performBlock:^{
//    [self.document.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];}];
    
    // possible solution
    // if notification.userInfo is empty, send back a message and try to create again!
    /*{
	    deleted = "{(\n)}";
	    inserted = "{(\n)}";
	    updated = "{(\n)}";
	}*/
    [self.document.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
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
        NSArray *fetch = [self.document.managedObjectContext executeFetchRequest:request error:&error];
        self.arrayOfNotesFromCoreData = fetch;
        //NSLog(@"%@", self.arrayOfNotesFromCoreData);
        
    }
   return error; 
}


-(IBAction) dismissNote:(UIStoryboardSegue *) sender
{
    [self fetchNotes];
    [self.motivationCollectionView reloadData];
   
    }


-(void) saveNote:(UIViewController *)sender
{
    if ([sender isKindOfClass:[ShowNoteViewController class]]) {
        ShowNoteViewController *noteVC = (ShowNoteViewController *)sender;
        //if (![noteVC.changedText isEqualToString:noteVC.note.text]) { WILL ALWAYS UPDATE TEXT - WORKS
            noteVC.note.text = noteVC.changedText;
            //[self updateVisibleCells];
            }
        else if([sender isKindOfClass:[NewNoteViewController class]])
        {
    
            NewNoteViewController *newNote = (NewNoteViewController *)sender;
            
            if (newNote.typedText) {
            [Note noteWithContent:newNote.typedText
                        color:newNote.colorKey
                     archived:[NSNumber numberWithBool:NO]
           inManagedObjectContext:self.document.managedObjectContext];
            
                [self setNoteInserted:YES];
            }
      }
[self saveDocument]; //should generate notification "MyNotificationDocumentSaved" and update UI
}
-(void)saveDocument
{
    [DocumentManager saveDocument:self.document];
}



-(void) updateUI:(NSNotification *)documentSaved
{
    [self fetchNotes];
    
    if (self.noteInserted) {
        NSArray *noteOnTop = [NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]];
        [self.motivationCollectionView insertItemsAtIndexPaths:noteOnTop];
        [self setNoteInserted:NO];
        //inserted localy
        [self updateVisibleCells];
    } else
    {
        //data from ubiquity
        [self.motivationCollectionView reloadData];
        //[self performSelector:@selector(shakeCells) withObject:nil afterDelay:1.0];
    }
    
    NSLog(@"UI updated");
    
}

-(void)updateVisibleCells
{
    for (id cell in [self.motivationCollectionView visibleCells]) {
        
         NSIndexPath *path = [self.motivationCollectionView indexPathForCell:cell];
        [self updateCell:cell usingNote:self.arrayOfNotesFromCoreData[path.item]];
    }
    
}




-(void) applicationIsActiveAgain:(NSNotification *) notification
{
    [self performSelector:@selector(updateUI:) withObject:nil afterDelay:1];
}



-(void) shakeCells
{
    //[0,-1, 0] rotation around Y axis (left to rigth)
    //[0, 0,-1] rotation around Z (clockwise) etc ,,,
    // [1,1,0] diagonal
    CATransform3D rightDown = CATransform3DMakeRotation(M_PI, 0, -1, 0);
     //CATransform3D leftDown = CATransform3DMakeRotation(M_PI, 0, 0, 0);
    [self.myLayout setShake:YES];
    
    
    [self.motivationCollectionView performBatchUpdates:^{
        
        [self.myLayout setTransform3D:rightDown];
    } completion:^(BOOL finished){
        [self.motivationCollectionView performBatchUpdates:^{
            
           [self.myLayout setTransform3D:CATransform3DIdentity];
            
        } completion:^(BOOL finished){
            
            [self.myLayout setShake:NO];
            [self.myLayout invalidateLayout];
        }];
    
    }];
    //[self.myLayout invalidateLayout];
    //[self.collectionView visibleCells];
    //[self.myLayout performSelector:@selector(setShake:) withObject:NO afterDelay:1];
    
  //[self.myLayout setShake:NO];
   // [self.collectionView reloadData];
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI:)
                                                 name:@"MyNotificationDocumentIsSaved"
                                               object:self.document];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWillChangeLayout:) name:@"UserWillChangeLayout" object:self.motivationCollectionView];
    
    
    BOOL started = [self.iCloudQuery startQuery];
    if (started)
        NSLog(@"Query started ...");
    [self.iCloudQuery enableUpdates];
    


  [self.motivationCollectionView setCollectionViewLayout:self.myLayout];
  self.motivationCollectionView.dataSource = self;
  self.motivationCollectionView.delegate = self;
  [self setCellsAreJiggling:[NSNumber numberWithBool:NO]];
  self.actionSheet.delegate  = self;
  self.trashButton.enabled = NO;
  
  [self.document.managedObjectContext setStalenessInterval:0.0];
    
}

-(void) panGestureDiscovered
{
    if (self.userRequestedChange) {
        NSLog(@"Pan");
    }
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

-(Colors *) color
{
    if (!_color) {
        _color = [[Colors alloc] init];
    }
    return _color;
}


-(void) documentStateChanged:(NSNotification *)notification
{
    if (self.document.documentState == UIDocumentStateNormal) {
        NSLog(@"###ManagedDocument state is Open/Normal!");
        //[self moveDocumentToCloud];
        [self fetchNotes];
        [self.motivationCollectionView reloadData];
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


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDocumentStateChangedNotification object:self.document];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                                  object:self.document.managedObjectContext.persistentStoreCoordinator];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"MyNotificationDocumentIsSaved"
                                                  object:self.document];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserWillChangeLayout" object:self.motivationCollectionView];
}




@end
