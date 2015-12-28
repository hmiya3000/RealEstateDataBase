//
//  SaleViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/15.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "SaleViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "ModelSale.h"
#import "Pos.h"
#import "GridTable.h"
#import "Graph.h"
#import "AddonMgr.h"

@interface SaleViewCtrl ()
{
    ModelRE             *_modelRE;
    UIScrollView        *_scrollView;
    UIView              *_uv_grid;
    Pos                 *_pos;
    AddonMgr            *_addonMgr;
    /*--------------------------------------*/
    UILabel             *_l_name;
    /*--------------------------------------*/
    UILabel             *_l_TitleSetting;
    UILabel             *_l_capRate;
    UILabel             *_l_capRateVal;
    UILabel             *_l_priceSale;
    UILabel             *_l_priceSaleVal;
    UILabel             *_l_buildYearSale;
    UILabel             *_l_buildYearSaleVal;
    UILabel             *_l_capRateSale;
    UILabel             *_l_capRateSaleVal;
    UILabel             *_l_interestSale;
    UILabel             *_l_interestSaleVal;
    /*--------------------------------------*/
    UILabel             *_l_TitleSale;
    UILabel             *_l_priceSale2;
    UILabel             *_l_priceSale2Val;
    UILabel             *_l_transferExp;
    UILabel             *_l_transferExpVal;
    UILabel             *_l_lb;
    UILabel             *_l_lbVal;
    UILabel             *_l_btcf;
    UILabel             *_l_btcfVal;
    UILabel             *_l_bookValue;
    UILabel             *_l_bookValueVal;
    UILabel             *_l_amCosts;
    UILabel             *_l_amCostsVal;
    UILabel             *_l_transferIncome;
    UILabel             *_l_transferIncomeVal;
    UILabel             *_l_transferTax;
    UILabel             *_l_transferTaxVal;
    UILabel             *_l_atcf;
    UILabel             *_l_atcfVal;
    UILabel             *_l_equity;
    UILabel             *_l_equityVal;
    UILabel             *_l_capGain;
    UILabel             *_l_capGainVal;

    Graph               *_g_price;
    Graph               *_g_cf;

}


@end

