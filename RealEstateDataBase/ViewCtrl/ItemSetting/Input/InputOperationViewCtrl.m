//
//  InputOperationViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputOperationViewCtrl.h"

@interface InputOperationViewCtrl ()
{
    CGFloat             _mngRate;
    NSInteger           _opexEtc;
    
    UILabel             *_l_bg;
    UILabel             *_l_mngRate;
    UILabel             *_l_opexEtc;
    
    UITextField         *_t_mngRate;
    UITextField         *_t_opexEtc;

    UITextView          *_tv_tips;
    
    UILabel             *_l_opexMng;
    UILabel             *_l_opexMngVal;
    UILabel             *_l_opexPropTax;
    UILabel             *_l_opexPropTaxVal;
    UILabel             *_l_opexYear;
    UILabel             *_l_opexMonth;
    UILabel             *_l_opexYearVal;
    UILabel             *_l_opexMonthVal;
    
}
@end

@implementation InputOperationViewCtrl
//======================================================================
#define TTAG_MNG            1
#define TTAG_OPE            2

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"運営設定";
    _mngRate        = _modelRE.investment.mngRate;
    _opexEtc        = _modelRE.investment.opexEtc;
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_bg           = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_bg];
    /****************************************/
    _l_mngRate          = [UIUtil makeLabel:@"管理費割合[%]"];
    [_scrollView addSubview:_l_mngRate];
    /*--------------------------------------*/
    _l_opexEtc          = [UIUtil makeLabel:@"その他運営費[万]"];
    [_scrollView addSubview:_l_opexEtc];
    /****************************************/
    _t_mngRate          = [UIUtil makeTextFieldDec:@"0.00" tgt:self];
    [_t_mngRate   setTag:TTAG_MNG];
    [_t_mngRate   setDelegate:(id)self];
    [_scrollView addSubview:_t_mngRate];
    /****************************************/
    _t_opexEtc          = [UIUtil makeTextFieldDec:@"0.0" tgt:self];
    [_t_opexEtc   setTag:TTAG_OPE];
    [_t_opexEtc   setDelegate:(id)self];
    [_scrollView addSubview:_t_opexEtc];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"管理費割合は集金額に対する管理費の割合で設定します.\n固定資産税・都市計画税は路線価から算出しています.\nその他運営費はエレベータ保守,電気代,広告費,交通費の見込みを入力してください"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _l_opexMng             = [UIUtil makeLabel:@"満室時管理費"];
    [_l_opexMng setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opexMng];
    /*--------------------------------------*/
    _l_opexMngVal           = [UIUtil makeLabel:@"000"];
    [_l_opexMngVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opexMngVal];
    /****************************************/
    _l_opexPropTax          = [UIUtil makeLabel:@"固定資産税,都市計画税"];
    [_l_opexPropTax setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opexPropTax];
    /*--------------------------------------*/
    _l_opexPropTaxVal       = [UIUtil makeLabel:@"000"];
    [_l_opexPropTaxVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opexPropTaxVal];
    /****************************************/
    _l_opexYear             = [UIUtil makeLabel:@"年間運営費(合計)"];
    [_l_opexYear setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opexYear];
    /*--------------------------------------*/
    _l_opexMonthVal         = [UIUtil makeLabel:@"000"];
    [_l_opexMonthVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opexMonthVal];
    /****************************************/
    _l_opexMonth            = [UIUtil makeLabel:@"運営費(月割)"];
    [_l_opexMonth setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opexMonth];
    /*--------------------------------------*/
    _l_opexYearVal          = [UIUtil makeLabel:@"000"];
    [_l_opexYearVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opexYearVal];
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
    [self rewriteProperty];
    [self viewMake];
}
//======================================================================
// ビューのレイアウト作成
//======================================================================
-(void)viewMake{
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,lengthR,length30;
    _pos = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_ini;
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
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:_pos.x_left   y:pos_y viewWidth:_pos.len30 viewHeight:dy*2 color:[UIUtil color_Ivory]];
        [UIUtil setLabel:_l_mngRate             x:pos_x+dx*0    y:pos_y length:lengthR];
        [UIUtil setLabel:_l_opexEtc             x:pos_x+dx*1.5  y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setTextField:_t_mngRate         x:pos_x+dx*0    y:pos_y length:lengthR];
        [UIUtil setTextField:_t_opexEtc         x:pos_x+dx*1.5  y:pos_y length:lengthR];

        /****************************************/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*3);
        /****************************************/
        pos_y = pos_y + dy*3;
        [UIUtil setLabel:_l_opexMng             x:pos_x+dx*0    y:pos_y length:length*2];
        [UIUtil setLabel:_l_opexMngVal          x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_opexPropTax         x:pos_x+dx*0    y:pos_y length:length*2];
        [UIUtil setLabel:_l_opexPropTaxVal      x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_opexYear            x:pos_x+dx*0    y:pos_y length:length*2];
        [UIUtil setLabel:_l_opexYearVal         x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_opexMonth           x:pos_x+dx*0    y:pos_y length:length*2];
        [UIUtil setLabel:_l_opexMonthVal        x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
    }else {
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:_pos.x_left   y:pos_y viewWidth:_pos.len30 viewHeight:dy*2 color:[UIUtil color_Ivory]];
        [UIUtil setLabel:_l_mngRate             x:pos_x+dx*0    y:pos_y length:length30/2];
        [UIUtil setLabel:_l_opexEtc             x:pos_x+dx*1.5  y:pos_y length:length30/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setTextField:_t_mngRate         x:pos_x+dx*0    y:pos_y length:length30/2];
        [UIUtil setTextField:_t_opexEtc         x:pos_x+dx*1.5  y:pos_y length:length30/2];
        /****************************************/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*2);
        /****************************************/
        pos_y = pos_y + dy*2;
        [UIUtil setLabel:_l_opexMng             x:pos_x+dx*0    y:pos_y length:length*2];
        [UIUtil setLabel:_l_opexMngVal          x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_opexPropTax         x:pos_x+dx*0    y:pos_y length:length*2];
        [UIUtil setLabel:_l_opexPropTaxVal      x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_opexYear            x:pos_x+dx*0    y:pos_y length:length*2];
        [UIUtil setLabel:_l_opexYearVal         x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_opexMonth           x:pos_x+dx*0    y:pos_y length:length*2];
        [UIUtil setLabel:_l_opexMonthVal        x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
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
//
//======================================================================
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
    [self readTextFieldData];
}
//======================================================================
//
//======================================================================
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self readTextFieldData];
    return YES;
}

