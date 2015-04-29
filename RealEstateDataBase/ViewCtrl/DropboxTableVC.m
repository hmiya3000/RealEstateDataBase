//
//  DropboxTableVC.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/13.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "DropboxTableVC.h"
#import "DropboxEditorViewCtrl.h"
#import "MBProgressHUD.h"

@interface DropboxTableVC ()

@end

@implementation DropboxTableVC
#if 0
@synthesize filesArray      = _filesArray;

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self) {
        _filesArray = @[];
    }
    return self;
}


/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    UIBarButtonItem *linkButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Link"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(linkButtonTapped:)];
    self.navigationItem.leftBarButtonItem = linkButton;

    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(addButtonTapped:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self updateData];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidAppear:(BOOL)animated {
    [self updateData];
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
//    return _db.list.count;
    return _filesArray.count;
}

/****************************************************************
 *
 ****************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 0
    UITableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"table_cell"];
    if ( cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table_cell"];
    }
#if 0
    NSDictionary   *record = [_db.list objectAtIndex:indexPath.row];
    [cell.textLabel setText:[record objectForKey:@"name"]];
#endif
    [cell.textLabel setText:@"aaaaa"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
#endif

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
    DropboxEditorViewCtrl *editorVC = [[DropboxEditorViewCtrl alloc]initWithNibName:nil bundle:nil];
    editorVC.dropboxPath = [[DBPath root] childPath:[_filesArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:editorVC animated:YES];
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
    return YES;
}

/****************************************************************
 *
 ****************************************************************/
- (IBAction)linkButtonTapped:(id)sender
{
    [[DBAccountManager sharedManager] linkFromController:self];
}


/****************************************************************
 *
 ****************************************************************/
- (void)updateData
{
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
            [tmpArray addObject:info.path.name];
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
}

/****************************************************************
 *
 ****************************************************************/
- (IBAction)addButtonTapped:(id)sender
{
    // create file
    [self createFile:[self uniqueNameStartWith:@"newText" endWith:@".txt" among:_filesArray]];
    [self updateData];
}

/****************************************************************
 *
 ****************************************************************/
#pragma mark -
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

/****************************************************************
 *
 ****************************************************************/
- (BOOL)createFile:(NSString*)filename
{
    NSError *error;
    DBPath *newPath = [[DBPath root] childPath:filename];
    DBFile *file = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
    return [file writeString:@"" error:&error];
}

/****************************************************************
 *
 ****************************************************************/
- (void)deleteFile:(NSString*)filename {
    //NSFileManager* fileManager = [NSFileManager defaultManager];
    //NSString *path = [self.currentDirectory stringByAppendingPathComponent:filename];
    NSError *error;
    //[fileManager removeItemAtPath:path error:&error];
    DBPath *path = [[DBPath root] childPath:filename];
    [[DBFilesystem sharedFilesystem] deletePath:path error:&error];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#endif
@end
