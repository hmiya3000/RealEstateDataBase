//
//  DataBaseTableViewCtrl.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/19.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataBaseTableViewCtrl : UITableViewController
{
    UIViewController    *_detailVC;
}
@property   (nonatomic,readwrite)    UIViewController    *detailVC;

@end
