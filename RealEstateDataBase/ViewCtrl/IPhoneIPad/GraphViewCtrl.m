//
//  GraphViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/01/01.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "GraphViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "ModelCF.h"
#import "Pos.h"
#import "Graph.h"
#import "GraphData.h"
#import "AddonMgr.h"

@interface GraphViewCtrl ()
{
    ModelRE             *_modelRE;
    UIScrollView        *_scrollView;
    UIView              *_uv_grid;
    Pos                 *_pos;
    UILabel             *_l_name;

    UILabel             *_l_TitleValuation;
    UILabel             *_l_valuLand;
    UILabel             *_l_valuLandVal;
    UILabel             *_l_valuHouse;
    UILabel             *_l_valuHouseVal;
    UILabel             *_l_valuAll;
    UILabel             *_l_valuAllVal;
    UITextView          *_tv_valuation;
    
    
    UILabel             *_l_TitleTransition;
    Graph               *_g_pmt;
    Graph               *_g_cf;
    Graph               *_g_drp;

    AddonMgr            *_addonMgr;
}
@end

@implementation GraphViewCtrl
/****************************************************************/
@synthesize masterVC    = _masterVC;

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"グラフ";
        self.tabBarItem.image = [UIImage imageNamed:@"graph.png"];
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
    _l_TitleValuation  = [UIUtil makeLabel:@"積算評価"];
    [_scrollView addSubview:_l_TitleValuation];
    /****************************************/
    _l_valuLand          = [UIUtil makeLabel:@"土地"];
    [_l_valuLand setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_valuLand];
    /*--------------------------------------*/
    _l_valuLandVal       = [UIUtil makeLabel:@""];
    [_l_valuLandVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_valuLandVal];
    /****************************************/
    _l_valuHouse         = [UIUtil makeLabel:@"建物"];
    [_l_valuHouse setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_valuHouse];
    /*--------------------------------------*/
    _l_valuHouseVal       = [UIUtil makeLabel:@""];
    [_l_valuHouseVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_valuHouseVal];
    /****************************************/
    _l_valuAll              = [UIUtil makeLabel:@"合計"];
    [_l_valuAll setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_valuAll];
    /*--------------------------------------*/
    _l_valuAllVal           = [UIUtil makeLabel:@""];
    [_l_valuAllVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_valuAllVal];
    /****************************************/
    _tv_valuation    = [[UITextView alloc]init];
    _tv_valuation.editable       = false;
    _tv_valuation.scrollEnabled  = false;
    _tv_valuation.text           = [NSString stringWithFormat:@"積算評価は銀行融資の目安になります.\n土地は路線価と面積から、建物は建物構造ごとの再調達原価、築年数、床面積から計算します"];
    [_scrollView addSubview:_tv_valuation];
    /****************************************/
    _l_TitleTransition  = [UIUtil makeLabel:@"運営推移"];
    [_scrollView addSubview:_l_TitleTransition];
    /****************************************/
    _g_pmt  = [[Graph alloc]init];
    [_scrollView addSubview:_g_pmt];
    /****************************************/
    _g_cf   = [[Graph alloc]init];
    [_scrollView addSubview:_g_cf];
    /****************************************/
    if ( _addonMgr.saleAnalysys == true ){
        /****************************************/
        _g_drp      = [[Graph alloc]init];
        [_scrollView addSubview:_g_drp];
        /****************************************/
    }
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
        if ( _addonMgr.saleAnalysys == true ){
            if ( _pos.isPortrait == true ){
                _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2);
            } else {
                _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2.9);
            }
        } else {
            if ( _pos.isPortrait == true ){
                _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*1);
            } else {
                _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*1.5);
            }
        }
        _scrollView.bounces = YES;
    } else {
    }
    /****************************************/
    pos_y = 0.2*dy;
    [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleValuation x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_valuLand            x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_valuLandVal         x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_valuHouse           x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_valuHouseVal        x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_valuAll             x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_valuAllVal          x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    _tv_valuation.frame      = CGRectMake(pos_x,         pos_y, length30, dy*2.5);
    /*--------------------------------------*/
    pos_y = pos_y + dy*1.5;
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleTransition x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy*1.5;
    [_g_pmt     setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    [_g_pmt setNeedsDisplay];
    /*--------------------------------------*/
    pos_y = pos_y + dy*5;
    [_g_cf      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    [_g_cf setNeedsDisplay];
    if ( _addonMgr.saleAnalysys == true ){
        /*--------------------------------------*/
        pos_y = pos_y + dy*5;
        [_g_drp      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
        [_g_drp setNeedsDisplay];
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
    
    [UIUtil labelYen:_l_valuLandVal         yen:_modelRE.estate.land.valuation];
    [UIUtil labelYen:_l_valuHouseVal        yen:_modelRE.estate.house.valuation];
    [UIUtil labelYen:_l_valuAllVal          yen:_modelRE.estate.land.valuation+_modelRE.estate.house.valuation];
    /****************************************/
    Loan *_loan = _modelRE.investment.loan;
    
    GraphData *gd_pmt   = [[GraphData alloc]initWithData:[_loan getPmtArrayYear]];
    gd_pmt.precedent    = @"利息返済分";
    gd_pmt.type         = BAR_GPAPH;

    GraphData *gd_ppmt = [[GraphData alloc]initWithData:[_loan getPpmtArrayYear]];
    gd_ppmt.precedent   = @"元金返済分";
    gd_ppmt.type        = BAR_GPAPH;
      
    _g_pmt.GraphDataAll = [[NSArray alloc]initWithObjects:gd_pmt,gd_ppmt,nil];
    [_g_pmt setGraphtMinMax_xmin:0 ymin:0 xmax:_loan.periodYear+0.5 ymax:[_loan getPmtYear:1]];
    _g_pmt.title        = @"借入返済内訳";
    
    [_g_pmt setNeedsDisplay];
    /****************************************/
    [ModelCF setGraphData:_g_cf ModelRE:_modelRE ];
    _g_cf.title         = @"キャッシュフロー推移";
    [_g_cf setNeedsDisplay];
    /****************************************/
    GraphData *gd_drp = [[GraphData alloc]initWithData:[_modelRE getDebtRepaymentPeriodArray]];
    gd_drp.precedent   = @"債務償還年数=借入残高/税引前CF";
    gd_drp.type        = BAR_GPAPH;
    
    _g_drp.GraphDataAll = [[NSArray alloc]initWithObjects:gd_drp,nil];
    [_g_drp setGraphtMinMax_xmin:0
                            ymin:gd_drp.ymin
                            xmax:gd_drp.xmax+1
                            ymax:gd_drp.ymax];
    _g_drp.title        = @"債務償還年数推移";
    
    [_g_drp setNeedsDisplay];
    
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
