//
//  InfoViewCtrl.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/08/17.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewCtrl : UIViewController
{
    UIViewController    *_masterVC;    
}
//======================================================================
#define VERSION         @"version 2.00"
#define APP_COMMENT     @"AIREES(エアリス) - Analysis of Investment for REal EState - は収益不動産の投資分析アプリです\n以下のスイッチをオンにすることでアドオン購入手続きへ進みます\n購入したアドオンは同じApple IDでサインインしているiPhone/iPadで同様に使えます"
//======================================================================
@property   (nonatomic,readwrite)    UIViewController    *masterVC;
//======================================================================
@end
//======================================================================
