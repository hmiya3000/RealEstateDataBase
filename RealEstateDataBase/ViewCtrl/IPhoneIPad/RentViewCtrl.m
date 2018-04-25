//
//  RentViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2016/02/27.
//  Copyright © 2016年 Beetre. All rights reserved.
//

#import "RentViewCtrl.h"
#import "ModelRE.h"
#import "UIUtil.h"
#import "Pos.h"

@interface RentViewCtrl ()
{
    
    UIScrollView            *_scrollView;
    UILabel                 *_l_title;
    UILabel                 *_l_interest;
    UILabel                 *_l_gpi;
    UILabel                 *_l_gpiMonth;
    UILabel                 *_l_rooms;
    UILabel                 *_l_floorArea;
    UILabel                 *_l_rentMonth;
    UILabel                 *_l_roomArea;

    UILabel                 *_l_interestVal;
    UILabel                 *_l_gpiVal;
    UILabel                 *_l_gpiMonthVal;
    UITextField             *_t_rooms;
    UITextField             *_t_floorArea;
    UILabel                 *_l_rentMonthVal;
    UILabel                 *_l_roomAreaVal;

    UILabel                 *_l_titleOpe;
    UILabel                 *_l_opeGpi;
    UILabel                 *_l_opeGpiVal;
    UILabel                 *_l_opeEmptyLoss;
    UILabel                 *_l_opeEmptyLossVal;
    UILabel                 *_l_opeEgi;
    UILabel                 *_l_opeEgiVal;
    UILabel                 *_l_opeOpex;
    UILabel                 *_l_opeOpexVal;
    UILabel                 *_l_opeNoi;
    UILabel                 *_l_opeNoiVal;
    UILabel                 *_l_opeAds;
    UILabel                 *_l_opeAdsVal;
    UILabel                 *_l_opeBtcf;
    UILabel                 *_l_opeBtcfVal;
    
    UISlider                *_sl;
    UIButton                *_b_rent;
    
    NSInteger               _gpi;
    NSInteger               _price;
    NSInteger               _rooms;
    CGFloat                 _floorArea;
    
}
@end
//======================================================================

@implementation RentViewCtrl
//======================================================================

