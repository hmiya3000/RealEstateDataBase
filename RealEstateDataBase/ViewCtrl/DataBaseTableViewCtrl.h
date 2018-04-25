//
//  DataBaseTableViewCtrl.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/19.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>

//======================================================================
@interface DataBaseTableViewCtrl : UITableViewController<UISplitViewControllerDelegate>
{
    UIViewController    *_detailVC;
    UITabBarController  *_detailTab;
    
}
//======================================================================
@property   (nonatomic,readwrite)       UIViewController    *detailVC;
@property   (nonatomic,readwrite)       UITabBarController  *detailTab;
//======================================================================
-(void)selectCell:(NSIndexPath*)indexPath;
//======================================================================
@end
//======================================================================
