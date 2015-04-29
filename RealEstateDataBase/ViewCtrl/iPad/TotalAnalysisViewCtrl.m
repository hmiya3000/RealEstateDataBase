//
//  TotalAnalysisViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/03/28.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "TotalAnalysisViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "Pos.h"
#import "GridTable.h"

@interface TotalAnalysisViewCtrl ()
{
    ModelRE             *_modelRE;
    UIScrollView        *_scrollView;
    Pos                 *_pos;
    UILabel             *_l_name;

    UILabel             *_l_TitleSale;

    UILabel             *_l_price;
    UILabel             *_l_priceVal;
    UILabel             *_l_transferExp;
    UILabel             *_l_transferExpVal;
    UILabel             *_l_lb;
    UILabel             *_l_lbVal;
    UILabel             *_l_btcf;
    UILabel             *_l_btcfVal;
    UILabel             *_l_amCosts;
    UILabel             *_l_amCostsVal;
    UILabel             *_l_transferIncome;
    UILabel             *_l_transferIncomeVal;
    UILabel             *_l_transferTax;
    UILabel             *_l_transferTaxVal;
    UILabel             *_l_atcf;
    UILabel             *_l_atcfVal;
    
    UILabel             *_l_TitleCF;
    UILabel             *_l_equity;
    UILabel             *_l_equityVal;
    UILabel             *_l_holdingPeriod;
    UILabel             *_l_holdingPeriodVal;
    UILabel             *_l_atcfOpe;
    UILabel             *_l_atcfOpeVal;
    UILabel             *_l_atcfSale;
    UILabel             *_l_atcfSaleVal;
    UILabel             *_l_atcfAll;
    UILabel             *_l_atcfAllVal;

}

@end

