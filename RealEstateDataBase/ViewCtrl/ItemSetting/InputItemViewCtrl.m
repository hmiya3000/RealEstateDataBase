//
//  InputItemViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/03.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputItemViewCtrl.h"
#import "Pos.h"
#import "UIUtil.h"
#import "ModelDB.h"
#import "ModelRE.h"
#import "AddonMgr.h"
#import "BuildYearPV.h"
#import "ConstructPV.h"

@interface InputItemViewCtrl ()
{
    ModelDB             *_db;
    ModelRE             *_modelRE;
    
    BuildYearPV         *_pv_build;
    ConstructPV         *_pv_construct;
    
    Pos                 *_pos;
    UIScrollView        *_scrollView;
    UILabel             *_l_title;
    UITextField         *_t_name;
    UIButton            *_btn_enter;
    UIButton            *_btn_cancel;

    NSInteger           _price;
    CGFloat             _interest;
    Loan                *_loan;
    CGFloat             _emptyRate;
    NSInteger           _rooms;
    NSInteger           _buildYear;
    NSInteger           _construct;
    NSInteger           _landPrice;
    CGFloat             _landArea;
    
    UILabel             *_l_price;
    UITextField         *_t_price;
    UILabel             *_l_interest;
    UITextField         *_t_interest;
    UILabel             *_l_loanBorrow;
    UITextField         *_t_loanBorrow;
    UILabel             *_l_rate;
    UITextField         *_t_rate;
    UILabel             *_l_period;
    UITextField         *_t_period;
    UILabel             *_l_rooms;
    UITextField         *_t_rooms;
    UILabel             *_l_emptyRate;
    UITextField         *_t_emptyRate;
    UILabel             *_l_construct;
    UIButton            *_b_construct;
    UILabel             *_l_buildYear;
    UIButton            *_b_buildYear;
    UILabel             *_l_address;
    UITextView          *_tv_address;
    UILabel             *_l_landArea;
    UITextField         *_t_landArea;
    UILabel             *_l_landPrice;
    UITextField         *_t_landPrice;

}
@end

@implementation InputItemViewCtrl

#define TTAG_NAME       1

#define BTAG_ENTER          1
#define BTAG_CANCEL         2
#define BTAG_BUILDYEAR      3
#define BTAG_CONSTRUCT      4