//======================================================================
//
//======================================================================
-(void) readTextFieldData
{
    /*--------------------------------------*/
    float tmp_mngRate = [_t_mngRate.text      floatValue]/100;
    if ( tmp_mngRate > 100 ){
        _mngRate = 100;
    } else if (tmp_mngRate < 0 ){
        _mngRate = 0;
    } else {
        _mngRate = tmp_mngRate;
    }
    /*--------------------------------------*/
    float tmp_opexEtc    = [_t_opexEtc.text      floatValue]*10000;
    float tmp_opexEtcMax = 9999*10000;
    if ( tmp_opexEtc > tmp_opexEtcMax ){
        _opexEtc = tmp_opexEtcMax;
    }else if ( tmp_opexEtc < 0 ){
        _opexEtc = 0;
    } else {
        _opexEtc = tmp_opexEtc;
    }
    /*--------------------------------------*/
    [self rewriteProperty];
}

//======================================================================
// Viewが消える直前
//======================================================================
-(void) viewWillDisappear:(BOOL)animated
{
    if ( _b_cancel == false ){
        [self readTextFieldData];
        _modelRE.investment.mngRate     = _mngRate;
        _modelRE.investment.opexEtc     = _opexEtc;
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
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{
    _t_mngRate.text     = [NSString stringWithFormat:@"%g",_mngRate*100];
    _t_opexEtc.text     = [NSString stringWithFormat:@"%2.1f",(CGFloat)_opexEtc/10000];
    

    NSInteger opexMng = (int)(_modelRE.investment.gpi * _mngRate);
    NSInteger opexPropTax = [_modelRE.estate getPropTax_term:0];

    NSInteger opexYear  = opexMng + opexPropTax + _opexEtc;
    NSInteger opexMonth = opexYear / 12;
    
    _l_opexMngVal.text      = [UIUtil yenValue:opexMng];
    _l_opexPropTaxVal.text  = [UIUtil yenValue:opexPropTax];
    _l_opexYearVal.text     = [UIUtil yenValue:opexYear];
    _l_opexMonthVal.text    = [UIUtil yenValue:opexMonth];
    
    return;
}
//======================================================================
@end
//======================================================================

