//
//  DataBaseTableViewCtrl.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/19.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "DataBaseTableViewCtrl.h"
#import "InfoViewCtrl.h"
#import "InputItemViewCtrl.h"
#import "ItemIPhoneViewCtrl.h"
#import "Pos.h"
#import "ModelDB.h"

@interface DataBaseTableViewCtrl ()
{
    UITabBarController          *_tbc;

    UIViewController            *_inputVC;          /* 物件名入力VC */
    UIViewController            *_infoVC;           /* バージョン情報VC */

    
    UISplitViewController       *_spVc;
    Pos                     *_pos;
    
    ModelDB                 *_db;
    
    NSIndexPath             *_selIndexPath;
    BOOL                    _selIndex;

    
}

@end

@implementation DataBaseTableViewCtrl
@synthesize detailVC    = _detailVC;
/****************************************************************
 * 初期化
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        _db = [ModelDB sharedManager];
        self.title = @"物件リスト";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        _selIndex = false;
        
        NSString *model = [UIDevice currentDevice].model;
        if ([model isEqualToString:@"iPad"] ){
            if ( _db.list.count > 0 ){
                _selIndex       = true;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                [self selectCell:indexPath];
            }
        }
    }
    return self;

}

/****************************************************************
 * セルの選択時で、次のビューを開く
 ****************************************************************/
- (void)selectCell:(NSIndexPath*)indexPath
{
    [self clrEditing];      /* 編集モードを戻す */
    [_db loadIndex:indexPath.row];        /* ロードしてからview作成 */
    
    NSString *model = [UIDevice currentDevice].model;
    if ( [model isEqualToString:@"iPhone"] ){
        _tbc = [[ItemIPhoneViewCtrl alloc]init];
        _tbc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _tbc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _tbc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:_tbc animated:YES completion:nil];

    } else if ([model isEqualToString:@"iPad"] ){
        // Detail Viewを更新
        _selIndex       = true;
        _selIndexPath   = indexPath;
        [self.detailVC viewWillAppear:YES];
        
    }
    return;
}

/****************************************************************
 * ビューのロード
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc] initWithTitle:@"新規"
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(inputItem)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"編集"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(didTapEditButton)];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    [table setDelegate:self];
    [table setDataSource:self];

    [self viewMake];


}

/****************************************************************
 * ビューの作成
 ****************************************************************/
- (void)viewMake
{
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,lengthR;
    _pos = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    /****************************************/
    pos_y   = _pos.y_top;
    [self.tableView setFrame:CGRectMake(0, 0, 320, 480)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|
                                UIViewAutoresizingFlexibleTopMargin|
                                UIViewAutoresizingFlexibleLeftMargin|
                                UIViewAutoresizingFlexibleBottomMargin|
                                UIViewAutoresizingFlexibleWidth|
                                UIViewAutoresizingFlexibleHeight;
     
    
}

/****************************************************************
 * ビューの表示直前に呼ばれる
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    if ( _db.list.count == 0 ){
        [self inputItem];
    }
    if ( _selIndex == true ){
        [self.tableView selectRowAtIndexPath:_selIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return;
}
#pragma mark - Table view data source
/****************************************************************
 * セルの大きさ設定
 ****************************************************************/
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

/****************************************************************
 * セクション数の設定
 ****************************************************************/
- (NSInteger)numberOfRowsInSection:(UITableView *)tableView
{
    return 1;
}

/****************************************************************
 * セクション数の設定
 ****************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/****************************************************************
 * セルの選択時に呼ばれる
 ****************************************************************/
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *model = [UIDevice currentDevice].model;
    if ( [model isEqualToString:@"iPhone"] ){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self selectCell:indexPath];
}

/****************************************************************
 * セル数取得時に呼ばれる
 ****************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _db.list.count;
}

/****************************************************************
 * セル数取得時に呼ばれる
 ****************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"table_cell"];
    if ( cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table_cell"];
    }
    NSDictionary   *record = [_db.list objectAtIndex:indexPath.row];
    [cell.textLabel setText:[record objectForKey:@"name"]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
/****************************************************************
 * 編集を実行すると呼ばれる
 ****************************************************************/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete時の処理をここに書く
        // 先にデータソースを削除する
        [_db deleteIndex:indexPath.row];

        // UITableViewの行を削除する
        NSArray *deleteArray = [NSArray arrayWithObject:indexPath];
        [tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (_db.list.count == 0 ){
            [self clrEditing];      /* 編集モードを戻す */
            _inputVC = [[InputItemViewCtrl alloc]init];
            [self presentViewController:_inputVC animated:NO completion:nil];
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        // Insert時の処理をここに書く
    }
}

/****************************************************************
 * レコードの移動
 ****************************************************************/
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.row < _db.list.count) {
        [_db moveIndex:fromIndexPath.row ToIndex:toIndexPath.row];
    }
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

/****************************************************************
 * 編集モードを戻す
 ****************************************************************/
- (void)clrEditing
{
    self.editing = NO;
    self.navigationItem.rightBarButtonItem.title = @"編集";
}

/****************************************************************
 * 編集ボタン
 ****************************************************************/
- (void)didTapEditButton
{
    [self setEditing:!self.editing animated:YES];
    if (self.editing) {
        self.navigationItem.rightBarButtonItem.title = @"戻る";
    } else {
        self.navigationItem.rightBarButtonItem.title = @"編集";
    }
    return;
    
}

/****************************************************************
 *
 ****************************************************************/
- (void)inputItem
{
    [self clrEditing];      /* 編集モードを戻す */
    _inputVC    = [[InputItemViewCtrl alloc]init];
    _infoVC     = [[InfoViewCtrl alloc]init];

    _tbc = [[UITabBarController alloc]init];
    NSArray *views = [NSArray arrayWithObjects:_inputVC,_infoVC,nil];
    [_tbc setViewControllers:views animated:YES];
    
    _tbc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:_tbc animated:YES completion:nil];

    
//    [self presentViewController:_inputVC animated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
