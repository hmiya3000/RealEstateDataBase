//
//  DataBaseIPhoneViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/12/31.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "DataBaseIPhoneViewCtrl.h"
#import "DataBaseTableViewCtrl.h"
#import "InfoViewCtrl.h"
#import "ViewMgr.h"

@interface DataBaseIPhoneViewCtrl ()
{
    UINavigationController  *_databaseNAC;
    DataBaseTableViewCtrl   *_databaseVC;
    UINavigationController  *_infoNAC;
    InfoViewCtrl            *_infoVC;
    
}
@end

@implementation DataBaseIPhoneViewCtrl

//======================================================================
// 初期化
//======================================================================
-(id) init
{
    self = [super init];
    if (self) {
        _databaseVC         = [[DataBaseTableViewCtrl alloc]init];
        _databaseNAC        = [[UINavigationController alloc]initWithRootViewController:_databaseVC];
        _infoVC             = [[InfoViewCtrl alloc]init ];
        _infoNAC            = [[UINavigationController alloc]initWithRootViewController:_infoVC];
        
        NSArray *views = [NSArray arrayWithObjects:_databaseNAC,_infoNAC,nil];
        [self setViewControllers:views animated:YES];
        ViewMgr  *viewMgr   = [ViewMgr sharedManager];
        viewMgr.stage   = STAGE_DATALIST;
    }
    return self;
}

//======================================================================
@end
//======================================================================
