//
//  SummaryViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/12/30.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "SummaryViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "ModelCF.h"
#import "Pos.h"
#import "GridTable.h"
#import "Graph.h"
#import "GraphData.h"
#import "AddonMgr.h"
#import "OpeTipsViewCtrl.h"

@interface SummaryViewCtrl ()
{
    ModelRE             *_modelRE;
    UIScrollView        *_scrollView;
    UIView              *_uv_grid;
    Pos                 *_pos;
    UILabel             *_l_name;

    UIButton            *_b_opeTips;
    //-----------
    UILabel             *_l_TitleEfficiency;
    UILabel             *_l_capRate;
    UILabel             *_l_capRateVal;
    UILabel             *_l_fcr;
    UILabel             *_l_fcrVal;
    UILabel             *_l_loanConst;
    UILabel             *_l_loanConstVal;
    UILabel             *_l_ccr;
    UILabel             *_l_ccrVal;
    UILabel             *_l_pb;
    UILabel             *_l_pbVal;
    UILabel             *_l_cfRate;
    UILabel             *_l_cfRateVal;
    //-----------
    UILabel             *_l_TitleSafety;
    UILabel             *_l_dcr;
    UILabel             *_l_dcrVal;
    UILabel             *_l_ber;
    UILabel             *_l_berVal;
    UILabel             *_l_ltv;
    UILabel             *_l_ltvVal;
    //-----------
    UILabel             *_l_TitleYield;
    UILabel             *_l_NfcYield;
    UILabel             *_l_NfcYieldVal;
    UILabel             *_l_ccr2;
    UILabel             *_l_ccr2Val;
    UILabel             *_l_AmoYield;
    UILabel             *_l_AmoYieldVal;
    UILabel             *_l_RentUnitPrice;
    UILabel             *_l_RentUnitPriceVal;
    

    
    UITextView          *_tv_comment1;
    UITextView          *_tv_comment2;
    UITextView          *_tv_comment3;
    
    Graph               *_g_cf;

    UIViewController        *_opetipsVC;

    AddonMgr            *_addonMgr;
}

@end

@implementation SummaryViewCtrl
//======================================================================
@synthesize masterVC    = _masterVC;
#define BTAG_TIPS           1

