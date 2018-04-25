//
//  InputImproveViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/09/02.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "InputImproveViewCtrl.h"
#import "InputExpenseExampleViewCtrl.h"

@interface InputImproveViewCtrl ()
{
    UILabel             *_l_expense;
    UITextView          *_tv_tips;
    UIView              *_uv;
    NSInteger           _value;
    bool                _b_sample;
    
    UIViewController    *_exampleVC;
    UIButton            *_b_example;
    UILabel             *_l_price;
    UILabel             *_l_priceVal;
    UILabel             *_l_workArea;
    
    UICalc              *_uicalc;
}

@end

@implementation InputImproveViewCtrl
#define BTAG_SAMPLE     1

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"改良費";
    
    _value  = _modelRE.estate.house.improvementCosts/10000;
    _uicalc = [[UICalc alloc]initWithValue:_value];
    _uicalc.delegate = self;
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_expense     = [UIUtil makeLabel:[NSString stringWithFormat:@"%ld万円",(long)_value]];
    [_scrollView addSubview:_l_expense];
    /****************************************/
    _l_price        = [UIUtil makeLabel:@"売却価格"];
    [_scrollView addSubview:_l_price];
    /****************************************/
    _l_priceVal     = [UIUtil makeLabel:[NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_modelRE.sale.price/10000]]];
    [_scrollView addSubview:_l_priceVal];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"保有期間中の修繕費を入力します。その分、簿価が上がり、譲渡所得が下がります"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
//    _b_example      = [UIUtil makeButton:@"内訳例" tag:BTAG_SAMPLE];
//    [_b_example addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
//    _b_sample   = false;
//    [_scrollView addSubview:_b_example];
    /****************************************/
    _l_workArea     = [UIUtil makeLabel:@"100"];
    [_l_workArea setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_workArea];
    [self updateArea:_uicalc.inputArea work:_uicalc.workArea];
    /****************************************/
    _uv  = [[UIView alloc]init];
    [_uicalc uvinit:_scrollView];
    [_scrollView addSubview:_uv];
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
    [self enterIn:_value];
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
        [UIUtil setRectLabel:_l_expense     x:pos_x     y:pos_y viewWidth:_pos.len30 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price       x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_priceVal    x:pos_x+dx*2    y:pos_y length:_pos.len10];
        pos_y = pos_y + dy*0.6;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*1.2);
        pos_y = pos_y + 1.2*dy;
        [UIUtil setButton:_b_example x:pos_x y:pos_y length:_pos.len10];
    }else {
        [UIUtil setRectLabel:_l_expense     x:pos_x     y:pos_y viewWidth:_pos.len15 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price       x:pos_x         y:pos_y length:_pos.len10/2];
        [UIUtil setLabel:_l_priceVal    x:pos_x+dx      y:pos_y length:_pos.len10/2];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*1.5);
        pos_y = pos_y + 1.5*dy;
        [UIUtil setButton:_b_example x:pos_x y:pos_y length:_pos.len10/2];
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
    if ( _b_cancel == false || _b_sample == false ){
        _modelRE.estate.house.improvementCosts = _value * 10000;
        [_modelRE valToFile];
    }
    _b_sample   = false;
    [super viewWillDisappear:animated];
}


//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    if ( sender.tag == BTAG_SAMPLE ){
        _exampleVC = [[InputExpenseExampleViewCtrl alloc]init];
        _b_sample   = true;
        [self.navigationController pushViewController:_exampleVC animated:YES];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return;
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
    _value              = value;
    _l_expense.text    = [NSString stringWithFormat:@"%ld万円",(long)_value];
}

//======================================================================
@end
//======================================================================
