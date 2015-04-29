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
#import "InputSettingViewCtrl.h"

@interface DataBaseIPhoneViewCtrl ()
{
    UINavigationController  *_databaseNAC;
    DataBaseTableViewCtrl   *_databaseVC;
    UIViewController        *_infoVC;
    
}
@end

@implementation DataBaseIPhoneViewCtrl

/****************************************************************/
- (id) init
{
    self = [super init];
    if (self) {
        _databaseVC         = [[DataBaseTableViewCtrl alloc]init];
        _databaseNAC        = [[UINavigationController alloc]initWithRootViewController:_databaseVC];
        _infoVC             = [[InfoViewCtrl alloc]init ];
        
        NSArray *views = [NSArray arrayWithObjects:_databaseNAC,_infoVC,nil];
        [self setViewControllers:views animated:YES];

    }
    return self;
}
/****************************************************************/
@end
/****************************************************************/