//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"運営";
        self.tabBarItem.image = [UIImage imageNamed:@"operation.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _masterVC   = nil;
    }
    return self;
}
//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    _modelRE        = [ModelRE sharedManager];
    _addonMgr       = [AddonMgr sharedManager];    
    /****************************************/
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        if ( _addonMgr.database == true ){
            UIBarButtonItem *retButton =
            [[UIBarButtonItem alloc] initWithTitle:@"物件リスト"
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(retButtonTapped:)];
            self.navigationItem.leftBarButtonItem = retButton;
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_name         = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_name];
    /****************************************/
    _uv_grid = [GridTable makeGridTable];
    [_scrollView addSubview:_uv_grid];
    /****************************************/
    _b_opeTips  = [UIUtil makeButton:@"計算の詳細" tag:BTAG_TIPS];
    [_b_opeTips addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_opeTips];
    /****************************************/
    _l_TitleEfficiency  = [UIUtil makeLabel:@"投資効率性"];
    [_scrollView addSubview:_l_TitleEfficiency];
    /****************************************/
    _l_capRate         = [UIUtil makeLabel:@"初年度キャップレート"];
    [_l_capRate setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_capRate];
    /*--------------------------------------*/
    _l_capRateVal     = [UIUtil makeLabel:@""];
    [_l_capRateVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_capRateVal];
    /****************************************/
    _l_cfRate         = [UIUtil makeLabel:@"初年度CF割合"];
    [_l_cfRate setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_cfRate];
    /*--------------------------------------*/
    _l_cfRateVal     = [UIUtil makeLabel:@""];
    [_l_cfRateVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_cfRateVal];
    /****************************************/
    _l_fcr        = [UIUtil makeLabel:@"総収益率(FCR)"];
    [_l_fcr setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_fcr];
    /*--------------------------------------*/
    _l_fcrVal     = [UIUtil makeLabel:@""];
    [_l_fcrVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_fcrVal];
    /****************************************/
    _l_loanConst      = [UIUtil makeLabel:@"ローン定数(k%)"];
    [_l_loanConst setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_loanConst];
    /*--------------------------------------*/
    _l_loanConstVal   = [UIUtil makeLabel:@""];
    [_l_loanConstVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_loanConstVal];
    /****************************************/
    _l_ccr = [UIUtil makeLabel:@"自己資本配当率(CCR)"];
    [_l_ccr setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_ccr];
    /*--------------------------------------*/
    _l_ccrVal     = [UIUtil makeLabel:@""];
    [_l_ccrVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_ccrVal];
    /****************************************/
    _tv_comment1    = [[UITextView alloc]init];
    _tv_comment1.editable       = false;
    _tv_comment1.scrollEnabled  = false;
    _tv_comment1.text           = [NSString stringWithFormat:@""];
    [_scrollView addSubview:_tv_comment1];
    /****************************************/
    _l_TitleSafety  = [UIUtil makeLabel:@"投資安全性"];
    [_scrollView addSubview:_l_TitleSafety];
    /****************************************/
    _l_pb           = [UIUtil makeLabel:@"自己資本回収年数(PB)"];
    [_l_pb setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_pb];
    /*--------------------------------------*/
    _l_pbVal        = [UIUtil makeLabel:@""];
    [_l_pbVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_pbVal];
    /****************************************/
    _l_dcr          = [UIUtil makeLabel:@"借入償還余裕率(DCR)"];
    [_l_dcr setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_dcr];
    /*--------------------------------------*/
    _l_dcrVal       = [UIUtil makeLabel:@""];
    [_l_dcrVal  setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_dcrVal];
    /****************************************/
    _l_ber        = [UIUtil makeLabel:@"損益分岐入居率(BER)"];
    [_l_ber setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_ber];
    /*--------------------------------------*/
    _l_berVal     = [UIUtil makeLabel:@""];
    [_l_berVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_berVal];
    /****************************************/
    _l_ltv          = [UIUtil makeLabel:@"借入金割合(LTV)"];
    [_l_ltv setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_ltv];
    /*--------------------------------------*/
    _l_ltvVal          = [UIUtil makeLabel:@""];
    [_l_ltvVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_ltvVal];
    //========================================
    _tv_comment2    = [[UITextView alloc]init];
    _tv_comment2.editable       = false;
    _tv_comment2.scrollEnabled  = false;
    _tv_comment2.text           = [NSString stringWithFormat:@""];
    [_scrollView addSubview:_tv_comment2];
    //========================================
    _l_TitleYield   = [UIUtil makeLabel:@"各種利回り"];
    [_scrollView addSubview:_l_TitleYield];
    //========================================
    _l_NfcYield         = [UIUtil makeLabel:@"NFC利回り"];
    [_l_NfcYield setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_NfcYield];
    //----------------------------------------
    _l_NfcYieldVal     = [UIUtil makeLabel:@""];
    [_l_NfcYieldVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_NfcYieldVal];
    //========================================
    _l_ccr2         = [UIUtil makeLabel:@"自己資本金利回り"];
    [_l_ccr2 setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_ccr2];
    //----------------------------------------
    _l_ccr2Val     = [UIUtil makeLabel:@""];
    [_l_ccr2Val setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_ccr2Val];
    //========================================
    _l_AmoYield         = [UIUtil makeLabel:@"償却後利回り"];
    [_l_AmoYield setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_AmoYield];
    //----------------------------------------
    _l_AmoYieldVal     = [UIUtil makeLabel:@""];
    [_l_AmoYieldVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_AmoYieldVal];
    //========================================
    _l_RentUnitPrice         = [UIUtil makeLabel:@"賃料単価"];
    [_l_RentUnitPrice setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_RentUnitPrice];
    //----------------------------------------
    _l_RentUnitPriceVal     = [UIUtil makeLabel:@""];
    [_l_RentUnitPriceVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_RentUnitPriceVal];
    //========================================
    _tv_comment3    = [[UITextView alloc]init];
    _tv_comment3.editable       = false;
    _tv_comment3.scrollEnabled  = false;
    _tv_comment3.text           = [NSString stringWithFormat:@""];
    [_scrollView addSubview:_tv_comment3];
    //========================================
    if ( _addonMgr.multiYear == true &&  _addonMgr.saleAnalysys == false){
        _g_cf   = [[Graph alloc]init];
        [_scrollView addSubview:_g_cf];
    }
    //========================================
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
    //========================================
    CGFloat pos_x,pos_y,dx,dy,length,lengthR,length30;
    _pos = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy*0.8;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    length30    = _pos.len30;
    //========================================
    [_scrollView setFrame:_pos.frame];
    //----------------------------------------
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        if ( _pos.isPortrait == true ){
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*3);
        } else {
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*4);
        }
        _scrollView.bounces = YES;
    } else {
        if ( _addonMgr.multiYear == true ){
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*1.5);
            _scrollView.bounces = YES;
        }
    }
    //========================================
    pos_y = 0.2*dy;
    //----------------------------------------
    [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
    pos_y = pos_y + dy;
    [GridTable setRectScroll:_uv_grid rect:CGRectMake(_pos.x_left, pos_y, length30, dy*10)];
    pos_y = pos_y + 10*dy;
    //----------------------------------------
    pos_y   = pos_y + dy;
    [UIUtil setButton:_b_opeTips x:pos_x y:pos_y length:length30];
    //----------------------------------------
    if ( _addonMgr.multiYear == true &&  _addonMgr.saleAnalysys == false){
        pos_y = pos_y + dy;
        [_g_cf      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
        [_g_cf setNeedsDisplay];
        pos_y = pos_y + dy*4;
    }
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleEfficiency x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_capRate         x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_capRateVal      x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_cfRate          x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_cfRateVal       x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_fcr             x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_fcrVal          x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_loanConst       x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_loanConstVal    x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_ccr             x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_ccrVal          x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_pb              x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_pbVal           x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    _tv_comment1.frame      = CGRectMake(pos_x,         pos_y, length30, dy*7);
    pos_y = pos_y + 6*dy;
    //========================================
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleSafety x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_dcr             x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_dcrVal          x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_ber             x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_berVal          x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_ltv             x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_ltvVal          x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    _tv_comment2.frame      = CGRectMake(pos_x,         pos_y, length30, dy*6);
    pos_y = pos_y + 5*dy;
    //========================================
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleYield x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_RentUnitPrice       x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_RentUnitPriceVal    x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_NfcYield        x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_NfcYieldVal     x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_ccr2            x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_ccr2Val         x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_AmoYield        x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_AmoYieldVal     x:pos_x+dx*2    y:pos_y length:length];
    //----------------------------------------
    pos_y = pos_y + dy;
    _tv_comment3.frame      = CGRectMake(pos_x,         pos_y, length30, dy*6);
    pos_y = pos_y + 5*dy;
    //========================================
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
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    //    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
}
//======================================================================
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{
    [_modelRE calcAll];
    /****************************************/
    _l_name.text            = _modelRE.estate.name;
    [GridTable setScroll:_uv_grid table:[_modelRE getOperationArray]];

    /****************************************/
    [ModelCF setGraphData:_g_cf ModelRE:_modelRE ];
    _g_cf.title         = @"キャッシュフロー推移";
    [_g_cf setNeedsDisplay];
    
    //========================================
    _l_fcrVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.fcr*100];
    _l_loanConstVal.text    = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.loanConst*100];
    _l_ccrVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.ccr*100];
    _l_pbVal.text           = [NSString stringWithFormat:@"%2.1f年",_modelRE.ope1.pb];
    //========================================
    _l_dcrVal.text          = [NSString stringWithFormat:@"%1.2f",_modelRE.ope1.dcr];
    _l_berVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.ber*100];
    _l_ltvVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.ltv*100];
    _l_capRateVal.text      = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.capRate*100];
    _l_cfRateVal.text       = [NSString stringWithFormat:@"%2.2f%%",(float)_modelRE.ope1.btcf/_modelRE.investment.price*100];
    //========================================
    _l_RentUnitPriceVal.text    = [NSString stringWithFormat:@"%ld円/坪",_modelRE.ope1.rentUnitPrice];
    _l_NfcYieldVal.text         = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.yieldNfc*100];
    _l_ccr2Val.text             = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.ccr*100];
    _l_AmoYieldVal.text         = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.yieldAmo*100];

    //========================================
    _tv_comment1.text       = [self getStrComment1];
    _tv_comment2.text       = [self getStrComment2];
    _tv_comment3.text       = [self getStrComment3];

    //========================================

}

