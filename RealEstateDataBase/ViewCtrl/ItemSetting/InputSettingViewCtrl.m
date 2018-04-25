//
//  InputSettingViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/06.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputSettingViewCtrl.h"
#import "AddonMgr.h"
#import "ViewMgr.h"

#import "InputEstateNameViewCtrl.h"
#import "InputPriceViewCtrl.h"
#import "InputInterestViewCtrl.h"

#import "InputExpenseViewCtrl.h"
#import "InputEquityViewCtrl.h"

#import "InputLoanBorrowViewCtrl.h"
#import "InputLoanSettingViewCtrl.h"

#import "InputLandPriceViewCtrl.h"
#import "InputLandAreaViewCtrl.h"
#import "InputAddressViewCtrl.h"
#import "InputLandAssessmentViewCtrl.h"

#import "InputHousePriceViewCtrl.h"
#import "InputEquipmentRateViewCtrl.h"
#import "InputFloorAreaViewCtrl.h"
#import "InputConstructViewCtrl.h"
#import "InputRoomsViewCtrl.h"
#import "InputBuildYearViewCtrl.h"

#import "InputAquYearViewCtrl.h"
#import "InputOperationViewCtrl.h"
#import "InputOpeEmptyViewCtrl.h"
#import "InputTaxRateViewCtrl.h"

#import "InputHoldingPeriodViewCtrl.h"
#import "InputPriceSalesViewCtrl.h"
#import "InputTransferExpViewCtrl.h"
#import "InputImproveViewCtrl.h"

#import "RentViewCtrl.h"

@interface InputSettingViewCtrl ()
{
    InputViewCtrl               *_inputVC;          /* 物件名入力VC */
    NSIndexPath                 *_openIndexPath;
    ViewMgr                     *_viewMgr;
    AddonMgr                    *_addonMgr;
}
@end

@implementation InputSettingViewCtrl
//======================================================================
@synthesize detailVC    = _detailVC;
@synthesize detailTab   = _detailTab;

