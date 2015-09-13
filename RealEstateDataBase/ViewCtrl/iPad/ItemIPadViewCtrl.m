//
//  ItemIPadViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/12/30.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "ItemIPadViewCtrl.h"
#import "InputSettingViewCtrl.h"
#import "SummaryViewCtrl.h"
#import "LoanViewCtrl.h"
#import "SaleViewCtrl.h"
#import "TotalAnalysisViewCtrl.h"
#import "InfoViewCtrl.h"

#import "Pos.h"
#import "AddonMgr.h"
#import "ViewMgr.h"

//#import "InputItemViewCtrl.h"


@interface ItemIPadViewCtrl ()
{
    UINavigationController      *_inputSettingNAC;
    InputSettingViewCtrl        *_inputSettingVC;  /* データ入力VC */
    SummaryViewCtrl             *_summaryVC;
    UINavigationController      *_summaryNAC;
    LoanViewCtrl                *_loanVC;
    UINavigationController      *_loanNAC;
    SaleViewCtrl                *_saleVC;
    UINavigationController      *_saleNAC;
    TotalAnalysisViewCtrl       *_totalVC;
    UINavigationController      *_totalNAC;
    InfoViewCtrl                *_infoVC;
    UINavigationController      *_infoNAC;

    UITabBarController          *_tbc;
    Pos                         *_pos;
    AddonMgr                    *_addonMgr;
}

@end

@implementation ItemIPadViewCtrl


/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self) {
    
        _inputSettingVC     = [[InputSettingViewCtrl alloc]init];
        _inputSettingNAC    = [[UINavigationController alloc]initWithRootViewController:_inputSettingVC];
        _summaryVC          = [[SummaryViewCtrl alloc]init];
        _summaryNAC         = [[UINavigationController alloc]initWithRootViewController:_summaryVC];
        _loanVC             = [[LoanViewCtrl alloc]init];
        _loanNAC            = [[UINavigationController alloc]initWithRootViewController:_loanVC];
        _saleVC             = [[SaleViewCtrl alloc] init];
        _saleNAC            = [[UINavigationController alloc]initWithRootViewController:_saleVC];
        _totalVC            = [[TotalAnalysisViewCtrl alloc] init];
        _totalNAC           = [[UINavigationController alloc]initWithRootViewController:_totalVC];
        _infoVC             = [[InfoViewCtrl alloc]init];
        _infoNAC            = [[UINavigationController alloc]initWithRootViewController:_infoVC];
        
        // TabBarControllerの設定
        _tbc = [[UITabBarController alloc]init];
        _addonMgr = [AddonMgr sharedManager];
        NSArray *views;
        if ( _addonMgr.database == true ){
            views = [NSArray arrayWithObjects:_summaryNAC,_loanNAC,_saleNAC,_totalNAC,nil];
        } else {
            if ( _addonMgr.multiYear == true ){
                if ( _addonMgr.saleAnalysys == true ){
                    views = [NSArray arrayWithObjects:_summaryNAC,_loanNAC,_saleNAC,_totalNAC,_infoNAC,nil];
                } else {
                    views = [NSArray arrayWithObjects:_summaryNAC,_loanNAC,_infoNAC,nil];
                }
            } else {
                if ( _addonMgr.saleAnalysys == true ){
                    views = [NSArray arrayWithObjects:_summaryNAC,_saleNAC,_totalNAC,_infoNAC,nil];
                } else {
                    views = [NSArray arrayWithObjects:_summaryNAC,_infoNAC,nil];
                }
            }
        }
        [_tbc setViewControllers:views animated:YES];

        
        // Viewの関連付け
        self.viewControllers = [NSArray arrayWithObjects:_inputSettingNAC, _tbc, nil];
        _inputSettingVC.detailTab   = _tbc;
        _inputSettingVC.detailVC    = _summaryVC;
        _summaryVC.masterVC         = _inputSettingVC;
        _loanVC.masterVC            = _inputSettingVC;
        _saleVC.masterVC            = _inputSettingVC;
        _totalVC.masterVC           = _inputSettingVC;
        _infoVC.masterVC            = _inputSettingVC;
        
        // Viewのサイズ設定
        _pos = [[Pos alloc]initWithUIViewCtrl:self];
        [_inputSettingVC.view   setFrame:_pos.masterFrame];
        [_summaryVC.view        setFrame:_pos.detailFrame];
        [_loanVC.view           setFrame:_pos.detailFrame];
        [_saleVC.view           setFrame:_pos.detailFrame];
        [_totalVC.view          setFrame:_pos.detailFrame];

        ViewMgr  *viewMgr   = [ViewMgr sharedManager];
        viewMgr.stage       = STAGE_ANALYSIS;

    }
    return self;
    
}
/****************************************************************/
@end
/****************************************************************/
