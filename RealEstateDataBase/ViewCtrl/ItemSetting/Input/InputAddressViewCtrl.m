//
//  InputAddressViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/27.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputAddressViewCtrl.h"

@interface InputAddressViewCtrl ()
{
    UILabel         *_l_title;
    UITextView      *_tv_address;
    UITextView      *_tv_tips;
    UIButton        *_btn_enter;
    UIButton        *_btn_cancel;
    
}

@end

@implementation InputAddressViewCtrl

#define TTAG_ADDRESS       1

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"住所";
    /****************************************/
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _tv_address                = [[UITextView alloc]init];
    _tv_address.editable       = true;
    _tv_address.scrollEnabled  = true;
    _tv_address.backgroundColor = [UIColor whiteColor];
    _tv_address.text           = _modelRE.estate.land.address;
    [_tv_address   setTag:TTAG_ADDRESS];
    [_tv_address   setDelegate:(id)self];
    [_scrollView addSubview:_tv_address];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = @"地図を表示予定...";
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewMake];
}
/****************************************************************
 *
 ****************************************************************/
- (void)viewMake
{
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,lengthR,length30;
    _pos = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    length30    = _pos.len30;
    /****************************************/
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0.2*dy;
    if ( _pos.isPortrait == true ){
        _tv_address.frame   = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
        pos_y = pos_y + dy;
        _tv_tips.frame      = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
        
    }else {
        _tv_address.frame   = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
        pos_y = pos_y + dy;
        _tv_tips.frame      = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
    }
    return;
}


/****************************************************************
 * ビューがタップされたとき
 ****************************************************************/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    [_tv_address resignFirstResponder];
    //    NSLog(@"タップされました．");
}

/****************************************************************
 * 回転時に処理したい内容
 ****************************************************************/
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self viewMake];
    return;
}

/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    _modelRE.estate.land.address = _tv_address.text;
    [_modelRE valToFile];
    
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
