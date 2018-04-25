//
//  InputViewCtrl.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/15.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelRE.h"
#import "Pos.h"
#import "UIUtil.h"

@interface InputViewCtrl : UIViewController<UITextFieldDelegate>
{
    ModelRE             *_modelRE;
    Pos                 *_pos;
    
    UIScrollView        *_scrollView;
    UIViewController    *_masterVC;
    bool                _b_cancel;
}
//======================================================================
-(void)clickButton:(UIButton*)sender;
-(void)view_Tapped:(UITapGestureRecognizer *)sender;
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;
//======================================================================
@property   (nonatomic,readwrite)    UIViewController    *masterVC;
//======================================================================
@end
//======================================================================