//======================================================================
//
//======================================================================
#define CMT1_1 @"キャップレート　 = 営業利益 / 物件価格\nCF割合　            = 税引前CF / 物件価格\n総収益率　　　　 = 営業利益 / (自己資金 + 借入金)\nローン定数　　　 = 年間返済額 / 借入金\n自己資本配当率　 = 税引前CF / 自己資金\n自己資本回収年数 = 自己資金 / 税引前CF\n\n"
#define CMT1_2 @"・FCR:%2.2f%% > ローン定数%2.2f%%\n　　→投資として適格です\n"
#define CMT1_3 @"・CCR:%2.2f%% > FCR:%2.2f%% > ローン定数%2.2f%%\n　　→借入によるレバレッジが効いています\n"
#define CMT1_4 @"・投入した自己資金は%2.1f年で回収できます\n"
#define CMT1_5 @"・総収益率:%2.2f%% > 自己資本配当率:%2.2f%%\n　　→借入によるレバレッジが効いていません\n"
#define CMT1_6 @"・ローン定数%2.2f%% > 総収益率:%2.2f%%\n　　→損しています。投資として不適格です\n"

-(NSString*) getStrComment1
{
    NSString    *str;
    str = [NSString stringWithFormat:CMT1_1 ];
    if( _modelRE.ope1.fcr > _modelRE.ope1.loanConst ){
        str = [str stringByAppendingFormat:CMT1_2,_modelRE.ope1.fcr*100,_modelRE.ope1.loanConst*100];
        if( _modelRE.ope1.ccr > _modelRE.ope1.fcr ){
            str = [str stringByAppendingFormat:CMT1_3,_modelRE.ope1.ccr*100,_modelRE.ope1.fcr*100,_modelRE.ope1.loanConst*100];
            str = [str stringByAppendingFormat:CMT1_4 ,_modelRE.ope1.pb];
        } else {
            str = [str stringByAppendingFormat:CMT1_5,_modelRE.ope1.fcr*100,_modelRE.ope1.ccr*100];
        }
    } else {
        str = [str stringByAppendingFormat:CMT1_6 ,_modelRE.ope1.loanConst*100,_modelRE.ope1.fcr*100];
    }
    return str;
}
//======================================================================
//
//======================================================================
#define CMT2_1 @"借入償還余裕率 = 営業利益 / 年間返済額\n損益分岐入居率 = (運営費 + 年間返済額) / 潜在総収入\n借入金割合　　 = 借入金 / 物件価格\n\n"
#define CMT2_2 @"・DCR:%2.2f > 1.3\n　　→一般的な目安以上の余裕があります\n"
#define CMT2_3 @"・DCR:%2.2f < 1.3\n　　→余裕率は一般的な目安以下です\n"
#define CMT2_4 @"・DCR:%2.2f < 1.2\n　　→この水準では銀行は融資しないと一般では言われています\n"
#define CMT2_5 @"・BER:%2.2f%% < 70%%\n　　→空室リスクに対して十分な余裕があります\n"
#define CMT2_6 @"・BER:%2.2f%% > 70%%\n　　→空室リスクに耐えられない可能性があります\n"
#define CMT2_7 @"・LTV:%2.2f%% ≧ 80%%\n　　→借入の割合が高めです\n"
#define CMT2_8 @"・60%% ≦ LTV:%2.2f%% ≦ 80%%\n　　→借入の割合は適正です\n"
#define CMT2_9 @"・LTV:%2.2f%% < 60%%\n　　→借入の割合は低めです\n"

