//
//  InputLoanSettingViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/24.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputLoanSettingViewCtrl.h"
#import "Graph.h"
#import "GraphData.h"
#import "LoanPeriodPV.h"

@interface InputLoanSettingViewCtrl ()
{
    Loan                *_loan;
    
    LoanPeriodPV        *_periodPV;

    UILabel             *_l_bg;
    UILabel             *_l_rate;
    UILabel             *_l_period;
    UILabel             *_l_loanPattern;
    
    UITextField         *_t_rate;
    UITextField         *_t_period;
    UIButton            *_b_period;
    UIButton            *_b_loanPattern;

    
    UITextView          *_tv_tips;
    
    UILabel             *_l_loanBorrow;
    UILabel             *_l_loanBorrowVal;

    UILabel             *_l_payMonth;
    UILabel             *_l_payMonthVal;
    UILabel             *_l_payYear;
    UILabel             *_l_payYearVal;
    Graph               *_g_pmt;
    
}

@end

@implementation InputLoanSettingViewCtrl

#define BTAG_PERIOD         1
#define BTAG_LOAN_PATTERN   2

#define TTAG_RATE           1
#define TTAG_PERIOD         2
#define TTAG_NAME           3

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"金利設定";
    
    _loan = [[Loan alloc]initWithLoanBorrow:_modelRE.investment.loan.loanBorrow
                                   rateYear:_modelRE.investment.loan.rateYear
                                 periodTerm:_modelRE.investment.loan.periodTerm
                               levelPayment:_modelRE.investment.loan.levelPayment];
    
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_bg           = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_bg];
    /****************************************/
    _l_rate         = [UIUtil makeLabel:@"金利[%]"];
    [_scrollView addSubview:_l_rate];
    /*--------------------------------------*/
    _l_period       = [UIUtil makeLabel:@"借入年数"];
    [_scrollView addSubview:_l_period];
    /*--------------------------------------*/
    _l_loanPattern  = [UIUtil makeLabel:@"返済方式"];
    [_scrollView addSubview:_l_loanPattern];
    /****************************************/
    _t_rate         = [UIUtil makeTextFieldDec:@"0.00" tgt:self];
    [_t_rate     setTag:TTAG_RATE];
    [_t_rate     setDelegate:self];
    [_scrollView addSubview:_t_rate];
    /*--------------------------------------*/
#if 0
    _t_period       = [UIUtil makeTextFieldDec:@"99" tgt:self];
    [_t_period   setTag:TTAG_PERIOD];
    [_t_period   setDelegate:self];
    [_scrollView addSubview:_t_period];
#endif
    /*--------------------------------------*/
    _b_period    = [UIUtil makeButton:@"" tag:BTAG_PERIOD];
    [_b_period addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_period];
    /*--------------------------------------*/
    _b_loanPattern    = [UIUtil makeButton:@"" tag:BTAG_LOAN_PATTERN];
    [_b_loanPattern addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_loanPattern];
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
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"耐用年数を元に銀行は借入期間を設定します"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;

    _periodPV = [[LoanPeriodPV alloc]initWitTarget:self frame:self.view.bounds];

    
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
        [UIUtil setRectLabel:_l_bg              x:_pos.x_left   y:pos_y         viewWidth:_pos.len30 viewHeight:dy*2 color:[UIUtil color_Ivory]];
        [UIUtil setLabel:_l_rate                x:pos_x         y:pos_y length:length];
        [UIUtil setLabel:_l_period              x:pos_x+dx      y:pos_y length:length];
        [UIUtil setLabel:_l_loanPattern         x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setTextField:_t_rate            x:pos_x         y:pos_y length:length];
//        [UIUtil setTextField:_t_period          x:pos_x+dx      y:pos_y length:length];
        [UIUtil setTextButton:_b_period         x:pos_x+dx*1    y:pos_y length:length];
        [UIUtil setTextButton:_b_loanPattern    x:pos_x+dx*2    y:pos_y length:length];
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
        /****************************************/
        pos_y = pos_y + dy*0.6;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*1.2);
        /****************************************/
        pos_y = pos_y + dy*1.5;
        [_g_pmt setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    }else {
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:_pos.x_left   y:pos_y         viewWidth:_pos.len30 viewHeight:dy*2 color:[UIUtil color_Ivory]];
        [UIUtil setLabel:_l_rate                x:pos_x         y:pos_y length:length];
        [UIUtil setLabel:_l_period              x:pos_x+dx      y:pos_y length:length];
        [UIUtil setLabel:_l_loanPattern         x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setTextField:_t_rate            x:pos_x         y:pos_y length:length];
