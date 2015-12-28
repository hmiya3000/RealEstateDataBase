//
//  ImportViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/18.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "ImportViewCtrl.h"
#import "MBProgressHUD.h"
#import "ModelDB.h"

@interface ImportViewCtrl ()
{
    ModelDB         *_modelDB;
    DBRestClient    *_restClient;
}

@end

@implementation ImportViewCtrl
@synthesize filesArray      = _filesArray;

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self) {
        _filesArray = @[];
        self.title  = @"インポート";
    }
    return self;
}


/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    _modelDB = [ModelDB sharedManager];

    UIBarButtonItem *retButton =
    [[UIBarButtonItem alloc] initWithTitle:@"戻る"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(retButtonTapped:)];
    self.navigationItem.leftBarButtonItem = retButton;

    UIBarButtonItem *updateButton =
    [[UIBarButtonItem alloc] initWithTitle:@"更新"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(updateButtonTapped:)];

    UIBarButtonItem *accountButton =
    [[UIBarButtonItem alloc] initWithTitle:@"アカウント"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(accountButtonTapped:)];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: accountButton,updateButton, nil];
    
    _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    _restClient.delegate = self;
    
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    [self updateData];
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidAppear:(BOOL)animated
{
}

/****************************************************************
 *
 ****************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/****************************************************************
 *
 ****************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filesArray.count;
}

/****************************************************************
 *
 ****************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = [_filesArray objectAtIndex:indexPath.row];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/****************************************************************
 *
 ****************************************************************/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete時の処理をここに書く
        // 先にデータソースを削除する
        //        [_db deleteIndex:indexPath.row];
        
        // UITableViewの行を削除する
        [self deleteFile:[_filesArray objectAtIndex:indexPath.row]];
        [self updateData];
        
        //        if (_db.list.count == 0 ){
        //            [self clrEditing];      /* 編集モードを戻す */
        //            _inputVC = [[InputItemViewCtrl alloc]init];
        //            [self presentViewController:_inputVC animated:NO completion:nil];
        //        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        // Insert時の処理をここに書く
    }
}


/****************************************************************
 *
 ****************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *filename      = [_filesArray objectAtIndex:indexPath.row];
    NSString *dropboxPath = @"/";
    dropboxPath = [dropboxPath stringByAppendingPathComponent:filename];
    
    NSArray  *path          = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *localPath     = [documentsDirectory stringByAppendingPathComponent:filename];

    [_restClient loadFile:dropboxPath intoPath:localPath];

#if 0
    DBPath* dropboxPath  = [[DBPath root] childPath:[_filesArray objectAtIndex:indexPath.row]];

    // completedFirstSyncがfalseの間はreadString:が待ちになる。これはファイルごと１回だけ発生します。
    // readString:をメインスレッドで実行すると警告が出ます
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DBError *error;
        DBFile *file = [[DBFilesystem sharedFilesystem] openFile:dropboxPath error:&error];
        // 待ちが発生する場合はprogress dialogを表示（メインスレッド）
        if ([file status] && !(file.status.cached)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
        }
        NSString *contents = [file readString:nil];
        // 読み込み完了後の画面表示
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [_modelDB importData:contents];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });
#endif
    return;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/****************************************************************
 *
 ****************************************************************/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

/****************************************************************
 *
 ****************************************************************/
- (IBAction)updateButtonTapped:(id)sender
{
    [self updateData];
}

/****************************************************************
 *
 ****************************************************************/
- (void)updateData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_restClient loadMetadata:@"/"];
    
#if 0
    // completedFirstSyncがfalseの間はlistFolder:が待ちになる。これはログイン後の１回だけ発生します。
    // listFolder:をメインスレッドで実行すると警告が出ます
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 待ちが発生する場合はprogress dialogを表示（メインスレッド）
        if ([DBFilesystem sharedFilesystem] && ![[DBFilesystem sharedFilesystem] completedFirstSync]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
        }
        // listを読み込み
        NSError *error;
        DBPath *path = [DBPath root];
        NSArray *dbArray = [[DBFilesystem sharedFilesystem] listFolder:path error:&error];
        NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithCapacity:[dbArray count]];
        for (DBFileInfo *info in dbArray) {
            if ( [info.path.name hasSuffix:@".csv"] == true
                || [info.path.name hasSuffix:@".CSV"] == true ){
                [tmpArray addObject:info.path.name];
            }
        }
        _filesArray = [NSArray arrayWithArray:tmpArray];
        NSLog(@"files:%@",[_filesArray description]);
        // progress dialogを非表示
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        // tableViewを更新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
#endif
}

/****************************************************************
 * DropBox上のファイルリストのロード成功
 ****************************************************************/
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    if (metadata.isDirectory) {

        // listを読み込み
        NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithCapacity:(NSInteger)metadata.contents];
        for (DBMetadata *file in metadata.contents) {
            if ( [file.filename hasSuffix:@".csv"] == true
                || [file.filename hasSuffix:@".CSV"] == true ){
                [tmpArray addObject:file.filename];
            }
        }
        _filesArray = [NSArray arrayWithArray:tmpArray];
        [self.tableView reloadData];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/****************************************************************
 * DropBox上のファイルリストのロード失敗
 ****************************************************************/
- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    NSLog(@"Error loading metadata: %@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/****************************************************************
 * DropBox上のファイルのローカルへのロード成功
 ****************************************************************/
- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata
{
    NSLog(@"File loaded into path: %@", localPath);

    NSError *error;
    NSString *contents = [[NSString alloc] initWithContentsOfFile:localPath encoding:NSShiftJISStringEncoding error:&error];
    
    [_modelDB importData:contents];

    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager removeItemAtPath:localPath error:&error];
    
    if (result) {
        NSLog(@"削除成功：%@", localPath);
    } else {
        NSLog(@"削除失敗：%@", error.description);
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];

}

/****************************************************************
 * DropBox上のファイルのローカルへのロード失敗
 ****************************************************************/
- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    NSLog(@"There was an error loading the file: %@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

/****************************************************************
 *
 ****************************************************************/
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/****************************************************************
 *
 ****************************************************************/
- (IBAction)accountButtonTapped:(id)sender
{
    [[DBSession sharedSession] linkFromController:self];
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)deleteFile:(NSString*)filename
{
    //NSFileManager* fileManager = [NSFileManager defaultManager];
    //NSString *path = [self.currentDirectory stringByAppendingPathComponent:filename];
#if 0
    NSError *error;
    //[fileManager removeItemAtPath:path error:&error];
    DBPath *path = [[DBPath root] childPath:filename];
    [[DBFilesystem sharedFilesystem] deletePath:path error:&error];
#endif
}


#if 0
/****************************************************************
 *
 ****************************************************************/
- (NSString *)uniqueNameStartWith:(NSString*)prefix endWith:(NSString*)suffix among:(NSArray*)names
{
    for (int i=0; i<INT_MAX; i++) {
        NSString *uniqueName = (i==0) ? [NSString stringWithFormat:@"%@%@",prefix,suffix] :
        [NSString stringWithFormat:@"%@(%d)%@",prefix,i,suffix];
        if (![names containsObject:uniqueName]) {
            return uniqueName;
        }
    }
    return nil;
}
#endif

/****************************************************************/
@end
/****************************************************************/
