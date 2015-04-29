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
    CGFloat             _declineRate;
    CGFloat             _emptyRate;
    CGFloat             _mngRate;
    
    UILabel             *_l_bg;
    UILabel             *_l_declineRate;
    UILabel             *_l_emptyRate;
    UILabel             *_l_mngRate;
    
    UITextField         *_t_declineRate;
    UITextField         *_t_emptyRate;
    UITextField         *_t_mngRate;
    
    
    UITextView          *_tv_tips;
    
    UILabel             *_l_loanBorrow;
    UILabel             *_l_loanBorrowVal;
    
    UILabel             *_l_payMonth;
    UILabel             *_l_payMonthVal;
    UILabel             *_l_payYear;
    UILabel             *_l_payYearVal;

}
@end

@implementation InputOperationViewCtrl

#define TTAG_DECLINE        1
#define TTAG_EMPTY          2
#define TTAG_MNG            3

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"運営設定";
    _declineRate    = _modelRE.declineRate;
    _emptyRate      = _modelRE.investment.emptyRate;
    _mngRate        = _modelRE.investment.mngRate;
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_bg           = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_bg];
    /****************************************/
    _l_declineRate      = [UIUtil makeLabel:@"家賃下落率[%]"];
    [_scrollView addSubview:_l_declineRate];
    /*--------------------------------------*/
    _l_emptyRate        = [UIUtil makeLabel:@"空室率[%]"];
    [_scrollView addSubview:_l_emptyRate];
    /*--------------------------------------*/
    _l_mngRate          = [UIUtil makeLabel:@"管理費割合[%]"];
    [_scrollView addSubview:_l_mngRate];
    /****************************************/
    _t_declineRate      = [UIUtil makeTextFieldDec:@"0.00" tgt:self];
    [_t_declineRate     setTag:TTAG_DECLINE];
    [_t_declineRate     setDelegate:(id)self];
    [_scrollView addSubview:_t_declineRate];
    /*--------------------------------------*/
    _t_emptyRate        = [UIUtil makeTextFieldDec:@"0.00" tgt:self];
    [_t_emptyRate   setTag:TTAG_EMPTY];
    [_t_emptyRate   setDelegate:(id)self];
    [_scrollView addSubview:_t_emptyRate];
    /*--------------------------------------*/
    _t_mngRate          = [UIUtil makeTextFieldDec:@"0.00" tgt:self];
    [_t_mngRate   setTag:TTAG_MNG];
    [_t_mngRate   setDelegate:(id)self];
    [_scrollView addSubview:_t_mngRate];
#if 0
    /****************************************/
    _l_loanBorrow           = [UIUtil makeLabel:@"借入金"];
    [_l_loanBorrow setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_loanBorrow];
    /****************************************/
    _l_loanBorrowVal        = [UIUtil makeLabel:[NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_modelRE.investment.loan.loanBorrow/10000]]];
    [_l_loanBorrowVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_loanBorrowVal];
    /****************************************/
    _l_payMonth  = [UIUtil makeLabel:@"初回返済額(月)"];
    [_l_payMonth setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_payMonth];
    /****************************************/
    _l_payMonthVal      = [UIUtil makeLabel:@"999,999円"];
    [_l_payMonthVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_payMonthVal];
    /****************************************/
    _l_payYear          = [UIUtil makeLabel:@"初年度返済額(年)"];
    [_l_payYear setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_payYear];
    /****************************************/
    _l_payYearVal       = [UIUtil makeLabel:@"9,999,999円"];
    [_l_payYearVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_payYearVal];
    /****************************************/
    _g_pmt = [[Graph alloc]init];
    [_scrollView addSubview:_g_pmt];