#define TTAG_PRICE          1
#define TTAG_INTEREST       2
#define TTAG_LOAN           3
#define TTAG_RATE           4
#define TTAG_PERIOD         5
#define TTAG_ROOMS          6
#define TTAG_ADDRESS        7
#define TTAG_LANDPRICE      8
#define TTAG_LANDAREA       9
/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        _db = [ModelDB sharedManager];
        _modelRE = [ModelRE sharedManager];
        _price              = 5000 * 10000;
        _interest           = 0.08;
        _loan = [[Loan alloc]initWithLoanBorrow:4000*10000
                                       rateYear:0.02
                                     periodYear:30
                                   levelPayment:true];
        _emptyRate          = 0.1;
        _rooms              = 8;
        _buildYear          = [UIUtil getThisYear];
        _construct          = CONST_WOOD;
        _landPrice          = 2000 * 10000;
        _landArea           = 100;
        
        
        self.title  = @"物件登録";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_title        = [UIUtil makeLabel:@"物件名を入力してください"];
    [_scrollView addSubview:_l_title];
    /****************************************/
    _t_name        = [UIUtil makeTextField:@"" tgt:self];
    _t_name.textAlignment   = NSTextAlignmentLeft;
    [_t_name   setTag:TTAG_NAME];
    [_t_name   setDelegate:(id)self];
    [_scrollView addSubview:_t_name];
    /****************************************/
    _btn_enter      = [UIUtil makeButton:@"決定" tag:BTAG_ENTER];
    [_btn_enter addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btn_enter];
    /****************************************/
    _btn_cancel     = [UIUtil makeButton:@"キャンセル" tag:BTAG_CANCEL];
    [_btn_cancel addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btn_cancel];
    /****************************************/

    /****************************************/
    _l_price        = [UIUtil makeLabel:@"価格[万]"];
    [_scrollView addSubview:_l_price];
    /*--------------------------------------*/
    _l_interest     = [UIUtil makeLabel:@"利回り[%]"];
    [_scrollView addSubview:_l_interest];
    /*--------------------------------------*/
    _l_buildYear     = [UIUtil makeLabel:@"建築年"];
    [_scrollView addSubview:_l_buildYear];
    /****************************************/
    _t_price        = [UIUtil makeTextFieldDec:@"5000" tgt:self];
    [_t_price     setTag:TTAG_PRICE];
    [_t_price     setDelegate:self];
    [_scrollView addSubview:_t_price];
    /*--------------------------------------*/
    _t_interest     = [UIUtil makeTextFieldDec:@"8.00" tgt:self];
    [_t_interest   setTag:TTAG_INTEREST];
    [_t_interest   setDelegate:self];
    [_scrollView addSubview:_t_interest];
    /*--------------------------------------*/
    _b_buildYear    = [UIUtil makeButton:@"" tag:BTAG_BUILDYEAR];
    [_b_buildYear addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_buildYear];
    /****************************************/
    _l_loanBorrow   = [UIUtil makeLabel:@"借入[万]"];
    [_scrollView addSubview:_l_loanBorrow];
    /*--------------------------------------*/
    _l_rate         = [UIUtil makeLabel:@"金利[%]"];
    [_scrollView addSubview:_l_rate];
    /*--------------------------------------*/
    _l_period       = [UIUtil makeLabel:@"借入年数"];
    [_scrollView addSubview:_l_period];
    /****************************************/
    _t_loanBorrow   = [UIUtil makeTextFieldDec:@"4000" tgt:self];
    [_t_loanBorrow     setTag:TTAG_LOAN];
    [_t_loanBorrow     setDelegate:self];
    [_scrollView addSubview:_t_loanBorrow];
    /*--------------------------------------*/
    _t_rate         = [UIUtil makeTextFieldDec:@"2.00" tgt:self];
    [_t_rate     setTag:TTAG_RATE];
    [_t_rate     setDelegate:self];
    [_scrollView addSubview:_t_rate];
    /*--------------------------------------*/
    _t_period       = [UIUtil makeTextFieldDec:@"30" tgt:self];
    [_t_period   setTag:TTAG_PERIOD];
    [_t_period   setDelegate:self];
    [_scrollView addSubview:_t_period];
    /****************************************/
    _l_emptyRate    = [UIUtil makeLabel:@"空室率[%]"];
    [_scrollView addSubview:_l_emptyRate];
    /*--------------------------------------*/
    _l_rooms        = [UIUtil makeLabel:@"戸数"];
    [_scrollView addSubview:_l_rooms];
    /*--------------------------------------*/
    _l_construct     = [UIUtil makeLabel:@"構造"];
    [_scrollView addSubview:_l_construct];
    /*--------------------------------------*/
    _b_construct    = [UIUtil makeButton:@"" tag:BTAG_CONSTRUCT];
    [_b_construct addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_construct];
    /****************************************/
    _t_emptyRate    = [UIUtil makeTextFieldDec:@"10.0" tgt:self];
    [_t_emptyRate     setTag:TTAG_RATE];
    [_t_emptyRate     setDelegate:self];
    [_scrollView addSubview:_t_emptyRate];
    /*--------------------------------------*/
    _t_rooms        = [UIUtil makeTextFieldDec:@"8" tgt:self];
    [_t_rooms       setTag:TTAG_ROOMS];
    [_t_rooms       setDelegate:(id)self];
    [_scrollView addSubview:_t_rooms];
    /****************************************/
    _l_address      = [UIUtil makeLabel:@"住所"];
    [_scrollView addSubview:_l_address];
    /*--------------------------------------*/
    _tv_address                = [[UITextView alloc]init];
    _tv_address.editable       = true;
    _tv_address.scrollEnabled  = true;
    _tv_address.backgroundColor = [UIColor whiteColor];
    _tv_address.text           = @"千代田区千代田内堀通り";
    [_tv_address   setTag:TTAG_ADDRESS];
    [_tv_address   setDelegate:(id)self];
    [_scrollView addSubview:_tv_address];
    /****************************************/
    _l_landArea   = [UIUtil makeLabel:@"土地面積[㎡]"];
    [_scrollView addSubview:_l_landArea];
    /*--------------------------------------*/
    _t_landArea     = [UIUtil makeTextFieldDec:@"10.0" tgt:self];
    [_t_landArea     setTag:TTAG_LANDAREA];
    [_t_landArea     setDelegate:self];
    [_scrollView addSubview:_t_landArea];
    /****************************************/
    _l_landPrice    = [UIUtil makeLabel:@"土地価格[万]"];
    [_scrollView addSubview:_l_landPrice];
    /*--------------------------------------*/
    _t_landPrice    = [UIUtil makeTextFieldDec:@"2000" tgt:self];
    [_t_landPrice     setTag:TTAG_LANDPRICE];
    [_t_landPrice     setDelegate:self];
    [_scrollView addSubview:_t_landPrice];
    /****************************************/

    _pv_build       = [[BuildYearPV   alloc]initWitTarget:self frame:self.view.bounds];
    _pv_construct   = [[ConstructPV   alloc]initWitTarget:self frame:self.view.bounds];
    
    
    
    /****************************************/
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    
    [self registerForKeyboardNotifications];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self rewriteProperty];
    [self viewMake];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    return;
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
    [_scrollView setFrame:CGRectMake(_pos.frame.origin.x,
                                     _pos.frame.origin.y+20,
                                     _pos.frame.size.width,
                                     _pos.frame.size.height)];
    /*--------------------------------------*/
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        if ( _pos.isPortrait == true ){
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2);
        } else {
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2.9);
        }
        _scrollView.bounces = YES;
    } else {
    }
    /****************************************/
    pos_y = 0;
    [UIUtil setLabel:_l_title x:pos_x y:pos_y length:length30];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setTextField:_t_name x:pos_x y:pos_y length:length30 ];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setButton:_btn_enter    x:pos_x         y:pos_y length:length];
    [UIUtil setButton:_btn_cancel   x:pos_x+dx*2    y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_price               x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setLabel:_l_interest            x:pos_x+dx*1    y:pos_y length:length];
    [UIUtil setLabel:_l_buildYear           x:pos_x+dx*2    y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setTextField:_t_price           x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setTextField:_t_interest        x:pos_x+dx*1    y:pos_y length:length];
    [UIUtil setTextButton:_b_buildYear      x:pos_x+dx*2    y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    if ( [model hasPrefix:@"iPhone"] ){
        [UIUtil setLabel:_l_landPrice       x:pos_x+dx*0    y:pos_y length:lengthR];
        [UIUtil setLabel:_l_landArea        x:pos_x+dx*1.5  y:pos_y length:lengthR];
    } else {
        [UIUtil setLabel:_l_landPrice       x:pos_x+dx*0    y:pos_y length:length];
        [UIUtil setLabel:_l_landArea        x:pos_x+dx*2    y:pos_y length:length];
    }
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setTextField:_t_landPrice       x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setTextField:_t_landArea        x:pos_x+dx*2    y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_construct           x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setLabel:_l_rooms               x:pos_x+dx*1    y:pos_y length:length];
    [UIUtil setLabel:_l_emptyRate           x:pos_x+dx*2    y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setTextButton:_b_construct      x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setTextField:_t_rooms           x:pos_x+dx*1    y:pos_y length:length];
    [UIUtil setTextField:_t_emptyRate       x:pos_x+dx*2    y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_loanBorrow          x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setLabel:_l_rate                x:pos_x+dx*1    y:pos_y length:length];
    [UIUtil setLabel:_l_period              x:pos_x+dx*2    y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setTextField:_t_loanBorrow      x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setTextField:_t_rate            x:pos_x+dx*1    y:pos_y length:length];
    [UIUtil setTextField:_t_period          x:pos_x+dx*2    y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_address             x:pos_x         y:pos_y length:length];
    pos_y = pos_y + dy;
    _tv_address.frame   = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
    pos_y = pos_y + dy;
    /****************************************/
    return;
}

