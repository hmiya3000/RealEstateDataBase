//
//  ItemSettingViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/12/30.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "ItemSettingViewCtrl.h"
#import "ModelRE.h"
#import "Pos.h"
#import "AddonMgr.h"
#import "ViewMgr.h"

#import "ItemIPadViewCtrl.h"



@interface ItemSettingViewCtrl ()
{
    ModelRE                     *_modelRE;
    NSArray                     *_sectionList;
    NSDictionary                *_dataSource;
    
    UIViewController            *_infoVC;           /* バージョン情報VC */
    
    
    UISplitViewController       *_spVc;
    
    
    NSArray                     *_settingList0;
    NSArray                     *_settingList1;
    NSArray                     *_settingList2;
    NSArray                     *_settingList3;
    NSArray                     *_settingList4;
    NSArray                     *_settingList5;
    NSArray                     *_settingList6;
    Pos                         *_pos;
    AddonMgr                    *_addonMgr;
}
@end

/****************************************************************/
@implementation ItemSettingViewCtrl
/****************************************************************/
@synthesize masterVC    = _masterVC;
/****************************************************************/


/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title  = @"物件情報";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        [self initSettingList];
    }
    return self;
}
/****************************************************************
 * セルの選択時で、次のビューを開く
 ****************************************************************/
- (void)selectCell:(NSIndexPath*)indexPath
{
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *selectButton =
    [[UIBarButtonItem alloc] initWithTitle:@"物件詳細"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(selectButtonTapped:)];
    self.navigationItem.rightBarButtonItem = selectButton;
    
    _modelRE    = [ModelRE sharedManager];
    _addonMgr   = [AddonMgr sharedManager];
    UITableView *settingView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    
    [settingView setDelegate:self];
    [settingView setDataSource:self];
    
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
//    [self.tableView setFrame:CGRectMake(0, 0, 320, 480)];
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
    [self viewMake];
    
}

/****************************************************************
 * セルの大きさ設定
 ****************************************************************/
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

/****************************************************************
 * セクション数の設定
 ****************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( _addonMgr.saleAnalysys == true ){
        if ( _addonMgr.opeSetting == true ){
            return 6+1;
        } else {
            return 5+1;
        }
    } else {
        if ( _addonMgr.opeSetting == true ){
            return 5+1;
        } else {
            return 4+1;
        }
    }
}

/****************************************************************
 * セルの選択時に呼ばれる
 ****************************************************************/
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self selectCell:indexPath];
}

/****************************************************************
 * セル数取得時に呼ばれる
 ****************************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger   count;
    if ( _addonMgr.saleAnalysys == true ){
        if ( _addonMgr.opeSetting == true ){
            switch (section) {
                case 0: count = _settingList0.count;    break;
                case 1: count = _settingList1.count;    break;
                case 2: count = _settingList2.count;    break;
                case 3: count = _settingList3.count;    break;
                case 4: count = _settingList4.count;    break;
                case 5: count = _settingList5.count;    break;
                case 6: count = _settingList6.count;    break;
                default:count = 0;                      break;
            }
        } else {
            switch (section) {
                case 0: count = _settingList0.count;    break;
                case 1: count = _settingList1.count;    break;
                case 2: count = _settingList2.count;    break;
                case 3: count = _settingList3.count;    break;
                case 4: count = _settingList4.count;    break;
                case 5: count = _settingList6.count;    break;
                default:count = 0;                      break;
            }
        }
    } else {
        if ( _addonMgr.opeSetting == true ){
            switch (section) {
                case 0: count = _settingList0.count;    break;
                case 1: count = _settingList1.count;    break;
                case 2: count = _settingList2.count;    break;
                case 3: count = _settingList3.count;    break;
                case 4: count = _settingList4.count;    break;
                case 5: count = _settingList5.count;    break;
                default:count = 0;                      break;
            }
        } else {
            switch (section) {
                case 0: count = _settingList0.count;    break;
                case 1: count = _settingList1.count;    break;
                case 2: count = _settingList2.count;    break;
                case 3: count = _settingList3.count;    break;
                case 4: count = _settingList4.count;    break;
                default:count = 0;                      break;
            }
        }
    }
    return count;
}

/****************************************************************
 *
 ****************************************************************/
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self getSectionName:section];
}
/****************************************************************
 * セル数取得時に呼ばれる
 ****************************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [self.tableView dequeueReusableCellWithIdentifier:@"table_cell"];
    if ( cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"table_cell"];
    }
    
    NSString *key = [self getKeyIndexPath:indexPath];
    [cell.textLabel setText:(NSString*)key];
    [cell.detailTextLabel setText:[_modelRE getString:(NSString*)key]];
    return cell;
}

/****************************************************************
 *
 ****************************************************************/
- (void)initSettingList
{
    _settingList0 = [NSArray arrayWithObjects:
                     @"物件名",
                     @"物件価格",
                     @"表面利回り",
                     nil];
    _settingList1 = [NSArray arrayWithObjects:
                     @"諸費用",
                     @"自己資金",
                     nil];
    _settingList2 = [NSArray arrayWithObjects:
                     @"借入金",
                     @"金利",
                     @"借入期間",
                     nil];
    _settingList3 = [NSArray arrayWithObjects:
                     @"土地価格",
                     @"土地面積",
                     @"住所",
                     @"路線価",
                     nil
                     ];
    _settingList4 = [NSArray arrayWithObjects:
                     @"建物価格",
                     @"床面積",
                     @"構造",
                     @"戸数",
                     @"建築年",
                     nil
                     ];
    _settingList5 = [NSArray arrayWithObjects:
                     @"取得年",
                     @"家賃下落率",
                     @"空室率",
                     @"管理費割合",
                     @"所得税・住民税",
                     nil
                     ];
    _settingList6 = [NSArray arrayWithObjects:
                     @"保有期間",
                     @"売却価格",
                     @"改良費",
                     @"譲渡費用",
                     nil
                     ];
    return;
    
}
/****************************************************************
 *
 ****************************************************************/