#define TTAG_ROOMS          4
#define TTAG_FLOOR_AREA     5
#define BTAG_RENT           1
//======================================================================
//
//======================================================================
/*
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"利回り確認";
        self.tabBarItem.image = [UIImage imageNamed:@"operation.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _masterVC   = nil;
    }
    return self;
}*/
//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title  = @"利回り検証";
    _gpi        = _modelRE.investment.gpi;
    _price      = _modelRE.investment.price;
    _rooms      = _modelRE.estate.house.rooms;
    _floorArea  = _modelRE.estate.house.area;
    
    
    
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_title        = [UIUtil makeLabel:@"利回りの妥当性を確認してください"];
    [_scrollView addSubview:_l_title];
    /****************************************/
    _l_interest     = [UIUtil makeLabel:@"表面利回り"];
    [_scrollView addSubview:_l_interest];
    /*--------------------------------------*/
    _l_interestVal  = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_interestVal];
    /****************************************/
    _l_gpi          = [UIUtil makeLabel:@"想定年収"];
    [_scrollView addSubview:_l_gpi];
    /*--------------------------------------*/
    _l_gpiVal  = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_gpiVal];
    /****************************************/
    _l_gpiMonth     = [UIUtil makeLabel:@"想定月収"];
    [_scrollView addSubview:_l_gpiMonth];
    /*--------------------------------------*/
    _l_gpiMonthVal  = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_gpiMonthVal];
    /****************************************/
    _l_rooms        = [UIUtil makeLabel:@"部屋数"];
    [_scrollView addSubview:_l_rooms];
    /*--------------------------------------*/
    _t_rooms        = [UIUtil makeTextFieldDec:@"" tgt:self];
    _t_rooms.textAlignment   = NSTextAlignmentCenter;
    [_t_rooms   setTag:TTAG_ROOMS];
    [_t_rooms     setDelegate:self];
    [_scrollView addSubview:_t_rooms];
    /****************************************/
    _l_floorArea    = [UIUtil makeLabel:@"床面積"];
    [_scrollView addSubview:_l_floorArea];
    /*--------------------------------------*/
    _t_floorArea    = [UIUtil makeTextFieldDec:@"" tgt:self];
    _t_floorArea.textAlignment   = NSTextAlignmentCenter;
    [_t_floorArea   setTag:TTAG_FLOOR_AREA];
    [_t_floorArea     setDelegate:self];
    [_scrollView addSubview:_t_floorArea];
    /****************************************/
    _l_rentMonth    = [UIUtil makeLabel:@"家賃共益費"];
    [_scrollView addSubview:_l_rentMonth];
    /*--------------------------------------*/
    _l_rentMonthVal  = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_rentMonthVal];
    /****************************************/
    _l_roomArea     = [UIUtil makeLabel:@"部屋面積"];
    [_scrollView addSubview:_l_roomArea];
    /*--------------------------------------*/
    _l_roomAreaVal  = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_roomAreaVal];
    /****************************************/
    _sl             = [[UISlider alloc]init];
    _sl.minimumValue = 0.8;  // 最小値を0に設定
    _sl.maximumValue = 1.2;  // 最大値を500に設定
    _sl.value = 1.0;  // 初期値を250に設定
    // 値が変更された時にhogeメソッドを呼び出す
    [_sl addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_sl];
    /****************************************/
    _b_rent = [UIUtil makeButton:@"家賃相場" tag:BTAG_RENT];
    [_b_rent addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_rent];
    /****************************************/
    _l_titleOpe    = [UIUtil makeLabel:@"月々の収支(初年度)"];
    [_scrollView addSubview:_l_titleOpe];
    /****************************************/
    _l_opeGpi       = [UIUtil makeLabel:@"潜在総収入"];
    [_l_opeGpi setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opeGpi];
    /*--------------------------------------*/
    _l_opeGpiVal  = [UIUtil makeLabel:@""];
    [_l_opeGpiVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opeGpiVal];
    /****************************************/
    _l_opeEmptyLoss = [UIUtil makeLabel:[NSString stringWithFormat:@"空室損(%2.1f%%)",_modelRE.investment.emptyRate*100]];
    [_l_opeEmptyLoss setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opeEmptyLoss];
    /*--------------------------------------*/
    _l_opeEmptyLossVal  = [UIUtil makeLabel:@""];
    [_l_opeEmptyLossVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opeEmptyLossVal];
    /****************************************/
    _l_opeEgi = [UIUtil makeLabel:@"実効総収入"];
    [_l_opeEgi setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opeEgi];
    /*--------------------------------------*/
    _l_opeEgiVal  = [UIUtil makeLabel:@""];
    [_l_opeEgiVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opeEgiVal];
    /****************************************/
    _l_opeOpex = [UIUtil makeLabel:[NSString stringWithFormat:@"管理費(%2.1f%%)",_modelRE.investment.mngRate *100]];
    [_l_opeOpex setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opeOpex];
    /*--------------------------------------*/
    _l_opeOpexVal  = [UIUtil makeLabel:@""];
    [_l_opeOpexVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opeOpexVal];
    /****************************************/
    _l_opeNoi = [UIUtil makeLabel:@"営業利益"];
    [_l_opeNoi setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opeNoi];
    /*--------------------------------------*/
    _l_opeNoiVal  = [UIUtil makeLabel:@""];
    [_l_opeNoiVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opeNoiVal];
    /****************************************/
    _l_opeAds = [UIUtil makeLabel:[NSString stringWithFormat:@"借入返済(%1.2f%%,%ld年)",
                                   _modelRE.investment.loan.rateYear*100,
                                   _modelRE.investment.loan.periodTerm/12]];
    [_l_opeAds setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opeAds];
    /*--------------------------------------*/
    _l_opeAdsVal  = [UIUtil makeLabel:@""];
    [_l_opeAdsVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opeAdsVal];
    /****************************************/
    _l_opeBtcf = [UIUtil makeLabel:@"税引前CF"];
    [_l_opeBtcf setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opeBtcf];
    /*--------------------------------------*/
    _l_opeBtcfVal  = [UIUtil makeLabel:@""];
    [_l_opeBtcfVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opeBtcfVal];
    /****************************************/
    
    
    
    /****************************************/
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    
    [self registerForKeyboardNotifications];
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
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy*0.8;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    length30    = _pos.len30;
    /****************************************/
    [_scrollView setFrame:_pos.frame];
    /*--------------------------------------*/
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        if ( _pos.isPortrait == true ){
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2);
        } else {
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*3);
        }
    } else {
        _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*1.5);
    }
    _scrollView.bounces = YES;
    /****************************************/
    pos_y = 0.2*dy;
    /*--------------------------------------*/
    [UIUtil setRectLabel:_l_title x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_interest        x:pos_x         y:pos_y length:length];
    [UIUtil setLabel:_l_interestVal     x:pos_x +2*dx   y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_gpi             x:pos_x +0*dx   y:pos_y length:length];
    [UIUtil setLabel:_l_gpiMonth        x:pos_x +1*dx   y:pos_y length:length];
    [UIUtil setLabel:_l_rentMonth       x:pos_x +2*dx   y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_gpiVal          x:pos_x +0*dx   y:pos_y length:length];
    [UIUtil setLabel:_l_gpiMonthVal     x:pos_x +1*dx   y:pos_y length:length];
    [UIUtil setLabel:_l_rentMonthVal    x:pos_x +2*dx   y:pos_y length:length ];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_floorArea       x:pos_x +0*dx   y:pos_y length:length];
    [UIUtil setLabel:_l_rooms           x:pos_x +1*dx   y:pos_y length:length];
    [UIUtil setLabel:_l_roomArea        x:pos_x +2*dx   y:pos_y length:length];

    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setTextField:_t_floorArea   x:pos_x +0*dx   y:pos_y length:length ];
    [UIUtil setTextField:_t_rooms       x:pos_x +1*dx   y:pos_y length:length ];
    [UIUtil setLabel:_l_roomAreaVal     x:pos_x +2*dx   y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + 1.5*dy;
    [UIUtil setButton:_b_rent x:pos_x   y:pos_y length:length ];
    [_sl setFrame:CGRectMake(       pos_x+dx, pos_y,length*2,dy)];
    pos_y = pos_y + dy;
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    /*--------------------------------------*/
    [UIUtil setRectLabel:_l_titleOpe x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_opeGpi          x:pos_x +0*dx   y:pos_y length:length*1.5];
    [UIUtil setLabel:_l_opeGpiVal       x:pos_x +2*dx y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_opeEmptyLoss    x:pos_x +0*dx   y:pos_y length:length*1.5];
    [UIUtil setLabel:_l_opeEmptyLossVal x:pos_x +2*dx y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_opeEgi          x:pos_x +0*dx   y:pos_y length:length*1.5];
    [UIUtil setLabel:_l_opeEgiVal       x:pos_x +2*dx y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_opeOpex         x:pos_x +0*dx   y:pos_y length:length*1.5];
    [UIUtil setLabel:_l_opeOpexVal      x:pos_x +2*dx y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_opeNoi          x:pos_x +0*dx   y:pos_y length:length*1.5];
    [UIUtil setLabel:_l_opeNoiVal       x:pos_x +2*dx y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_opeAds          x:pos_x +0*dx   y:pos_y length:length*2];
    [UIUtil setLabel:_l_opeAdsVal       x:pos_x +2*dx y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_opeBtcf         x:pos_x +0*dx   y:pos_y length:length*1.5];
    [UIUtil setLabel:_l_opeBtcfVal      x:pos_x +2*dx y:pos_y length:length];
    return;
}

