//
//  InputSettingViewCtrl.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/06.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemSettingViewCtrl.h"

@interface InputSettingViewCtrl : ItemSettingViewCtrl
{
    UITabBarController  *_detailTab;
}
@property   (nonatomic,readwrite)       UITabBarController  *detailTab;
@end
