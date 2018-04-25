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
#import "ModelCF.h"
#import "Pos.h"
#import "GridTable.h"
#import "Graph.h"
#import "GraphData.h"
#import "AddonMgr.h"

@interface TotalAnalysisViewCtrl ()
{
    ModelRE             *_modelRE;
    UIScrollView        *_scrollView;
    Pos                 *_pos;
    AddonMgr            *_addonMgr;
    /*--------------------------------------*/
    UILabel             *_l_name;
    /*--------------------------------------*/
    UILabel             *_l_TitlePrice;
    UILabel             *_l_priceBuy;
    UILabel             *_l_priceBuyVal;
    UILabel             *_l_equity;
    UILabel             *_l_equityVal;
    UILabel             *_l_holdingPeriod;
    UILabel             *_l_holdingPeriodVal;
    UILabel             *_l_priceSale;
    UILabel             *_l_priceSaleVal;
    /*--------------------------------------*/
    UILabel             *_l_TitleCF;
    UILabel             *_l_btcfOpe;
    UILabel             *_l_btcfOpeVal;
    UILabel             *_l_btcfSale;
    UILabel             *_l_btcfSaleVal;
    UILabel             *_l_btcfAll;
    UILabel             *_l_btcfAllVal;
    UILabel             *_l_btInOut;
    UILabel             *_l_btInOutVal;
    UILabel             *_l_atcfOpe;
    UILabel             *_l_atcfOpeVal;
    UILabel             *_l_atcfSale;
    UILabel             *_l_atcfSaleVal;
    UILabel             *_l_atcfAll;
    UILabel             *_l_atcfAllVal;
    UILabel             *_l_atInOut;
    UILabel             *_l_atInOutVal;
    /*--------------------------------------*/
    UILabel             *_l_TitleAnalyze;
    UILabel             *_l_npv;
    UILabel             *_l_npvVal;
    UILabel             *_l_btIrr;
    UILabel             *_l_btIrrVal;
    UILabel             *_l_atIrr;
    UILabel             *_l_atIrrVal;
    Graph               *_g_cf;
    Graph               *_g_npv;
    UITextView          *_tv_comment;
}

@end

@implementation TotalAnalysisViewCtrl
//======================================================================
@synthesize masterVC    = _masterVC;