//======================================================================
// 回転していいかの判別
//======================================================================
-(BOOL)shouldAutorotate
{
    return YES;
}

//======================================================================
// 回転処理の許可
//======================================================================
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

//======================================================================
// 回転時に処理したい内容
//======================================================================
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            break;
        default:
            break;
    }
    [self viewMake];
}
//======================================================================
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{
    /****************************************/
    _l_interestVal.text     = [NSString stringWithFormat:@"%2.2f%%",(float)_gpi*100/_price];
    _l_gpiVal.text          = [NSString stringWithFormat:@"%.1f万",(float)_gpi/10000];
    _l_gpiMonthVal.text     = [NSString stringWithFormat:@"%.1f万",(float)_gpi/12/10000];
    _t_rooms.text           = [NSString stringWithFormat:@"%d",(int)_rooms];
    _t_floorArea.text       = [NSString stringWithFormat:@"%3.1f",(float)_floorArea];
    [UIUtil labelYen:_l_rentMonthVal yen:(NSInteger)(_gpi/ 12.0/ _rooms)];
    _l_roomAreaVal.text     = [NSString stringWithFormat:@"〜%2.1f㎡",(float)_floorArea/ _rooms];
    /****************************************/
    NSInteger gpi       = _gpi/12;
    NSInteger emptyLoss = gpi*_modelRE.investment.emptyRate;
    NSInteger egi       = gpi - emptyLoss;
    NSInteger opex      = egi* _modelRE.investment.mngRate;
    NSInteger noi       = egi - opex;
    NSInteger ads       = [_modelRE.investment.loan getPmt:1];
    NSInteger btcf      = noi - ads;
    
    [UIUtil labelYen:_l_opeGpiVal       yen:gpi];
    [UIUtil labelYen:_l_opeEmptyLossVal yen:-emptyLoss];
    [UIUtil labelYen:_l_opeEgiVal       yen:egi];
    [UIUtil labelYen:_l_opeOpexVal      yen:-opex];
    [UIUtil labelYen:_l_opeNoiVal       yen:noi];
    [UIUtil labelYen:_l_opeAdsVal       yen:-ads];
    [UIUtil labelYen:_l_opeBtcfVal      yen:btcf];
    /****************************************/
    
}
//======================================================================
// Returnでキーボードを閉じる
//======================================================================
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [_t_rooms resignFirstResponder];
    [_t_floorArea resignFirstResponder];
    
    //    NSLog(@"タップされました．");
}

