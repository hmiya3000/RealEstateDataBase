//
//  ItemIPhoneViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/12/30.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "ItemIPhoneViewCtrl.h"
#import "InputSettingViewCtrl.h"
#import "CacheFlowViewCtrl.h"
#import "AnalysisViewCtrl.h"
#import "NpvIrrViewCtrl.h"
#import "SalesCFViewCtrl.h"
#import "OperationViewCtrl.h"


@interface ItemIPhoneViewCtrl ()
{
    UINavigationController      *_inputSettingNAC;
    UIViewController            *_inputSettingVC;  /* データ入力VC */
    UINavigationController      *_analysisNAC;
    UIViewController            *_analysisVC;
    UINavigationController      *_npvirrNAC;
    UIViewController            *_npvirrVC;
    UINavigationController      *_salesNAC;
    UIViewController            *_salesVC;
    UINavigationController      *_opeNAC;
    UIViewController            *_opeVC;
    
    
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
        _opeVC              = [[OperationViewCtrl alloc]init];
        _opeNAC             = [[UINavigationController alloc]initWithRootViewController:_opeVC];
        _salesVC            = [[SalesCFViewCtrl alloc]init];
        _salesNAC           = [[UINavigationController alloc]initWithRootViewController:_salesVC];
        _analysisVC         = [[AnalysisViewCtrl alloc]init];
        _analysisNAC        = [[UINavigationController alloc]initWithRootViewController:_analysisVC];
        _npvirrVC           = [[NpvIrrViewCtrl alloc]init];
        _npvirrNAC          = [[UINavigationController alloc]initWithRootViewController:_npvirrVC];
        
        NSArray *views = [NSArray arrayWithObjects:_inputSettingNAC,_opeNAC,_salesNAC,_analysisNAC,_npvirrNAC,nil];
        [self setViewControllers:views animated:YES];
    }
    return self;
}

@end
