//
//  PrimeIPadViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/02.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "PrimeIPadViewCtrl.h"
#import "InputSettingViewCtrl.h"
#import "SummaryViewCtrl.h"
#import "GraphViewCtrl.h"
#import "InfoViewCtrl.h"
#import "TotalAnalysisViewCtrl.h"
#import "Pos.h"
#import "ModelDB.h"
#import "AddonMgr.h"

@interface PrimeIPadViewCtrl ()
{
    UITabBarController          *_tbc;
    UINavigationController      *_inputSettingNAC;
    InputSettingViewCtrl        *_inputSettingVC;  /* データ入力VC */
    SummaryViewCtrl             *_summaryVC;
    UINavigationController      *_summaryNAC;
    UIViewController            *_graphVC;
    UINavigationController      *_graphNAC;
    UIViewController            *_totalVC;
    UINavigationController      *_totalNAC;
    Pos                         *_pos;
    
    UIViewController            *_infoVC;
    UINavigationController      *_infoNAC;
    ModelDB                     *_db;
    
    AddonMgr                    *_addOnMgr;
    
}
@end

@implementation PrimeIPadViewCtrl

//======================================================================
//
//======================================================================
- (id) init
{
    self = [super init];
    if (self) {
        _addOnMgr           = [AddonMgr sharedManager];
        _db = [ModelDB sharedManager];
        [_db loadIndex:0];        /* ロードしてからview作成 */
        _inputSettingVC     = [[InputSettingViewCtrl alloc]init];
        _inputSettingNAC    = [[UINavigationController alloc]initWithRootViewController:_inputSettingVC];
        _summaryVC          = [[SummaryViewCtrl alloc]init];
        _summaryNAC         = [[UINavigationController alloc]initWithRootViewController:_summaryVC];
        _graphVC            = [[GraphViewCtrl alloc]init];
        _graphNAC           = [[UINavigationController alloc]initWithRootViewController:_graphVC];
        _totalVC            = [[TotalAnalysisViewCtrl alloc] init];
        _totalNAC           = [[UINavigationController alloc]initWithRootViewController:_totalVC];
        _infoVC             = [[InfoViewCtrl alloc]init];
        _infoNAC            = [[UINavigationController alloc]initWithRootViewController:_infoVC];
        
        _tbc = [[UITabBarController alloc]init];
        NSArray *views;
        if ( _addOnMgr.multiYear == true ){
            if ( _addOnMgr.saleAnalysys == true ){
                views = [NSArray arrayWithObjects:_summaryNAC,_graphNAC,_totalNAC,_infoNAC,nil];
            } else {
                views = [NSArray arrayWithObjects:_summaryNAC,_graphNAC,_infoNAC,nil];
            }
        } else {
            if ( _addOnMgr.saleAnalysys == true ){
                views = [NSArray arrayWithObjects:_summaryNAC,_totalNAC,_infoNAC,nil];
            } else {
                views = [NSArray arrayWithObjects:_summaryNAC,_infoNAC,nil];
            }
            
        }
        [_tbc setViewControllers:views animated:YES];
        
        
        self.viewControllers = [NSArray arrayWithObjects:_inputSettingNAC, _tbc, nil];
        _inputSettingVC.detailTab   = _tbc;
        
        
        _pos = [[Pos alloc]initWithUIViewCtrl:self];
        [_inputSettingVC.view   setFrame:_pos.masterFrame];
        [_summaryVC.view        setFrame:_pos.detailFrame];
        [_graphVC.view          setFrame:_pos.detailFrame];
        [_totalVC.view          setFrame:_pos.detailFrame];
        [_infoVC.view           setFrame:_pos.detailFrame];
        
    }
    return self;
}

@end
