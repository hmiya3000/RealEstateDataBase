//
//  Pos.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Pos : NSObject
{
    CGFloat     _x_left;
    CGFloat     _x_center;
    CGFloat     _x_ini;
    CGFloat     _y_top;
    CGFloat     _y_btm;
    CGFloat     _dx;
    CGFloat     _dy;
    CGFloat     _len10;
    CGFloat     _len15;
    CGFloat     _len30;
    CGFloat     _x_page;
    CGFloat     _y_page;
    CGRect      _frame;
    CGRect      _masterFrame;
    CGRect      _detailFrame;
    
    BOOL        _isPortrait;
}
- (id)initWithUIViewCtrl:(UIViewController*)uiview;

@property   (nonatomic,readonly)    CGFloat x_left;
@property   (nonatomic,readonly)    CGFloat x_center;
@property   (nonatomic,readonly)    CGFloat x_ini;
@property   (nonatomic,readonly)    CGFloat dx;
@property   (nonatomic,readonly)    CGFloat dy;
@property   (nonatomic,readonly)    CGFloat y_top;
@property   (nonatomic,readonly)    CGFloat y_btm;
@property   (nonatomic,readonly)    CGFloat len10;
@property   (nonatomic,readonly)    CGFloat len15;
@property   (nonatomic,readonly)    CGFloat len30;
@property   (nonatomic,readonly)    CGFloat x_page;
@property   (nonatomic,readonly)    CGFloat y_page;
@property   (nonatomic,readonly)    CGRect  frame;
@property   (nonatomic,readonly)    BOOL    isPortrait;
@property   (nonatomic,readonly)    CGRect  masterFrame;
@property   (nonatomic,readonly)    CGRect  detailFrame;

@end