/****************************************************************
 * 回転していいかの判別
 ****************************************************************/
- (BOOL)shouldAutorotate
{
    return YES;
}

/****************************************************************
 * 回転処理の許可
 ****************************************************************/
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //    NSLog(@"%s",__FUNCTION__);
    //    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskAll;
}

/****************************************************************
 * 回転時に処理したい内容
 ****************************************************************/
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            [_scrollView setContentOffset:CGPointZero animated:YES];
            break;
        default:
            break;
    }

    [self viewMake];
}

/****************************************************************
 * Returnでキーボードを閉じる
 ****************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
- (BOOL)closePopup:(id)sender
{
    _construct              = _pv_construct.construct;
    _buildYear              = _pv_build.year;
    [self rewriteProperty];
    return YES;
    
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
 * ビューがタップされたとき
 ****************************************************************/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [_t_name resignFirstResponder];
    [_tv_address resignFirstResponder];
//    NSLog(@"タップされました．");
}

/****************************************************************
 *
 ****************************************************************/
-(void) readTextFieldData
{
    /*--------------------------------------*/
    _price  = [_t_price.text integerValue] * 10000;
    /*--------------------------------------*/
    _landPrice  = [_t_landPrice.text integerValue] * 10000;
    /*--------------------------------------*/
    _landArea   = [_t_landArea.text floatValue];
    /*--------------------------------------*/
    float tmp_interest;
    tmp_interest = [_t_interest.text floatValue]/100;
    if ( 100 > tmp_interest && tmp_interest >  0 ){
        _interest               = tmp_interest;
    }
    /*--------------------------------------*/
    _loan.loanBorrow    = [_t_loanBorrow.text integerValue] * 10000;
    /*--------------------------------------*/
    float tmp_rate;
    tmp_rate = [_t_rate.text floatValue]/100;
    if ( 100 > tmp_rate && tmp_rate >  0 ){
        _loan.rateYear          = tmp_rate;
    }
    /*--------------------------------------*/
    NSInteger tmp_period;
    tmp_period = [_t_period.text integerValue];
    if ( 100 > tmp_period && tmp_period > 0 ){
        _loan.periodYear = tmp_period;
        
    }
    /*--------------------------------------*/
    AddonMgr *addonMgr = [AddonMgr sharedManager];
    if ( addonMgr.opeSetting == true ){
        float tmp_emptyRate;
        tmp_emptyRate           = [_t_emptyRate.text    floatValue]/100;
        if ( tmp_emptyRate < 100 && tmp_emptyRate >= 0 ){
            _emptyRate          = tmp_emptyRate;
        }
    }
    /*--------------------------------------*/
    NSInteger tmp_rooms;
    tmp_rooms   = [_t_rooms.text integerValue];
    if ( tmp_rooms <= 100 && tmp_rooms > 0 ){
        _rooms  = tmp_rooms;
    }
    /*--------------------------------------*/
    [self rewriteProperty];
}