#define CMT_NPV_TIPS @"■正味現在価値(NPV)と内部収益率(IRR)\n\n例えば100万円を3%で1年預けると1年後には103万円になります.つまり1年後の103万円は現在の100万円と同じ価値と言えます.\n\n投資において数年に渡って得られるCFを現在価値に換算し、初期投資額を差し引いたものを\"正味現在価値(NPV)\"と呼びます.また前述の利率は将来価値を現在価値への\"割引率\"、または\"期待収益率\"と呼びます.\n\n想定した期待収益率でNPV>0となれば投資価値があると考えます.また、NPV=0となる期待収益率を\"内部収益率(IRR)\"と呼び、これが大きいほど投資効率が高いと考えます"
//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"総合分析";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
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
    _l_TitlePrice       = [UIUtil makeLabel:@"価格"];
    [_scrollView addSubview:_l_TitlePrice];
    /****************************************/
    _l_priceBuy        = [UIUtil makeLabel:@"物件価格"];
    [_l_priceBuy setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_priceBuy];
    /*--------------------------------------*/
    _l_priceBuyVal     = [UIUtil makeLabel:@""];
    [_l_priceBuyVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceBuyVal];
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
    _l_priceSale        = [UIUtil makeLabel:@"売却価格"];
    [_l_priceSale setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_priceSale];
    /*--------------------------------------*/
    _l_priceSaleVal     = [UIUtil makeLabel:@""];
    [_l_priceSaleVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceSaleVal];
    /****************************************/
    _l_TitleCF         = [UIUtil makeLabel:@"キャッシュフロー"];
    [_scrollView addSubview:_l_TitleCF];
    /*--------------------------------------*/
    _g_cf   = [[Graph alloc]init];
    [_scrollView addSubview:_g_cf];
    /*--------------------------------------*/
    _l_btcfOpe         = [UIUtil makeLabel:@"税引前累積運営CF"];
    [_l_btcfOpe setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_btcfOpe];
    /*--------------------------------------*/
    _l_btcfOpeVal     = [UIUtil makeLabel:@""];
    [_l_btcfOpeVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_btcfOpeVal];
    /****************************************/
    _l_btcfSale         = [UIUtil makeLabel:@"税引前売却CF"];
    [_l_btcfSale setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_btcfSale];
    /*--------------------------------------*/
    _l_btcfSaleVal     = [UIUtil makeLabel:@""];
    [_l_btcfSaleVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_btcfSaleVal];
    /****************************************/
    _l_btcfAll          = [UIUtil makeLabel:@"税引前全CF"];
    [_l_btcfAll setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_btcfAll];
    /*--------------------------------------*/
    _l_btcfAllVal       = [UIUtil makeLabel:@""];
    [_l_btcfAllVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_btcfAllVal];
    /****************************************/
    _l_btInOut          = [UIUtil makeLabel:@"税引前収支"];
    [_l_btInOut setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_btInOut];
    /*--------------------------------------*/
    _l_btInOutVal       = [UIUtil makeLabel:@""];
    [_l_btInOutVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_btInOutVal];
    /****************************************/
    _l_atcfOpe         = [UIUtil makeLabel:@"税引後累積運営CF"];
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
    _l_atcfAllVal       = [UIUtil makeLabel:@""];
    [_l_atcfAllVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_atcfAllVal];
    /****************************************/
    _l_atInOut          = [UIUtil makeLabel:@"税引後収支"];
    [_l_atInOut setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_atInOut];
    /*--------------------------------------*/
    _l_atInOutVal       = [UIUtil makeLabel:@""];
    [_l_atInOutVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_atInOutVal];
    /****************************************/
    _l_TitleAnalyze     = [UIUtil makeLabel:@"収益分析"];
    [_scrollView addSubview:_l_TitleAnalyze];
    /****************************************/
    _l_npv      = [UIUtil makeLabel:@"正味現在価値(NPV)"];
    [_l_npv setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_npv];
    /*--------------------------------------*/
    _l_npvVal   = [UIUtil makeLabel:@"20,000,000"];
    [_l_npvVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_npvVal];
    /****************************************/
    _l_btIrr    = [UIUtil makeLabel:@"税引前内部収益率(IRR)"];
    [_l_btIrr setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_btIrr];
    /*--------------------------------------*/
    _l_btIrrVal = [UIUtil makeLabel:@"5.5%"];
    [_l_btIrrVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_btIrrVal];
    /****************************************/
    _l_atIrr    = [UIUtil makeLabel:@"税引後内部収益率(IRR)"];
    [_l_atIrr setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_atIrr];
    /*--------------------------------------*/
    _l_atIrrVal = [UIUtil makeLabel:@"5.5%"];
    [_l_atIrrVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_atIrrVal];
    /****************************************/
    _g_npv     = [[Graph alloc]init];
    [_scrollView addSubview:_g_npv];
    /****************************************/
    _tv_comment                 = [[UITextView alloc]init];
    _tv_comment.editable        = false;
    _tv_comment.scrollEnabled   = true;
    _tv_comment.text            = [NSString stringWithFormat:@""];
    [_scrollView addSubview:_tv_comment];
    /****************************************/
    
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
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2.9);
        }
        _scrollView.bounces = YES;
    } else {
    }
    /****************************************/
    pos_y = 0.2*dy;
    [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitlePrice x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_priceBuy            x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_priceBuyVal         x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_equity              x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_equityVal           x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_holdingPeriod       x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_holdingPeriodVal    x:pos_x+dx*2    y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_priceSale           x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_priceSaleVal        x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleCF x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    //----------------------------------------
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_btcfOpe             x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_btcfOpeVal          x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_btcfSale             x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_btcfSaleVal          x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_btcfAll              x:pos_x        y:pos_y length:lengthR];
    [UIUtil setLabel:_l_btcfAllVal           x:pos_x+dx*1.5 y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_btInOut              x:pos_x        y:pos_y length:lengthR];
    [UIUtil setLabel:_l_btInOutVal           x:pos_x+dx*1.5 y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [_g_cf      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    [_g_cf setNeedsDisplay];
    pos_y = pos_y + dy*4;
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_atcfOpe             x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_atcfOpeVal          x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_atcfSale             x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_atcfSaleVal          x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_atcfAll              x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_atcfAllVal           x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_atInOut              x:pos_x        y:pos_y length:lengthR];
    [UIUtil setLabel:_l_atInOutVal           x:pos_x+dx*1.5 y:pos_y length:lengthR];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleAnalyze x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_npv                 x:pos_x         y:pos_y length:lengthR];
    [UIUtil setLabel:_l_npvVal              x:pos_x+dx*1.5  y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_btIrr               x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_btIrrVal            x:pos_x+dx*2    y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_atIrr               x:pos_x         y:pos_y length:length*2];
    [UIUtil setLabel:_l_atIrrVal            x:pos_x+dx*2    y:pos_y length:length];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [_g_npv    setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    [_g_npv setNeedsDisplay];
    /*--------------------------------------*/
    pos_y = pos_y + dy*5;
    _tv_comment.frame       = CGRectMake(pos_x,     pos_y, length30, dy*8);
    /*--------------------------------------*/
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
    _l_name.text            = _modelRE.estate.name;
    /****************************************/
    [UIUtil labelYen:_l_priceBuyVal     yen:_modelRE.investment.price];
    [UIUtil labelYen:_l_equityVal       yen:_modelRE.investment.equity];
    _l_holdingPeriodVal.text    = [NSString stringWithFormat:@"%ld年%ldヶ月",(long)_modelRE.holdingPeriodTerm/12,(long)_modelRE.holdingPeriodTerm%12];
    [UIUtil labelYen:_l_priceSaleVal    yen:_modelRE.sale.price];
    /****************************************/
    [ModelCF setGraphData:_g_cf ModelRE:_modelRE ];
    _g_cf.title         = @"キャッシュフロー推移";
    [_g_cf setNeedsDisplay];
    /*--------------------------------------*/
    [UIUtil labelYen:_l_btcfSaleVal yen:_modelRE.sale.btcf];
    [UIUtil labelYen:_l_btcfOpeVal  yen:_modelRE.btcfOpeAll];
    [UIUtil labelYen:_l_btcfAllVal  yen:_modelRE.btcfTotal];
    [UIUtil labelYen:_l_btInOutVal  yen:(_modelRE.btcfTotal-_modelRE.investment.equity)];
    /*--------------------------------------*/
    [UIUtil labelYen:_l_atcfSaleVal yen:_modelRE.sale.atcf];
    [UIUtil labelYen:_l_atcfOpeVal  yen:_modelRE.atcfOpeAll];
    [UIUtil labelYen:_l_atcfAllVal  yen:_modelRE.atcfTotal];
    [UIUtil labelYen:_l_atInOutVal  yen:(_modelRE.atcfTotal-_modelRE.investment.equity)];
    /****************************************/
    [UIUtil labelYen:_l_npvVal yen:_modelRE.npv];
    _l_btIrrVal.text      = [NSString stringWithFormat:@"%2.2f%%",_modelRE.btIrr*100];
    _l_atIrrVal.text      = [NSString stringWithFormat:@"%2.2f%%",_modelRE.atIrr*100];
    /*--------------------------------------*/
    GraphData *gd_npv   = [[GraphData alloc]initWithData:[_modelRE getNpvArray]];
    gd_npv.precedent    = @"NPV(税引前)";
    gd_npv.type         = LINE_GRAPH;
    
    NSArray *rate       = [[NSArray alloc]initWithObjects:[NSValue valueWithCGPoint:CGPointMake(_modelRE.discountRate*100, 0)], nil];
    GraphData *gd_rate  = [[GraphData alloc]initWithData:rate];
    gd_rate.precedent   = @"期待収益率";
    gd_rate.type        = POINT_GRAPH;
    
    NSArray *btIrr      = [[NSArray alloc]initWithObjects:[NSValue valueWithCGPoint:CGPointMake(_modelRE.btIrr*100, 0)], nil];
    GraphData *gd_btIrr   = [[GraphData alloc]initWithData:btIrr];
    gd_btIrr.precedent    = @"IRR(税引前)";
    gd_btIrr.type         = POINT_GRAPH;
    
    NSArray *atIrr      = [[NSArray alloc]initWithObjects:[NSValue valueWithCGPoint:CGPointMake(_modelRE.atIrr*100, 0)], nil];
    GraphData *gd_atIrr   = [[GraphData alloc]initWithData:atIrr];
    gd_atIrr.precedent    = @"IRR(税引後)";
    gd_atIrr.type         = POINT_GRAPH;
    
    _g_npv.GraphDataAll = [[NSArray alloc]initWithObjects:gd_npv,gd_rate,gd_btIrr,gd_atIrr,nil];
    [_g_npv setGraphtMinMax_xmin:gd_npv.xmin
                            ymin:gd_npv.ymin
                            xmax:gd_npv.xmax
                            ymax:gd_npv.ymax];
    _g_npv.title        = @"割引率[%]に対するNPV(正味現在価値)";
    [_g_npv setNeedsDisplay];
    /*--------------------------------------*/
    _tv_comment.text    = [self getStrComment1];
    /*--------------------------------------*/
    /****************************************/
    
}

//======================================================================
//
//======================================================================
-(NSString*) getStrComment1
{
    NSString *str;
    if ( _modelRE.npv > 0 ){
        str = [NSString stringWithFormat:@"NPV:%@円 ≧ 0円\n　→期待収益率(%2.2f%%)以上の収益が見込めます",[UIUtil yenValue:_modelRE.npv],_modelRE.discountRate*100];
    } else {
        str = [NSString stringWithFormat:@"NPV:%@円 < 0円\n　→期待収益率(%2.2f%%)ほどの収益は見込めません",[UIUtil yenValue:_modelRE.npv],_modelRE.discountRate*100];
    }
    str = [str stringByAppendingString:@"\n\n"];
    str = [str stringByAppendingString:CMT_NPV_TIPS];
    return str;
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
