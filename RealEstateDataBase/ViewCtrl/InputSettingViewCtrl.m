//
//  InputSettingViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/06.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputSettingViewCtrl.h"

#import "InputEstateNameViewCtrl.h"
#import "InputPriceViewCtrl.h"
#import "InputInterestViewCtrl.h"

#import "InputExpenseViewCtrl.h"
#import "InputSelfFinaceViewCtrl.h"

#import "InputLoanBorrowViewCtrl.h"
#import "InputLoanSettingViewCtrl.h"

#import "InputLandPriceViewCtrl.h"
#import "InputLandAreaViewCtrl.h"
#import "InputAddressViewCtrl.h"
#import "InputLandAssessmentViewCtrl.h"

#import "InputHousePriceViewCtrl.h"
#import "InputFloorAreaViewCtrl.h"
#import "InputConstructViewCtrl.h"
#import "InputRoomsViewCtrl.h"
#import "InputBuildYearViewCtrl.h"

#import "InputAquYearViewCtrl.h"
#import "InputOperationViewCtrl.h"
#import "InputTaxRateViewCtrl.h"

#import "InputHoldingPeriodViewCtrl.h"
#import "InputPriceSalesViewCtrl.h"
#import "InputTransferExpViewCtrl.h"



@interface InputSettingViewCtrl ()
{
    InputViewCtrl               *_inputVC;          /* 物件名入力VC */
    BOOL                        _openInputVC;
    NSIndexPath                 *_openIndexPath;
}
@end

@implementation InputSettingViewCtrl
@synthesize detailTab   = _detailTab;

/****************************************************************
 *
 ****************************************************************/
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title  = @"データ入力";
        _openInputVC    = false;
    }
    return self;
}

/****************************************************************
 * セルの選択時で、次のビューを開く
 ****************************************************************/
- (void)selectCell:(NSIndexPath*)indexPath
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
    } else if ( [key isEqualToString:@"自己資金"]){
        _inputVC = [[InputSelfFinaceViewCtrl alloc]init];
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
        _inputVC = [[InputOperationViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"空室率"]){
        _inputVC = [[InputOperationViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"管理費割合"]){
        _inputVC = [[InputOperationViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"所得税・住民税"]){
        _inputVC = [[InputTaxRateViewCtrl alloc]init];
        /****************************************/
    } else if ( [key isEqualToString:@"保有期間"]){
        _inputVC = [[InputHoldingPeriodViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"売却価格"]){
        _inputVC = [[InputPriceSalesViewCtrl alloc]init];
    } else if ( [key isEqualToString:@"改良費"]){
        _inputVC = nil;
    } else if ( [key isEqualToString:@"譲渡費用"]){
        _inputVC = [[InputTransferExpViewCtrl alloc]init];
        /****************************************/
    } else {
        _inputVC = nil;
    }
    
    if ( _inputVC != nil ){
        _inputVC.hidesBottomBarWhenPushed = YES;
        NSString *model = [UIDevice currentDevice].model;
        if ( [model isEqualToString:@"iPhone"] ){
            [self.navigationController pushViewController:_inputVC animated:YES];
        } else if ([model isEqualToString:@"iPad"] ){
            UINavigationController  *tmpNAC;
            tmpNAC   = (UINavigationController*)self.detailTab.selectedViewController;
            if ( _openInputVC == false ){
                [tmpNAC pushViewController:_inputVC animated:YES];
            } else {
                [tmpNAC popToRootViewControllerAnimated:NO];
                [tmpNAC pushViewController:_inputVC animated:NO];
            }
            _openInputVC = true;
            _inputVC.masterVC = self;
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *retButton =
    [[UIBarButtonItem alloc] initWithTitle:@"物件リスト"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(retButtonTapped:)];
    self.navigationItem.leftBarButtonItem = retButton;
    self.navigationItem.rightBarButtonItem = nil;
    
}

/****************************************************************
 * セルの選択時に呼ばれる
 ****************************************************************/
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 0
    if ( _openInputVC == false ){
        _openIndexPath  = indexPath;
    } else {
        [tableView selectRowAtIndexPath:_openIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
#endif
    [self selectCell:indexPath];
}

/****************************************************************
 * ビューの表示直前に呼ばれる
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _openInputVC = false;
    
}

/****************************************************************
 *
 ****************************************************************/
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/****************************************************************/
@end
/****************************************************************/