- (NSString*) getKeyIndexPath:(NSIndexPath*)indexPath
{
    NSString  *key;
    if ( _addonMgr.saleAnalysys == true ){
        if ( _addonMgr.opeSetting == true ){
            switch (indexPath.section) {
                case 0: key = [_settingList0 objectAtIndex:indexPath.row];  break;
                case 1: key = [_settingList1 objectAtIndex:indexPath.row];  break;
                case 2: key = [_settingList2 objectAtIndex:indexPath.row];  break;
                case 3: key = [_settingList3 objectAtIndex:indexPath.row];  break;
                case 4: key = [_settingList4 objectAtIndex:indexPath.row];  break;
                case 5: key = [_settingList5 objectAtIndex:indexPath.row];  break;
                case 6: key = [_settingList6 objectAtIndex:indexPath.row];  break;
                default:                                                    break;
            }
        } else {
            switch (indexPath.section) {
                case 0: key = [_settingList0 objectAtIndex:indexPath.row];  break;
                case 1: key = [_settingList1 objectAtIndex:indexPath.row];  break;
                case 2: key = [_settingList2 objectAtIndex:indexPath.row];  break;
                case 3: key = [_settingList3 objectAtIndex:indexPath.row];  break;
                case 4: key = [_settingList4 objectAtIndex:indexPath.row];  break;
                case 5: key = [_settingList6 objectAtIndex:indexPath.row];  break;
                default:                                                    break;
            }
        }
    } else {
        if ( _addonMgr.opeSetting == true ){
            switch (indexPath.section) {
                case 0: key = [_settingList0 objectAtIndex:indexPath.row];  break;
                case 1: key = [_settingList1 objectAtIndex:indexPath.row];  break;
                case 2: key = [_settingList2 objectAtIndex:indexPath.row];  break;
                case 3: key = [_settingList3 objectAtIndex:indexPath.row];  break;
                case 4: key = [_settingList4 objectAtIndex:indexPath.row];  break;
                case 5: key = [_settingList5 objectAtIndex:indexPath.row];  break;
                default:                                                    break;
            }
        } else {
            switch (indexPath.section) {
                case 0: key = [_settingList0 objectAtIndex:indexPath.row];  break;
                case 1: key = [_settingList1 objectAtIndex:indexPath.row];  break;
                case 2: key = [_settingList2 objectAtIndex:indexPath.row];  break;
                case 3: key = [_settingList3 objectAtIndex:indexPath.row];  break;
                case 4: key = [_settingList4 objectAtIndex:indexPath.row];  break;
                default:                                                    break;
            }
        }
    }
    return key;
}

/****************************************************************
 *
 ****************************************************************/
- (NSString*) getSectionName:(NSInteger)section
{
    NSString *str;
    if ( _addonMgr.saleAnalysys == true ){
        if ( _addonMgr.opeSetting == true ){
            switch (section) {
                case 0: str = @"基本情報";      break;
                case 1: str = @"資金";         break;
                case 2: str = @"融資設定";      break;
                case 3: str = @"土地情報";      break;
                case 4: str = @"建物情報";      break;
                case 5: str = @"運営設定";      break;
                case 6: str = @"売却設定";      break;
                default:str = @"その他";       break;
            }
        } else {
            switch (section) {
                case 0: str = @"基本情報";      break;
                case 1: str = @"資金";         break;
                case 2: str = @"融資設定";      break;
                case 3: str = @"土地情報";      break;
                case 4: str = @"建物情報";      break;
                case 5: str = @"売却設定";      break;
                default:str = @"その他";       break;
            }
        }
    } else {
        if ( _addonMgr.opeSetting == true ){
            switch (section) {
                case 0: str = @"基本情報";      break;
                case 1: str = @"資金";         break;
                case 2: str = @"融資設定";      break;
                case 3: str = @"土地情報";      break;
                case 4: str = @"建物情報";      break;
                case 5: str = @"運営設定";      break;
                default:str = @"その他";       break;
            }
        } else {
            switch (section) {
                case 0: str = @"基本情報";      break;
                case 1: str = @"資金";         break;
                case 2: str = @"融資設定";      break;
                case 3: str = @"土地情報";      break;
                case 4: str = @"建物情報";      break;
                default:str = @"その他";       break;
            }
        }
    }
    return str;
}

/****************************************************************
 *
 ****************************************************************/
- (IBAction)selectButtonTapped:(id)sender
{
    _spVc = [[ItemIPadViewCtrl alloc]init];
    _spVc.delegate  = self;
    
    _spVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:_spVc animated:YES completion:nil];
    ViewMgr  *viewMgr   = [ViewMgr sharedManager];
    viewMgr.stage   = STAGE_ANALYSIS;
    
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}
/****************************************************************
 *
 ****************************************************************/
@end