@implementation SaleViewCtrl
/****************************************************************/
@synthesize masterVC    = _masterVC;

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"売却検討";
        self.tabBarItem.image = [UIImage imageNamed:@"sale.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _masterVC   = nil;
    }
    return self;
}
/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
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
    _l_TitleSetting     = [UIUtil makeLabel:@"売却設定"];
    [_scrollView addSubview:_l_TitleSetting];
    /****************************************/
    _l_capRate          = [UIUtil makeLabel:@"N年目キャップレート"];
    [_l_capRate setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_capRate];
    /*--------------------------------------*/
    _l_capRateVal       = [UIUtil makeLabel:@""];
    [_l_capRateVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_capRateVal];
    /****************************************/
    _l_priceSale        = [UIUtil makeLabel:@"売却価格"];
    [_l_priceSale setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_priceSale];
    /*--------------------------------------*/
    _l_priceSaleVal     = [UIUtil makeLabel:@""];
    [_l_priceSaleVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceSaleVal];
    /****************************************/
    _l_buildYearSale      = [UIUtil makeLabel:@"売却時築年数"];
    [_l_buildYearSale setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_buildYearSale];
    /*--------------------------------------*/
    _l_buildYearSaleVal     = [UIUtil makeLabel:@"築x年"];
    [_l_buildYearSaleVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_buildYearSaleVal];
    /****************************************/
    _l_capRateSale      = [UIUtil makeLabel:@"売却時キャップレート"];
    [_l_capRateSale setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_capRateSale];
    /*--------------------------------------*/
    _l_capRateSaleVal       = [UIUtil makeLabel:@""];
    [_l_capRateSaleVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_capRateSaleVal];
    /****************************************/
    _l_interestSale         = [UIUtil makeLabel:@"売却時表面利回り"];
    [_l_interestSale setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_interestSale];
    /*--------------------------------------*/
    _l_interestSaleVal      = [UIUtil makeLabel:@""];
    [_l_interestSaleVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_interestSaleVal];
    /****************************************/
    _g_price            = [[Graph alloc]init];
    [_scrollView addSubview:_g_price];
    /****************************************/
    _g_cf               = [[Graph alloc]init];
    [_scrollView addSubview:_g_cf];
    /****************************************/
    _l_TitleSale        = [UIUtil makeLabel:@"売却取引"];
    [_scrollView addSubview:_l_TitleSale];
    /****************************************/
    _l_priceSale2        = [UIUtil makeLabel:@"売却価格"];
    [_l_priceSale2 setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_priceSale2];
    /*--------------------------------------*/
    _l_priceSale2Val     = [UIUtil makeLabel:@""];
    [_l_priceSale2Val setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceSale2Val];
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
    _l_bookValue           = [UIUtil makeLabel:@"簿価"];
    [_l_bookValue setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_bookValue];
    /*--------------------------------------*/
    _l_bookValueVal        = [UIUtil makeLabel:@""];
    [_l_bookValueVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_bookValueVal];
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
    _l_equity           = [UIUtil makeLabel:@"自己資金"];
    [_l_equity setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_equity];
    /*--------------------------------------*/
    _l_equityVal        = [UIUtil makeLabel:@""];
    [_l_equityVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_equityVal];
    /****************************************/
    _l_capGain              = [UIUtil makeLabel:@"キャピタルゲイン"];
    [_l_capGain setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_capGain];
    /*--------------------------------------*/
    _l_capGainVal          = [UIUtil makeLabel:@""];
    [_l_capGainVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_capGainVal];
    /****************************************/
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
    pos_y = 0.2*dy;
    /*--------------------------------------*/
    [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleSetting x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_capRate             x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_capRateVal          x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_priceSale           x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_priceSaleVal        x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_buildYearSale       x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_buildYearSaleVal    x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_interestSale        x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_interestSaleVal     x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_capRateSale         x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_capRateSaleVal      x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [_g_price       setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    [_g_price setNeedsDisplay];
    /*--------------------------------------*/
    pos_y = pos_y + 5*dy;
    [_g_cf       setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    [_g_cf setNeedsDisplay];
    pos_y = pos_y + 4*dy;
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleSale x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_priceSale2          x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_priceSale2Val       x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_transferExp         x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_transferExpVal      x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_lb                  x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_lbVal               x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_btcf                x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_btcfVal             x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_amCosts             x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_amCostsVal          x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_bookValue           x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_bookValueVal        x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_transferIncome      x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_transferIncomeVal   x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_transferTax         x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_transferTaxVal      x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_atcf                x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_atcfVal             x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_equity              x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_equityVal           x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_capGain             x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_capGainVal          x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/

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
    _l_name.text                = _modelRE.estate.name;
    _l_capRate.text             = [NSString stringWithFormat:@"%ld年目キャップレート",(long)_modelRE.holdingPeriod];
    _l_capRateVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.opeLast.capRate*100];
    [UIUtil labelYen:_l_priceSaleVal        yen:_modelRE.sale.price];
    _l_buildYearSaleVal.text    = [NSString stringWithFormat:@"築%ld年",(long)(_modelRE.sale.sellYear - _modelRE.estate.house.buildYear)];
    _l_interestSaleVal.text     = [NSString stringWithFormat:@"%2.2f%%",((CGFloat)_modelRE.opeLast.gpi*100/_modelRE.sale.price)];
    _l_capRateSaleVal.text      = [NSString stringWithFormat:@"%2.2f%%",((CGFloat)_modelRE.opeLast.noi*100/_modelRE.sale.price)];
    /*--------------------------------------*/
    [ModelSale setGraphDataPrice:_g_price ModelRE:_modelRE ];
    _g_price.title         = @"キャップレートごとの売却価格推移";
    [_g_price setNeedsDisplay];
    /*--------------------------------------*/
    [ModelSale setGraphDataCapGain:_g_cf ModelRE:_modelRE ];
    _g_cf.title         = @"キャップレートごとのキャピタルゲイン推移";
    [_g_cf setNeedsDisplay];
    /****************************************/
    [UIUtil labelYen:_l_priceSale2Val       yen:_modelRE.sale.price];
    [UIUtil labelYen:_l_transferExpVal      yen:-_modelRE.sale.expense];
    [UIUtil labelYen:_l_lbVal               yen:-_modelRE.sale.loanBorrow];
    [UIUtil labelYen:_l_btcfVal             yen: _modelRE.sale.btcf];
    [UIUtil labelYen:_l_amCostsVal          yen:-_modelRE.sale.amCosts];
    [UIUtil labelYen:_l_bookValueVal        yen:_modelRE.investment.prices.price + _modelRE.investment.expense -_modelRE.sale.amCosts];
    [UIUtil labelYen:_l_transferIncomeVal   yen: _modelRE.sale.transferIncome];
    [UIUtil labelYen:_l_transferTaxVal      yen:-_modelRE.sale.transferTax];
    [UIUtil labelYen:_l_atcfVal             yen: _modelRE.sale.atcf];
    [UIUtil labelYen:_l_equityVal           yen:-_modelRE.investment.equity];
    [UIUtil labelYen:_l_capGainVal          yen:(_modelRE.sale.atcf-_modelRE.investment.equity)];
    

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