//======================================================================
//
//======================================================================
-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title  = @"データ入力";
        self.tabBarItem.image = [UIImage imageNamed:@"input-s.png"];
        _detailVC       = nil;
        _detailTab      = nil;
        _viewMgr        = [ViewMgr sharedManager];
        _addonMgr       = [AddonMgr sharedManager];
    }
    return self;
}
//======================================================================
// セルの選択時で、次のビューを開く
//======================================================================
-(void)selectCell:(NSIndexPath*)indexPath
{
    
    NSString    *key = [self getKeyIndexPath:indexPath];
    if ( [key isEqualToString:@"物件名"]){
        _inputVC = [[InputEstateNameViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"物件価格"]){
        _inputVC = [[InputPriceViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"表面利回り"]){
        _inputVC = [[InputInterestViewCtrl alloc]init];
        /****************************************/
    } else if ( [key isEqualToString:@"諸費用"]){
        _inputVC = [[InputExpenseViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"仲介手数料"]){
        _inputVC = [[InputExpenseViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"自己資金"]){
        _inputVC = [[InputEquityViewCtrl alloc]init];
        /****************************************/
    } else if ( [key isEqualToString:@"借入金"]){
        _inputVC = [[InputLoanBorrowViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"金利"]){
        _inputVC = [[InputLoanSettingViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"借入期間"]){
        _inputVC = [[InputLoanSettingViewCtrl alloc]init];
        /****************************************/
    } else if ( [key isEqualToString:@"土地価格"]){
        _inputVC = [[InputLandPriceViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"土地面積"]){
        _inputVC = [[InputLandAreaViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"住所"]){
        _inputVC = [[InputAddressViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"路線価"]){
        _inputVC = [[InputLandAssessmentViewCtrl alloc]init];
        /****************************************/
    } else if ( [key isEqualToString:@"建物価格"]){
        _inputVC = [[InputHousePriceViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"設備割合"]){
        _inputVC = [[InputEquipmentRateViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"床面積"]){
        _inputVC = [[InputFloorAreaViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"構造"]){
        _inputVC = [[InputConstructViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"戸数"]){
        _inputVC = [[InputRoomsViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"建築年"]){
        _inputVC = [[InputBuildYearViewCtrl alloc]init];
        /****************************************/
    } else if ( [key isEqualToString:@"取得年"]){
        _inputVC = [[InputAquYearViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"家賃下落率"]){
        _inputVC = [[InputOpeEmptyViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"空室率"]){
        _inputVC = [[InputOpeEmptyViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"立ち上げ期間"]){
        _inputVC = [[InputOpeEmptyViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"管理費割合"]){
        _inputVC = [[InputOperationViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"その他運営費"]){
        _inputVC = [[InputOperationViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"所得税・住民税"]){
        _inputVC = [[InputTaxRateViewCtrl alloc]init];
        /****************************************/
    } else if ( [key isEqualToString:@"保有期間"]){
        _inputVC = [[InputHoldingPeriodViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"売却価格"]){
        _inputVC = [[InputPriceSalesViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"改良費"]){
        _inputVC = [[InputImproveViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"譲渡費用"]){
        _inputVC = [[InputTransferExpViewCtrl alloc]init];
        /****************************************/
    } else {
        _inputVC = nil;
    }
    
    if ( _inputVC != nil ){
        _inputVC.hidesBottomBarWhenPushed = YES;
        NSString *model = [UIDevice currentDevice].model;
        if ( [model hasPrefix:@"iPhone"] ){
            [self.navigationController pushViewController:_inputVC animated:YES];
        } else if ([model hasPrefix:@"iPad"] ){
            _inputVC.masterVC = self;
            _openIndexPath  = indexPath;

            UINavigationController  *tmpNAC;
            tmpNAC   = (UINavigationController*)self.detailTab.selectedViewController;
            if ( [_viewMgr isOpenInputView] == false ){
                // 項目入力ビューを開いてないので普通に開く
                [tmpNAC pushViewController:_inputVC animated:YES];
            } else {
                // 項目入力ビューを開いた状態だったので一旦戻してから開く
                [tmpNAC popToRootViewControllerAnimated:NO];
                [tmpNAC pushViewController:_inputVC animated:NO];
            }
            [_viewMgr SetOpenInputView:true];
        }
    }
    return;
}

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    if ( _addonMgr.database == true ){
        UIBarButtonItem *retButton =
        [[UIBarButtonItem alloc] initWithTitle:@"物件リスト"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(retButtonTapped:)];
        self.navigationItem.leftBarButtonItem = retButton;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    UIBarButtonItem *rentMonthButton =
    [[UIBarButtonItem alloc] initWithTitle:@"利回り検証"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(retMonthButtonTapped:)];
    self.navigationItem.rightBarButtonItem = rentMonthButton;
    
}
//======================================================================
// セルの選択時に呼ばれる
//======================================================================
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectCell:indexPath];
}

//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    //データの値を更新させる
    [super viewWillAppear:animated];
    
    if ( [_viewMgr isOpenInputView] == true ){
        //選択がクリアされるのでここで再設定
        [self.tableView selectRowAtIndexPath:_openIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    //DataListへ戻る要求があったら表示前に戻る
    if ( [_viewMgr isReturnDataList ] == true ){
        [self dismissViewControllerAnimated:YES completion:nil];
        _viewMgr.stage   = STAGE_DATALIST;
    }
    
}

/****************************************************************
 * ModalViewから戻る
 ****************************************************************/
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/****************************************************************
 * ModalViewから戻る
 ****************************************************************/
- (IBAction)retMonthButtonTapped:(id)sender
{
    _inputVC = [[RentViewCtrl alloc]init];
    _inputVC.hidesBottomBarWhenPushed = YES;
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        [self.navigationController pushViewController:_inputVC animated:YES];
    } else if ([model hasPrefix:@"iPad"] ){
        _inputVC.masterVC = self;
//        _openIndexPath  = indexPath;
        
        UINavigationController  *tmpNAC;
        tmpNAC   = (UINavigationController*)self.detailTab.selectedViewController;
        if ( [_viewMgr isOpenInputView] == false ){
            // 項目入力ビューを開いてないので普通に開く
            [tmpNAC pushViewController:_inputVC animated:YES];
        } else {
            // 項目入力ビューを開いた状態だったので一旦戻してから開く
            [tmpNAC popToRootViewControllerAnimated:NO];
            [tmpNAC pushViewController:_inputVC animated:NO];
        }
        [_viewMgr SetOpenInputView:true];
    }
}
//======================================================================
@end
//======================================================================
