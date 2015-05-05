//
//  Pos.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Pos.h"

@implementation Pos

@synthesize x_left      = _x_left;
@synthesize x_center    = _x_center;
@synthesize x_ini       = _x_ini;
@synthesize y_top       = _y_top;
@synthesize y_btm       = _y_btm;
@synthesize dx          = _dx;
@synthesize dy          = _dy;
@synthesize len10       = _len10;
@synthesize len15       = _len15;
@synthesize len30       = _len30;
@synthesize x_page      = _x_page;
@synthesize y_page      = _y_page;
@synthesize frame       = _frame;
@synthesize isPortrait  = _isPortrait;
@synthesize masterFrame = _masterFrame;
@synthesize detailFrame = _detailFrame;

- (id)initWithUIViewCtrl:(UIViewController*)uivc
{
    self = [super init];
    if (self){
        UIScreen *ms    = [UIScreen mainScreen];
        CGRect appFrame = ms.applicationFrame;
        
        
        CGFloat _origin_x;
        CGFloat _origin_y;

        NSString *model = [UIDevice currentDevice].model;
        UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
        switch (orientation) {
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
                _isPortrait = false;
                _origin_x   = appFrame.origin.y;
                _origin_y   = appFrame.origin.x;
//                _x_page     = appFrame.size.height;
                _x_page     = uivc.view.frame.size.height;
                _y_page     = appFrame.size.width;
                _x_page     = uivc.view.frame.size.width;
                _y_page     = appFrame.size.height;
                if ( [model hasPrefix:@"iPhone"] ){
                    _dx         = (_x_page -20 )/3;
                    _dy         = (_y_page + 20 )/ 9;
                    if ( _dy < 36 ) _dy = 36;   //狭すぎる場合は補正
                } else if ([model hasPrefix:@"iPad"]){
                    _dx         = (_x_page -20 )/3;
                    _dy         = (_y_page + 20 )/ 8;
                }
                break;
            default:
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationFaceDown:
                _isPortrait = true;
                _origin_x   = appFrame.origin.x;
                _origin_y   = appFrame.origin.y;
//                _x_page     = appFrame.size.width;
                _x_page     = uivc.view.frame.size.width;
                _y_page     = appFrame.size.height;
                if ( [model hasPrefix:@"iPhone"] ){
                    _dx         = (_x_page -20 )/3;
                    _dy         = (_y_page -150 )/ 11;
                    if ( _dy < 36 ) _dy = 36;   //狭すぎる場合は補正
                } else if ([model hasPrefix:@"iPad"]){
                    _dx         = (_x_page -20 )/3;
                    _dy         = (_y_page -150 )/ 23;
                }
                break;
        }
        _x_left     = uivc.view.bounds.origin.x +10;
        _x_ini      = _x_left + 5;
        _x_center   =_origin_x + _x_page / 2 + 5;
        _y_top      = uivc.view.bounds.origin.y+20 + uivc.navigationController.navigationBar.bounds.size.height;
        _y_btm      = uivc.view.bounds.size.height -50;
        _len10      = _dx * 0.9;
        _len15      = _dx * 1.4;
        _len30      = _dx * 3.0;
        if (uivc.navigationController.navigationBar.bounds.size.height == 0){
            _frame      = CGRectMake(_origin_x, uivc.view.bounds.origin.y+20, _x_page, _y_page);
        } else {
            _frame      = CGRectMake(_origin_x, uivc.view.bounds.origin.y, _x_page, _y_page);
        }
        _masterFrame.size.width = 320;
        _masterFrame.size.height = 1024;
        _masterFrame.origin.x = 0;
        _masterFrame.origin.y = 0;
        
        _detailFrame.size.width = 448;
        _detailFrame.size.height = 1024;
        _detailFrame.origin.x = 321;
        _detailFrame.origin.y = 0;
    
    }
    return self;
}

@end
