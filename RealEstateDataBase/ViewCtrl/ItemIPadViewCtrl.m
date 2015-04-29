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
#import "GraphViewCtrl.h"
#import "TotalAnalysisViewCtrl.h"
#import "Pos.h"

//#import "InputItemViewCtrl.h"


@interface ItemIPadViewCtrl ()
{
    UINavigationController      *_inputSettingNAC;
    InputSettingViewCtrl        *_inputSettingVC;  /* データ入力VC */
    SummaryViewCtrl             *_summaryVC;
    UINavigationController      *_summaryNAC;
    UIViewController            *_graphVC;
    UINavigationController      *_graphNAC;
    UIViewController            *_totalVC;
    UINavigationController      *_totalNAC;
    UITabBarController          *_tbc;
    Pos                         *_pos;
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
        _graphVC            = [[GraphViewCtrl alloc]init];
        _graphNAC           = [[UINavigationController alloc]initWithRootViewController:_graphVC];
        _totalVC            = [[TotalAnalysisViewCtrl alloc] init];
        _totalNAC           = [[UINavigationController alloc]initWithRootViewController:_totalVC];
        
        _tbc = [[UITabBarController alloc]init];
        NSArray *views = [NSArray arrayWithObjects:_summaryNAC,_graphNAC,_totalNAC,nil];
        [_tbc setViewControllers:views animated:YES];

        
        self.viewControllers = [NSArray arrayWithObjects:_inputSettingNAC, _tbc, nil];
        _inputSettingVC.detailTab   = _tbc;

        
        _pos = [[Pos alloc]initWithUIViewCtrl:self];
        [_inputSettingVC.view   setFrame:_pos.masterFrame];
        [_summaryVC.view        setFrame:_pos.detailFrame];
        [_graphVC.view          setFrame:_pos.detailFrame];
        [_totalVC.view       setFrame:_pos.detailFrame];
    }
    return self;
    
}
/****************************************************************/
@end
/****************************************************************/