/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_ENTER ){
        if ( [_t_name.text length] != 0 ){            
            if (  [_db isInitialized] == true ){
                AddonMgr *addonMgr = [AddonMgr sharedManager];
                [addonMgr activateFriend:_t_name.text];
            }
            [_db createRec:_t_name.text atIndex:0];
            [_db loadIndex:0];
            //------------------------------
            [_modelRE setPrice:_price];
            NSInteger   gpi   = _price * _interest;
            _modelRE.estate.prices.gpi      = gpi;
            _modelRE.investment.prices.gpi  = gpi;
            _modelRE.investment.loan.loanBorrow     = _loan.loanBorrow;
            _modelRE.investment.loan.rateYear       = _loan.rateYear;
            _modelRE.investment.loan.periodYear     = _loan.periodYear;
            _modelRE.investment.emptyRate           = _emptyRate;
            _modelRE.estate.house.rooms             = _rooms;
            _modelRE.estate.land.price              = _landPrice;
            _modelRE.estate.land.area               = _landArea;
            _modelRE.estate.land.address            = _tv_address.text;
            _modelRE.estate.house.buildYear         = _buildYear;
            _modelRE.estate.house.construct         = _construct;
            [_modelRE autoInput];
            [_modelRE valToFile];
            
            //------------------------------
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if ( sender.tag == BTAG_CANCEL ){
        if ( _db.list.count != 0 ){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if ( sender.tag == BTAG_BUILDYEAR ){
        [_pv_build setIndex_year:_buildYear];
        [_pv_build showPickerView:self.view];


    } else if ( sender.tag == BTAG_CONSTRUCT ){
        [_pv_construct setIndex_construct:_construct];
        [_pv_construct showPickerView:self.view];
        
    }
   
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

/****************************************************************
 *
 ****************************************************************/
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGPoint scrollPoint = CGPointMake(0.0,20.0);
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [_scrollView setContentOffset:scrollPoint animated:YES];
            break;
        default:
            break;
    }
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
    return;
}

/****************************************************************
 *
 ****************************************************************/
-(void)rewriteProperty
{
    [_b_buildYear setTitle:[NSString stringWithFormat:@"%4d",(int)_buildYear] forState:UIControlStateNormal];
    [_b_construct setTitle:[NSString stringWithFormat:@"%@",[House constructStr:_construct] ] forState:UIControlStateNormal];

    _t_price.text       = [NSString stringWithFormat:@"%ld",_price/10000];
    _t_landPrice.text   = [NSString stringWithFormat:@"%ld",_landPrice/10000];
    _t_landArea.text    = [NSString stringWithFormat:@"%g",_landArea];
    _t_interest.text    = [NSString stringWithFormat:@"%2.2f",_interest*100];
    _t_loanBorrow.text  = [NSString stringWithFormat:@"%ld",_loan.loanBorrow/10000];
    _t_rate.text        = [NSString stringWithFormat:@"%1.2f",_loan.rateYear*100];
    _t_period.text      = [NSString stringWithFormat:@"%ld",(long)_loan.periodYear];
    _t_emptyRate.text   = [NSString stringWithFormat:@"%g",_emptyRate*100];
    _t_rooms.text       = [NSString stringWithFormat:@"%ld",(long) _rooms];
}

@end