#endif
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"家賃下落率は毎年の潜在総収入(GPI)の下落率を設定します\n空室率はGPIに対する空室損を一定比率で見込みます\n管理費割合は集金額に対する管理費の割合で、管理費はほぼ運営費になります"];
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
    [self rewriteProperty];
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
        [UIUtil setLabel:_l_declineRate         x:pos_x         y:pos_y length:length];
        [UIUtil setLabel:_l_emptyRate           x:pos_x+dx      y:pos_y length:length];
        [UIUtil setLabel:_l_mngRate             x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setTextField:_t_declineRate     x:pos_x         y:pos_y length:length];
        [UIUtil setTextField:_t_emptyRate       x:pos_x+dx      y:pos_y length:length];
        [UIUtil setTextField:_t_mngRate         x:pos_x+dx*2    y:pos_y length:length];

#if 0
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_loanBorrow      x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_loanBorrowVal   x:_pos.x_center y:pos_y length:_pos.len15];
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_payMonth        x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_payMonthVal     x:_pos.x_center y:pos_y length:_pos.len15];
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_payYear         x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_payYearVal      x:_pos.x_center y:pos_y length:_pos.len15];
#endif
        /****************************************/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*3);
        /****************************************/
    }else {
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:_pos.x_left   y:pos_y viewWidth:_pos.len30 viewHeight:dy*2 color:[UIUtil color_Ivory]];
        [UIUtil setLabel:_l_declineRate         x:pos_x         y:pos_y length:length];
        [UIUtil setLabel:_l_emptyRate           x:pos_x+dx      y:pos_y length:length];
        [UIUtil setLabel:_l_mngRate             x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setTextField:_t_declineRate     x:pos_x         y:pos_y length:length];
        [UIUtil setTextField:_t_emptyRate       x:pos_x+dx      y:pos_y length:length];
        [UIUtil setTextField:_t_mngRate         x:pos_x+dx*2    y:pos_y length:length];
#if 0
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_loanBorrow      x:pos_x             y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_loanBorrowVal   x:_pos.x_center/2   y:pos_y length:_pos.len15/2];
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_payMonth        x:pos_x             y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_payMonthVal     x:_pos.x_center/2   y:pos_y length:_pos.len15/2];
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_payYear         x:pos_x             y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_payYearVal      x:_pos.x_center/2   y:pos_y length:_pos.len15/2];
#endif
        /****************************************/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*3);
        /****************************************/
    }
    
    return;
}

/****************************************************************
 * ビューがタップされたとき
 ****************************************************************/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    //    [_t_name resignFirstResponder];
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
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
    [self readTextFieldData];
}
/****************************************************************
 *
 ****************************************************************/
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self readTextFieldData];
    return YES;
}

/****************************************************************
 *
 ****************************************************************/
-(void) readTextFieldData
{
    /*--------------------------------------*/
    float tmp_declineRate;
    tmp_declineRate         = [_t_declineRate.text  floatValue]/100;
    if ( tmp_declineRate < 100 && tmp_declineRate >= 0 ){
        _declineRate        = tmp_declineRate;
    }
    /*--------------------------------------*/
    float tmp_emptyRate;
    tmp_emptyRate           = [_t_emptyRate.text    floatValue]/100;
    if ( tmp_emptyRate < 100 && tmp_emptyRate >= 0 ){
        _emptyRate          = tmp_emptyRate;
    }
    /*--------------------------------------*/
    float tmp_mngRate;
    tmp_mngRate             = [_t_mngRate.text      floatValue]/100;
    if ( tmp_mngRate < 100 && tmp_mngRate >= 0 ){
        _mngRate                = tmp_mngRate;
    }
    /*--------------------------------------*/
    [self rewriteProperty];
}


/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    _modelRE.declineRate            = _declineRate;
    _modelRE.investment.emptyRate   = _emptyRate;
    _modelRE.investment.mngRate     = _mngRate;
    [_modelRE valToFile];

    [self.navigationController popViewControllerAnimated:YES];
    return;
}

/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/

/****************************************************************
 *
 ****************************************************************/
-(void)rewriteProperty
{
    _t_declineRate.text = [NSString stringWithFormat:@"%g",_declineRate*100];
    _t_emptyRate.text   = [NSString stringWithFormat:@"%g",_emptyRate*100];
    _t_mngRate.text     = [NSString stringWithFormat:@"%g",_mngRate*100];
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