@implementation TotalAnalysisViewCtrl
/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"総合分析";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _modelRE = [ModelRE sharedManager];
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
    _l_name         = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_name];
    /****************************************/
    _l_TitleSale        = [UIUtil makeLabel:@"売却取引"];
    [_scrollView addSubview:_l_TitleSale];
    /****************************************/
    _l_price        = [UIUtil makeLabel:@"売却価格"];
    [_l_price setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_price];
    /*--------------------------------------*/
    _l_priceVal     = [UIUtil makeLabel:@""];
    [_l_priceVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceVal];
    /****************************************/
    _l_transferExp      = [UIUtil makeLabel:@"譲渡費用"];
    [_l_transferExp setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_transferExp];
    /*--------------------------------------*/
    _l_transferExpVal   = [UIUtil makeLabel:@""];
    [_l_transferExpVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_transferExpVal];
    /****************************************/
    _l_lb      = [UIUtil makeLabel:@"残債"];
    [_l_lb setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_lb];
    /*--------------------------------------*/
    _l_lbVal   = [UIUtil makeLabel:@""];
    [_l_lbVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_lbVal];
    /****************************************/
    _l_btcf = [UIUtil makeLabel:@"税引前CF"];
    [_l_btcf setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_btcf];
    /*--------------------------------------*/
    _l_btcfVal     = [UIUtil makeLabel:@""];
    [_l_btcfVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_btcfVal];
    /****************************************/
    _l_amCosts           = [UIUtil makeLabel:@"減価償却費"];
    [_l_amCosts setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_amCosts];
    /*--------------------------------------*/
    _l_amCostsVal        = [UIUtil makeLabel:@""];
    [_l_amCostsVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_amCostsVal];
    /****************************************/
    _l_transferIncome          = [UIUtil makeLabel:@"譲渡所得"];
    [_l_transferIncome setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_transferIncome];
    /*--------------------------------------*/
    _l_transferIncomeVal       = [UIUtil makeLabel:@""];
    [_l_transferIncomeVal  setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_transferIncomeVal];
    /****************************************/
    _l_transferTax        = [UIUtil makeLabel:@"譲渡税"];
    [_l_transferTax setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_transferTax];
    /*--------------------------------------*/
    _l_transferTaxVal     = [UIUtil makeLabel:@""];
    [_l_transferTaxVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_transferTaxVal];
    /****************************************/
    _l_atcf          = [UIUtil makeLabel:@"税引後CF"];
    [_l_atcf setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_atcf];
    /*--------------------------------------*/
    _l_atcfVal          = [UIUtil makeLabel:@""];
    [_l_atcfVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_atcfVal];
    /****************************************/
    _l_TitleCF         = [UIUtil makeLabel:@"キャッシュフロー"];
    [_scrollView addSubview:_l_TitleCF];
    /****************************************/
    _l_equity         = [UIUtil makeLabel:@"自己資金"];
    [_l_equity setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_equity];
    /*--------------------------------------*/
    _l_equityVal     = [UIUtil makeLabel:@""];
    [_l_equityVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_equityVal];
    /****************************************/
    _l_holdingPeriod    = [UIUtil makeLabel:@"保有期間"];
    [_l_holdingPeriod setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_holdingPeriod];
    /*--------------------------------------*/
    _l_holdingPeriodVal     = [UIUtil makeLabel:@""];
    [_l_holdingPeriodVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_holdingPeriodVal];
    /****************************************/
    _l_atcfOpe         = [UIUtil makeLabel:@"累積税引後運営CF"];
    [_l_atcfOpe setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_atcfOpe];
    /*--------------------------------------*/
    _l_atcfOpeVal     = [UIUtil makeLabel:@""];
    [_l_atcfOpeVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_atcfOpeVal];
    /****************************************/
    _l_atcfSale         = [UIUtil makeLabel:@"税引後売却CF"];
    [_l_atcfSale setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_atcfSale];
    /*--------------------------------------*/
    _l_atcfSaleVal     = [UIUtil makeLabel:@""];
    [_l_atcfSaleVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_atcfSaleVal];
    /****************************************/
    _l_atcfAll          = [UIUtil makeLabel:@"税引後全CF"];
    [_l_atcfAll setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_atcfAll];
    /*--------------------------------------*/
    _l_atcfAllVal     = [UIUtil makeLabel:@""];
    [_l_atcfAllVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_atcfAllVal];
    /****************************************/
    
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
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy*0.8;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    length30    = _pos.len30;
    /****************************************/
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0.2*dy;
    if ( _pos.isPortrait == true ){
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setRectLabel:_l_TitleSale x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price           x:pos_x             y:pos_y length:lengthR];
        [UIUtil setLabel:_l_priceVal        x:pos_x+dx*1.5      y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferExp     x:pos_x             y:pos_y length:lengthR];
        [UIUtil setLabel:_l_transferExpVal  x:pos_x+dx*1.5      y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_lb              x:pos_x             y:pos_y length:lengthR];
        [UIUtil setLabel:_l_lbVal           x:pos_x+dx*1.5      y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_btcf            x:pos_x             y:pos_y length:lengthR];
        [UIUtil setLabel:_l_btcfVal         x:pos_x+dx*1.5      y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_amCosts         x:pos_x             y:pos_y length:lengthR];
        [UIUtil setLabel:_l_amCostsVal      x:pos_x+dx*1.5      y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferIncome  x:pos_x             y:pos_y length:lengthR];
        [UIUtil setLabel:_l_transferIncomeVal x:pos_x+dx*1.5    y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferTax     x:pos_x             y:pos_y length:lengthR];
        [UIUtil setLabel:_l_transferTaxVal  x:pos_x+dx*1.5      y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_atcf           x:pos_x              y:pos_y length:lengthR];
        [UIUtil setLabel:_l_atcfVal        x:pos_x+dx*1.5       y:pos_y length:lengthR];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setRectLabel:_l_TitleCF x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_equity         x:pos_x         y:pos_y length:length*2];
        [UIUtil setLabel:_l_equityVal      x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_holdingPeriod             x:pos_x         y:pos_y length:length*2];
        [UIUtil setLabel:_l_holdingPeriodVal          x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_atcfOpe       x:pos_x         y:pos_y length:length*2];
        [UIUtil setLabel:_l_atcfOpeVal    x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_atcfSale             x:pos_x         y:pos_y length:length*2];
        [UIUtil setLabel:_l_atcfSaleVal          x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_atcfAll              x:pos_x         y:pos_y length:length*2];
        [UIUtil setLabel:_l_atcfAllVal           x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
    }else {
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
        pos_y = pos_y + dy;
    }
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
- (NSUInteger)supportedInterfaceOrientations
{
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
            break;
        default:
            break;
    }
    [self viewMake];
}
/****************************************************************
 * ビューがタップされたとき
 ****************************************************************/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    //    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
}
/****************************************************************
 *
 ****************************************************************/
-(void)rewriteProperty
{
    [_modelRE calcAll];
    _l_name.text            = _modelRE.estate.name;
    [UIUtil labelYen:_l_priceVal            yen:_modelRE.priceSales];
    [UIUtil labelYen:_l_transferExpVal      yen:-_modelRE.transferExpense];
    [UIUtil labelYen:_l_lbVal               yen:-_modelRE.lbSales];
    [UIUtil labelYen:_l_btcfVal             yen:_modelRE.btcfSales];
    [UIUtil labelYen:_l_amCostsVal          yen:-_modelRE.amCosts];
    [UIUtil labelYen:_l_transferIncomeVal   yen:_modelRE.transferIncome];
    [UIUtil labelYen:_l_transferTaxVal      yen:-_modelRE.transferTax];
    [UIUtil labelYen:_l_atcfVal             yen:_modelRE.atcfSales];

    
    [UIUtil labelYen:_l_equityVal yen:_modelRE.investment.equity];
    _l_holdingPeriodVal.text    = [NSString stringWithFormat:@"%ld年",(long)_modelRE.holdingPeriod];
    [UIUtil labelYen:_l_atcfSaleVal yen:_modelRE.atcfSales];
    [UIUtil labelYen:_l_atcfOpeVal  yen:_modelRE.atcfOpeAll];
    [UIUtil labelYen:_l_atcfAllVal  yen:_modelRE.atcfTotal];
    
}
/****************************************************************
 *
 ****************************************************************/
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/****************************************************************/
@end
/****************************************************************/
