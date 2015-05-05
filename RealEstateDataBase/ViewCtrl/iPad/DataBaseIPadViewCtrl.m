//
//  DataBaseIPadViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/12/31.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "DataBaseIPadViewCtrl.h"
#import "DataBaseTableViewCtrl.h"
#import "ItemSettingViewCtrl.h"
#import "InfoViewCtrl.h"
#import "Pos.h"
#import "ViewMgr.h"

/****************************************************************/
@interface DataBaseIPadViewCtrl ()
{
    UINavigationController  *_databaseNAC;
    DataBaseTableViewCtrl   *_databaseVC;
    UINavigationController  *_itemNAC;
    ItemSettingViewCtrl     *_itemVC;
    UINavigationController  *_infoNAC;
    InfoViewCtrl            *_infoVC;
    UITabBarController      *_tbc;
    Pos                     *_pos;
}

@end

@implementation DataBaseIPadViewCtrl

/****************************************************************/
- (id) init
{
    self = [super init];
    if (self) {
        _databaseVC         = [[DataBaseTableViewCtrl alloc]init];
        _databaseNAC        = [[UINavigationController alloc]initWithRootViewController:_databaseVC];
        _itemVC             = [[ItemSettingViewCtrl  alloc]init];
        _itemNAC            = [[UINavigationController alloc]initWithRootViewController:_itemVC];
        _infoVC             = [[InfoViewCtrl alloc]init ];
        _infoNAC            = [[UINavigationController alloc]initWithRootViewController:_infoVC];
    
        // TabBarControllerの設定
        _tbc = [[UITabBarController alloc]init];
        NSArray *views = [NSArray arrayWithObjects:_itemNAC,_infoNAC,nil];
        [_tbc setViewControllers:views animated:YES];
        
        // Viewの関連付け
        self.viewControllers = [NSArray arrayWithObjects:_databaseNAC, _tbc, nil];
        _databaseVC.detailTab   = _tbc;
        _databaseVC.detailVC    = _itemVC;
        _infoVC.masterVC        = _databaseVC;
        _itemVC.masterVC        = _databaseVC;
        

        // Viewのサイズ設定
        _pos = [[Pos alloc]initWithUIViewCtrl:self];
        [_databaseVC.view   setFrame:_pos.masterFrame];
        [_itemVC.view       setFrame:_pos.detailFrame];
        [_infoVC.view       setFrame:_pos.detailFrame];
        
        ViewMgr  *viewMgr   = [ViewMgr sharedManager];
        viewMgr.stage   = STAGE_DATALIST;
    }
    return self;
}
/****************************************************************/
@end
/****************************************************************/