-(NSString*) getStrComment2
{
    NSString *str;
    str = [NSString stringWithFormat:CMT2_1];
    if( _modelRE.ope1.dcr >= 1.3 ){
        str = [str stringByAppendingFormat:CMT2_2,_modelRE.ope1.dcr];
    } else if ( _modelRE.ope1.dcr < 1.3 &&  _modelRE.ope1.dcr >= 1.2 ){
        str = [str stringByAppendingFormat:CMT2_3,_modelRE.ope1.dcr];
    } else {
        str = [str stringByAppendingFormat:CMT2_4,_modelRE.ope1.dcr];
    }
    if( _modelRE.ope1.ber < 0.7 ){
        str = [str stringByAppendingFormat:CMT2_5,_modelRE.ope1.ber*100];
    } else {
        str = [str stringByAppendingFormat:CMT2_6 ,_modelRE.ope1.ber*100];
    }
    if( _modelRE.ope1.ltv > 0.8 ){
        str = [str stringByAppendingFormat:CMT2_7,_modelRE.ope1.ltv*100];
    } else if( _modelRE.ope1.ltv <= 0.8 && _modelRE.ope1.ltv >= 0.6 ){
        str = [str stringByAppendingFormat:CMT2_8,_modelRE.ope1.ltv*100];
    } else {
        str = [str stringByAppendingFormat:CMT2_9,_modelRE.ope1.ltv*100];
    }
    return str;
}
//======================================================================
//
//======================================================================
#define CMT3_1 @"賃料単価=GPI/建物面積\n"
#define CMT3_2 @"NFC利回り=営業利益(NOI)/物件価格\n"
#define CMT3_3 @"自己資金利回り=自己資本配当率(CCR)=税引前CF/自己資金\n"
#define CMT3_4 @"償却後利回り=(営業利益(NOI)-減価償却費)/物件価格"

-(NSString*) getStrComment3
{
    NSString *str;
    str = [NSString stringWithFormat:CMT3_1];
    str = [str stringByAppendingFormat:CMT3_2];
    str = [str stringByAppendingFormat:CMT3_3];
    str = [str stringByAppendingFormat:CMT3_4];

    return str;
}

//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_TIPS){
        _opetipsVC   = [[OpeTipsViewCtrl alloc]init];
        [self presentViewController:_opetipsVC animated:YES completion:nil];
    }
    return;
}

//======================================================================
//
//======================================================================
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//======================================================================
@end
//======================================================================
