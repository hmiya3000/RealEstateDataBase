//
//  InputEquipmentRateViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2017/04/18.
//  Copyright © 2017年 Beetre. All rights reserved.
//

#import "InputEquipmentRateViewCtrl.h"

@interface InputEquipmentRateViewCtrl ()
{
    UILabel                 *_l_rate;
    UITextView              *_tv_tips;
    UIView                  *_uv;
    CGFloat                 _value;
    
    UILabel                 *_l_price;
    UILabel                 *_l_priceVal;
    UILabel                 *_l_equipPrice;
    UILabel                 *_l_equipPriceVal;
    UILabel                 *_l_workArea;
    UISlider                *_sl;
    
    UICalc                  *_uicalc;    
}
@end

@implementation InputEquipmentRateViewCtrl

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"設備割合";
    
    _value  = (int)(_modelRE.estate.house.equipRatio*1000) / 10.0;
    _uicalc = [[UICalc alloc]initWithValue:_value];
    _uicalc.delegate = self;
    
    //========================================
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    //========================================
    _l_rate     = [UIUtil makeLabel:[NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_value]]];
    [_scrollView addSubview:_l_rate];
    //========================================
    _l_price        = [UIUtil makeLabel:@"建物価格"];
    [_l_price setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_price];
    //========================================
    _l_priceVal     = [UIUtil makeLabel:[NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_modelRE.estate.house.price/10000]]];
    [_l_priceVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceVal];
    //========================================
    _l_equipPrice        = [UIUtil makeLabel:@"うち設備分"];
    [_l_equipPrice setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_equipPrice];
    //========================================
    _l_equipPriceVal     = [UIUtil makeLabel:[NSString stringWithFormat:@"%@万円",[UIUtil yenValue:0]]];
    [_l_equipPriceVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_equipPriceVal];
    //========================================
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"設備の耐用年数は15年なので設備割合が高いと減価償却費を多く取ることができます.ただし設備の明細など根拠が必要です"];
    [_scrollView addSubview:_tv_tips];
    //========================================
    _sl             = [[UISlider alloc]init];
    _sl.minimumValue = 0;   // 最小値を0に設定
    _sl.maximumValue = 50;  // 最大値を500に設定
    _sl.value = _value;        // 初期値を250に設定
    // 値が変更された時にhogeメソッドを呼び出す
    [_sl addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_sl];
    //========================================
    _l_workArea     = [UIUtil makeLabel:@"100"];
    [_l_workArea setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_workArea];
    [self updateArea:_uicalc.inputArea work:_uicalc.workArea];
    //========================================
    _uv  = [[UIView alloc]init];
    [_uicalc uvinit:_scrollView];
    [_scrollView addSubview:_uv];
    //========================================
    
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    [self enterIn:_value];
    [self rewriteProperty];
}
//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewMake];
    [self rewriteProperty];
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
        [UIUtil setRectLabel:_l_rate     x:pos_x     y:pos_y viewWidth:_pos.len30 viewHeight:dy  color:[UIUtil color_Ivory] ];
        //----------------------------------------
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price       x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_priceVal    x:pos_x+dx*2    y:pos_y length:_pos.len10];
        //----------------------------------------
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_equipPrice      x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_equipPriceVal   x:pos_x+dx*2    y:pos_y length:_pos.len10];
        //----------------------------------------
        pos_y = pos_y + dy*0.6;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*1.5);
//        pos_y = pos_y + 1.5*dy;
        /*--------------------------------------*/
        pos_y = pos_y + 1.5*dy;
        [_sl setFrame:CGRectMake(       pos_x+0.25*dx,          pos_y,length30-0.5*dx,dy)];
        pos_y = pos_y + dy;
    }else {
        [UIUtil setRectLabel:_l_rate     x:pos_x     y:pos_y viewWidth:_pos.len15 viewHeight:dy  color:[UIUtil color_Ivory] ];
        //----------------------------------------
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price       x:pos_x         y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_priceVal    x:pos_x+dx*0.75 y:pos_y length:_pos.len15/2];
        //----------------------------------------
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_equipPrice      x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_equipPriceVal   x:pos_x+dx*2    y:pos_y length:_pos.len10];
        //----------------------------------------
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*1.5);
        pos_y = pos_y + 1.5*dy;
        /*--------------------------------------*/
        pos_y = pos_y + 1.5*dy;
        [_sl setFrame:CGRectMake(       pos_x,          pos_y,length*2,dy)];
        pos_y = pos_y + dy;
    }
    
    /****************************************/
    if ( _pos.isPortrait == true ){
        pos_y = _pos.y_page/2-2*dy;
        [UIUtil setRectLabel:_l_workArea    x:pos_x     y:pos_y viewWidth:_pos.len30 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [_uicalc setuv:CGRectMake(pos_x, pos_y, _pos.len30, _pos.y_page/2+dy)];
    }else {
        pos_y = 0;
        [UIUtil setRectLabel:_l_workArea    x:_pos.x_center     y:pos_y viewWidth:_pos.len30/2 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [_uicalc setuv:CGRectMake(_pos.x_center, pos_y, _pos.len30/2, _pos.y_page-dy)];
    }
    
    return;
}
//======================================================================
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    //    [_t_name resignFirstResponder];
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
        _modelRE.estate.house.equipRatio = _value/100;
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
    return;
}
//======================================================================
//
//======================================================================
-(void)slider:(UISlider*)slider
{
    // ここに何かの処理を記述する
    // （引数の slider には呼び出し元のUISliderオブジェクトが引き渡されてきます）
    [self enterIn:slider.value];
    [self rewriteProperty];
    
    
}
//======================================================================
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{
    _sl.value = _value;
    NSInteger equipPrice = _modelRE.estate.house.price*_value / 10000 /100;
    _l_equipPriceVal.text      = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:equipPrice]];
}
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//
//======================================================================
-(void) updateArea:(NSString*)inputArea work:(NSString *)workArea
{
    _l_workArea.text    = [NSString stringWithFormat:@"%@", workArea ];
}
//======================================================================
//
//======================================================================
-(void) enterIn:(CGFloat)value
{
    if ( value <= 0 ){
        _value = 0;
    } else if (value > 50 ){
        _value = 50;
    } else {
        _value = ((int)(value * 10)) / 10.0;
    }
    _l_rate.text    = [NSString stringWithFormat:@"%2.1f%%",_value];
    [self rewriteProperty];
}

//======================================================================
@end
//======================================================================