//        [UIUtil setTextField:_t_period          x:pos_x+dx      y:pos_y length:length];
        [UIUtil setTextButton:_b_period         x:pos_x+dx*1    y:pos_y length:length];
        [UIUtil setTextButton:_b_loanPattern    x:pos_x+dx*2    y:pos_y length:length];
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
        /****************************************/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*1.5);

        /****************************************/
        pos_y = 2.2*dy;
        [_g_pmt setFrame:CGRectMake(_pos.x_center, pos_y, _pos.len15, dy*4.5)];
    }
    [_g_pmt setNeedsDisplay];
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
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self readTextFieldData];
    return YES;
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
-(void) readTextFieldData
{
    /*--------------------------------------*/
    float tmp_rate;
    tmp_rate = [_t_rate.text floatValue]/100;
    if ( 1 > tmp_rate && tmp_rate >  0 ){
        _loan.rateYear          = tmp_rate;
    }
    /*--------------------------------------*/
    NSInteger tmp_period;
    tmp_period = [_t_period.text integerValue];
    if ( 100 > tmp_period && tmp_period > 0 ){
        _loan.periodTerm = tmp_period*12;
    
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
        _modelRE.investment.loan.rateYear       = _loan.rateYear;
        _modelRE.investment.loan.periodTerm     = _loan.periodTerm;
        _modelRE.investment.loan.levelPayment   = _loan.levelPayment;
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
    if (sender.tag == BTAG_LOAN_PATTERN){
#if 0
        if ( _loan.levelPayment == true){
            _loan.levelPayment = false;
        } else {
            _loan.levelPayment = true;
        }
#else
        //元利金等方式のみ。切り替えナシ
        _loan.levelPayment = true;
#endif
        [self rewriteProperty];
    } else if (sender.tag == BTAG_PERIOD){
        [_periodPV setIndex_year:_loan.periodTerm/12 month:_loan.periodTerm%12];
        [_periodPV showPickerView:self.view];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return;
}

//======================================================================
//
//======================================================================
-(BOOL)closePopup:(id)sender
{
    _loan.periodTerm = _periodPV.year*12 + _periodPV.month;
    [self rewriteProperty];
    return YES;
    
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
    _t_rate.text        = [NSString stringWithFormat:@"%g",_loan.rateYear*100];
    _t_period.text      = [NSString stringWithFormat:@"%ld",(long)_loan.periodTerm/12];

    NSString *periodStr;
    if ( _loan.periodTerm%12 != 0 ){
        periodStr = [NSString stringWithFormat:@"%ld年%ldヶ月",
                     _loan.periodTerm/12,
                     _loan.periodTerm%12];
    } else {
        periodStr = [NSString stringWithFormat:@"%ld年",
                     _loan.periodTerm/12];
        
    }
    [_b_period setTitle:periodStr forState:UIControlStateNormal];

    if (_loan.levelPayment == true ){
        [_b_loanPattern setTitle:@"元利均等" forState:UIControlStateNormal];
    }else {
        [_b_loanPattern setTitle:@"元金均等" forState:UIControlStateNormal];
    }
    _l_payMonthVal.text = [NSString stringWithFormat:@"%@円",[UIUtil yenValue:[_loan getPmt:1]]];
    _l_payYearVal.text  = [NSString stringWithFormat:@"%@円",[UIUtil yenValue:[_loan getPmtYear:1]]];
    

    GraphData *gd_pmt   = [[GraphData alloc]initWithData:[_loan getPmtArrayYear]];
    gd_pmt.precedent    = @"利息返済分";
    gd_pmt.type         = BAR_GPAPH;
    
    GraphData *gd_ppmt  = [[GraphData alloc]initWithData:[_loan getPpmtArrayYear]];
    gd_ppmt.precedent   = @"元金返済分";
    gd_ppmt.type        = BAR_GPAPH;
    
    [_g_pmt setGraphDataAll:[[NSArray alloc]initWithObjects:gd_pmt,gd_ppmt,nil]];
    [_g_pmt setGraphtMinMax_xmin:0 ymin:0 xmax:_loan.periodTerm/12+1 ymax:[_loan getPmtYear:1]];
    _g_pmt.title        = @"借入返済内訳";
    [_g_pmt setNeedsDisplay];
}
//======================================================================
@end
//======================================================================
