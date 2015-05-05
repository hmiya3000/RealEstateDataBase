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
/****************************************************************/
#define VERSION         @"version 0.99"
#define APP_COMMENT     @"AIREES(エアリス) - Analysis of Investment for REal EState -\nは収益不動産の投資分析アプリです\n以下のスイッチをオンにすることでアドオン購入手続きへ進みます\n(現在、開発中につき購入できません)"
/****************************************************************/
@property   (nonatomic,readwrite)    UIViewController    *masterVC;
/****************************************************************/
@end
/****************************************************************/