//======================================================================
//
//======================================================================
-(void) readTextFieldData
{
    _rooms  = [_t_rooms.text integerValue];
    _floorArea  = [_t_floorArea.text floatValue];
    if( _modelRE.investment.gpi != 0){
        _sl.value = (float)_gpi/_modelRE.investment.gpi;
    } else {
        _sl.value = (float)_gpi/(_modelRE.investment.price * 0.08);
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
        [_modelRE setPrice:_price];
        _modelRE.investment.gpi         = _gpi;
        _modelRE.estate.house.area      = _floorArea;
        _modelRE.estate.house.rooms     = _rooms;
        [_modelRE valToFile];
    }
    [super viewWillDisappear:animated];
}

//======================================================================
//
//======================================================================
-(void)slider:(UISlider*)slider
{
    // ここに何かの処理を記述する
    // （引数の slider には呼び出し元のUISliderオブジェクトが引き渡されてきます）
    if( _modelRE.investment.gpi != 0){
        _gpi = (NSInteger)((slider.value*_modelRE.investment.gpi) /(_rooms*12) /100)*(_rooms*12)*100;
    } else {
        _gpi = (NSInteger)((slider.value*(_modelRE.investment.price * 0.08)) /(_rooms*12) /100)*(_rooms*12)*100;
    }
    [self rewriteProperty];
}

//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    if (sender.tag==BTAG_RENT){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.google.co.jp/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=%E5%AE%B6%E8%B3%83%E7%9B%B8%E5%A0%B4"]];
    } else {
        [super clickButton:sender];
        [self.navigationController popViewControllerAnimated:YES];
    }
    return;
}

//======================================================================
//
//======================================================================
-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//======================================================================
//
//======================================================================
-(void)keyboardWasShown:(NSNotification*)aNotification
{
/*
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
*/
 }

//======================================================================
//
//======================================================================
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    [_scrollView setContentOffset:CGPointZero animated:YES];
    return;
}

//======================================================================
@end
//======================================================================
