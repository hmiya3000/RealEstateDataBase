//
//  InputEstateNameViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/14.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputEstateNameViewCtrl.h"
#import "ModelRE.h"
#import "UIUtil.h"
#import "Pos.h"

@interface InputEstateNameViewCtrl ()
{
    UILabel         *_l_title;
    UITextField     *_t_name;
    UITextView      *_tv_tips;
    UIButton        *_btn_enter;
    UIButton        *_btn_cancel;
    
}
@end

@implementation InputEstateNameViewCtrl

#define TTAG_NAME       1

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    /****************************************/
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_title        = [UIUtil makeLabel:@"物件名を入力してください"];
    [_scrollView addSubview:_l_title];
    /****************************************/
    _t_name        = [UIUtil makeTextField:_modelRE.estate.name tgt:self];
    _t_name.textAlignment   = NSTextAlignmentLeft;
    [_t_name   setTag:TTAG_NAME];
    [_t_name   setDelegate:(id)self];
    [_scrollView addSubview:_t_name];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = @"新築の場合は自分で命名できます";
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
}

//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewMake];
}
//======================================================================
// ビューのレイアウト作成
//======================================================================
-(void)viewMake{
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
        [UIUtil setTextField:_t_name x:pos_x y:pos_y length:_pos.len30 ];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);

    }else {
        [UIUtil setTextField:_t_name x:pos_x y:pos_y length:_pos.len30 ];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
    }
    return;
}


//======================================================================
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
}

//======================================================================
// 回転時に処理したい内容
//======================================================================
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self viewMake];
    return;
}

//======================================================================
// Viewが消える直前
//======================================================================
-(void) viewWillDisappear:(BOOL)animated
{
    if ( _b_cancel == false ){
        _modelRE.estate.name = _t_name.text;
        [_modelRE valToFile];
    }
    [super viewWillDisappear:animated];
}

//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

//======================================================================
@end
//======================================================================
