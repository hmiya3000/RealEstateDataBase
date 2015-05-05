//
//  ItemIPhoneViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/12/30.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "ItemIPhoneViewCtrl.h"
#import "InputSettingViewCtrl.h"
#import "SummaryViewCtrl.h"
#import "GraphViewCtrl.h"
#import "TotalAnalysisViewCtrl.h"
#import "InfoViewCtrl.h"
#import "AddonMgr.h"

@interface ItemIPhoneViewCtrl ()
{
    UINavigationController      *_inputSettingNAC;
    UIViewController            *_inputSettingVC;  /* データ入力VC */
    UINavigationController      *_summaryNAC;
    UIViewController            *_summaryVC;
    UINavigationController      *_graphNAC;
    UIViewController            *_graphVC;
    UINavigationController      *_totalNAC;
    UIViewController            *_totalVC;
    UIViewController            *_infoVC;
    UINavigationController      *_infoNAC;
    
    AddonMgr                    *_addonMgr;
    
}

@end

@implementation ItemIPhoneViewCtrl

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
        _graphVC            = [[GraphViewCtrl alloc]init];
        _graphNAC           = [[UINavigationController alloc]initWithRootViewController:_graphVC];
        _totalVC            = [[TotalAnalysisViewCtrl alloc]init];
        _totalNAC           = [[UINavigationController alloc]initWithRootViewController:_totalVC];
        _infoVC             = [[InfoViewCtrl alloc]init];
        _infoNAC            = [[UINavigationController alloc]initWithRootViewController:_infoVC];
        
        _addonMgr = [AddonMgr sharedManager];
        NSArray *views;
        if ( _addonMgr.database == true ){
            views = [NSArray arrayWithObjects:_inputSettingNAC,_summaryNAC,_graphNAC,_totalNAC,nil];
        } else {
            if ( _addonMgr.multiYear == true ){
                if ( _addonMgr.saleAnalysys == true ){
                    views = [NSArray arrayWithObjects:_inputSettingNAC,_summaryNAC,_graphNAC,_totalNAC,_infoNAC,nil];
                } else {
                    views = [NSArray arrayWithObjects:_inputSettingNAC,_summaryNAC,_graphNAC,_infoNAC,nil];
                }
            } else {
                if ( _addonMgr.saleAnalysys == true ){
                    views = [NSArray arrayWithObjects:_inputSettingNAC,_summaryNAC,_totalNAC,_infoNAC,nil];
                } else {
                    views = [NSArray arrayWithObjects:_inputSettingNAC,_summaryNAC,_infoNAC,nil];
                }
            }
        }
        [self setViewControllers:views animated:YES];
    }
    return self;
}

@end
