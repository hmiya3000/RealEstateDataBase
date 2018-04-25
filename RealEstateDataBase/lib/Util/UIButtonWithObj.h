//
//  UIButtonWithObj.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>

//======================================================================
@interface UIButtonWithObj : UIButton
{
    UITextField *_textField;
}

//======================================================================
@property(nonatomic)UITextField *textField;
//======================================================================
@end
//======================================================================
