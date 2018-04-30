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
#if 0
    DBRestClient    *_restClient;
#else
    DBUserClient    *_userClient;
#endif
    NSArray        *_metaArray;
}

@end

@implementation ImportViewCtrl
@synthesize filesArray      = _filesArray;
@synthesize path            = _path;

//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self) {
        _filesArray = @[];
        self.title  = @"インポート";
    }
    return self;
}


//======================================================================
//
//======================================================================
-(void)viewDidLoad
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
#if 0
    _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    _restClient.delegate = self;
#else
    // 個人用アカウントの認証状態を確認
    if (!DBClientsManager.authorizedClient && !DBClientsManager.authorizedTeamClient){
        [self auth];
    }
    //    _userClient = [DBClientsManager authorizedClient];
#endif
}
//======================================================================
- (void)auth{
    [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                   controller:[[self class] topMostController]
                                      openURL:^(NSURL *url) {
#if 0 //OS10
                                          [UIApplication.sharedApplication openURL:url
                                                                           options:@{}
                                                                 completionHandler:nil];
#else
                                          [UIApplication.sharedApplication openURL:url];
#endif
                                      }];
}
//======================================================================
+ (UIViewController*)topMostController {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}
//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#if 0
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
#else
#if 0
    if (!DBClientsManager.authorizedClient && !DBClientsManager.authorizedTeamClient){
        [DBClientsManager authorizeFromController:UIApplication.sharedApplication
                                       controller:self
                                          openURL:^(NSURL *url){
                                            [UIApplication.sharedApplication openURL:url
                                                                             options:@{}
                                                                   completionHandler:nil];
                                          }
         ];
    }
#endif
#endif
    _userClient = [DBClientsManager authorizedClient];
    [self updateData];
    return;
}

//======================================================================
//
//======================================================================
-(void)viewDidAppear:(BOOL)animated
{
}

//======================================================================
//
//======================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//======================================================================
//
//======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filesArray.count;
}

//======================================================================
//
//======================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.textLabel.text = [_filesArray objectAtIndex:indexPath.row];
    return cell;
}

//======================================================================
//
//======================================================================
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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


//======================================================================
//
//======================================================================
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#if 0
    NSString *filename      = [_filesArray objectAtIndex:indexPath.row];
    NSString *dropboxPath = @"/";
    dropboxPath = [dropboxPath stringByAppendingPathComponent:filename];
    
    NSArray  *path          = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *localPath     = [documentsDirectory stringByAppendingPathComponent:filename];
    [_restClient loadFile:dropboxPath intoPath:localPath];
#else
    NSString *webPath = [_metaArray objectAtIndex:indexPath.row];
    NSString *filename = [_filesArray objectAtIndex:indexPath.row];

    NSArray  *path          = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *localPath     = [documentsDirectory stringByAppendingPathComponent:filename];
    [self downloadFilePath:localPath webPath:webPath];
#endif
    return;
}
//======================================================================
- (void)downloadFilePath:(NSString *)localPath webPath:(NSString*)webPath
{
    DBUserClient *userClient = DBClientsManager.authorizedClient;
    NSURL *destURL = [NSURL fileURLWithPath:localPath];
    
    DBDownloadUrlTask *task = [userClient.filesRoutes downloadUrl:webPath
                                                        overwrite:YES
                                                      destination:destURL];
    
    
    [task setResponseBlock:^(id  _Nullable result, id  _Nullable routeError, DBRequestError * _Nullable networkError, NSURL * _Nonnull destination){
        if(routeError || networkError){
            // 失敗
//            NSLog(@"There was an error loading the file: %@", error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return;
        }
        // 成功
        NSError *error;
        NSString *contents = [[NSString alloc] initWithContentsOfFile:localPath encoding:NSShiftJISStringEncoding error:&error];
        
        [_modelDB importData:contents];
        // ファイルマネージャを作成
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL result2 = [fileManager removeItemAtPath:localPath error:&error];
        if (result2) {
            NSLog(@"削除成功：%@", localPath);
        } else {
            NSLog(@"削除失敗：%@", error.description);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];

    } queue:[NSOperationQueue mainQueue]];
    [task start];
}


//======================================================================
//
//======================================================================
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//======================================================================
//
//======================================================================
- (IBAction)updateButtonTapped:(id)sender
{
    [self updateData];
}

//======================================================================
//
//======================================================================
-(void)updateData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
#if 0
    [_restClient loadMetadata:@"/"];
#else
    self.path = @"";
    [self loadDirMetadataWithClient:_userClient cursor:nil];
#endif
}

//======================================================================
- (void)loadDirMetadataWithClient:(DBUserClient *)client cursor:(NSString *)cursor
{
    DBRpcTask *task = [client.filesRoutes listFolder:self.path];

    if(cursor)
        task = [client.filesRoutes listFolderContinue:cursor];

    [task setResponseBlock:^(id result, id routeError, DBRequestError *netError){
        if(routeError || netError){
            // 失敗
            NSLog(@"取得失敗");
            return;
        }
    
        DBFILESListFolderResult *folderResult = result;
        NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithCapacity:10];
        NSMutableArray *tmpArray2 = [[NSMutableArray alloc]initWithCapacity:10];
        for(DBFILESMetadata *childMeta in folderResult.entries){
            // 子のメタデータを一覧できる
            if([childMeta isKindOfClass:DBFILESFileMetadata.class]){
                if ( [childMeta.name hasSuffix:@".csv"] || [childMeta.name hasSuffix:@".CSV"]){
                    [tmpArray addObject:childMeta.name];
                    [tmpArray2 addObject:childMeta.pathLower];
                }
            }
        }
        _filesArray = [NSArray arrayWithArray:tmpArray];
        _metaArray  = [NSArray arrayWithArray:tmpArray2];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

#if 0
        if(folderResult.hasMore.boolValue){
            // まだ子がいる場合は再帰的に読み込む
            [self loadDirMetadataWithClient:client cursor:folderResult.cursor];
        }else{
            // 読み込み完了
        }
#endif
    }];
    [task start];
}
#if 0
-(void)loadedFile:(NSString *)localPath
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
#endif
//======================================================================
// DropBox上のファイルリストのロード成功
//======================================================================
#if 0
-(void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
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

//======================================================================
// DropBox上のファイルリストのロード失敗
//======================================================================
-(void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    NSLog(@"Error loading metadata: %@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//======================================================================
// DropBox上のファイルのローカルへのロード成功
//======================================================================
-(void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
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
#endif

//======================================================================
// DropBox上のファイルのローカルへのロード失敗
//======================================================================
#if 0
-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    NSLog(@"There was an error loading the file: %@", error);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#endif
//======================================================================
//
//======================================================================
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//======================================================================
//
//======================================================================
- (IBAction)accountButtonTapped:(id)sender
{
//    [[DBSession sharedSession] linkFromController:self];
    return;
}

//======================================================================
//
//======================================================================
-(void)deleteFile:(NSString*)filename
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

//======================================================================
@end
//======================================================================
