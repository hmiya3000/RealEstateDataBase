//
//  LoanViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/09/13.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "LoanViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "Pos.h"
#import "Graph.h"
#import "GraphData.h"
#import "AddonMgr.h"


@interface LoanViewCtrl ()
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
    
    UILabel             *_l_TitleBank;
    UILabel             *_l_BtIncome;
    UILabel             *_l_BtIncomeVal;
    UILabel             *_l_AmuCost;
    UILabel             *_l_AmuCostVal;
    UILabel             *_l_DeclaredIncome;
    UILabel             *_l_DeclaredIncomeVal;
    UILabel             *_l_Atcf;
    UILabel             *_l_AtcfVal;
    UILabel             *_l_DebtRp;
    UILabel             *_l_DebtRpVal;
    UITextView          *_tv_bank;
    
    
    UILabel             *_l_TitleTransition;
    Graph               *_g_pmt;
    Graph               *_g_drp;
    
    AddonMgr            *_addonMgr;
}
@end
/****************************************************************/

@implementation LoanViewCtrl
/****************************************************************/
@synthesize masterVC    = _masterVC;

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"融資";
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
    _l_TitleTransition  = [UIUtil makeLabel:@"運営推移"];
    [_scrollView addSubview:_l_TitleTransition];
    /****************************************/
    _g_pmt  = [[Graph alloc]init];
    [_scrollView addSubview:_g_pmt];
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
    _l_TitleBank  = [UIUtil makeLabel:@"銀行評価"];
    [_scrollView addSubview:_l_TitleBank];
    /****************************************/
    _l_BtIncome          = [UIUtil makeLabel:@"銀行視点CF"];
    [_l_BtIncome setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_BtIncome];
    /*--------------------------------------*/
    _l_BtIncomeVal       = [UIUtil makeLabel:@""];
    [_l_BtIncomeVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_BtIncomeVal];
    /****************************************/
    _l_AmuCost          = [UIUtil makeLabel:@"減価償却費"];
    [_l_AmuCost setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_AmuCost];
    /*--------------------------------------*/
    _l_AmuCostVal       = [UIUtil makeLabel:@""];
    [_l_AmuCostVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_AmuCostVal];
    /****************************************/
    _l_DeclaredIncome          = [UIUtil makeLabel:@"申告所得(取得費除く)"];
    [_l_DeclaredIncome setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_DeclaredIncome];
    /*--------------------------------------*/
    _l_DeclaredIncomeVal       = [UIUtil makeLabel:@""];
    [_l_DeclaredIncomeVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_DeclaredIncomeVal];
    /****************************************/
    _l_Atcf          = [UIUtil makeLabel:@"税引後CF"];
    [_l_Atcf setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_Atcf];
    /*--------------------------------------*/
    _l_AtcfVal       = [UIUtil makeLabel:@""];
    [_l_AtcfVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_AtcfVal];
    /****************************************/
    _l_DebtRp          = [UIUtil makeLabel:@"債務償還年数(初年度)"];
    [_l_DebtRp setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_DebtRp];
    /*--------------------------------------*/
    _l_DebtRpVal       = [UIUtil makeLabel:@""];
    [_l_DebtRpVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_DebtRpVal];
    /****************************************/
    _tv_bank    = [[UITextView alloc]init];
    _tv_bank.editable       = false;
    _tv_bank.scrollEnabled  = false;
    _tv_bank.text           = [NSString stringWithFormat:@"まず申告所得と税引後CFが黒字かをみます.\n次に物件の稼ぐ力としてCF=申告所得＋減価償却費 とみなし\n債務償還年数=期末借入残高÷CFを算出し、20年以内は健全と判断します"];
    [_scrollView addSubview:_tv_bank];
    
    /****************************************/
    _g_drp      = [[Graph alloc]init];
    [_scrollView addSubview:_g_drp];
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
    [UIUtil setRectLabel:_l_TitleTransition x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [_g_pmt     setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    [_g_pmt setNeedsDisplay];
    pos_y = pos_y + dy*4;
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
    [UIUtil setRectLabel:_l_TitleBank x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_BtIncome            x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_BtIncomeVal         x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_AmuCost             x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_AmuCostVal          x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_DeclaredIncome      x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_DeclaredIncomeVal   x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_Atcf                x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_AtcfVal             x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_DebtRp          x:pos_x             y:pos_y length:length*2];
    [UIUtil setLabel:_l_DebtRpVal       x:pos_x+dx*1.5      y:pos_y length:lengthR];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [_g_drp      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    [_g_drp setNeedsDisplay];
    pos_y = pos_y + dy*3.5;
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    _tv_bank.frame      = CGRectMake(pos_x,         pos_y, length30, dy*3);
    pos_y = pos_y + dy*2;
    /*--------------------------------------*/
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
    
    /****************************************/
    [UIUtil labelYen:_l_valuLandVal         yen:_modelRE.estate.land.valuation];
    [UIUtil labelYen:_l_valuHouseVal        yen:_modelRE.estate.house.valuation];
    [UIUtil labelYen:_l_valuAllVal          yen:_modelRE.estate.land.valuation+_modelRE.estate.house.valuation];
    /****************************************/
    NSInteger amCost = [_modelRE.estate.house getAmortizationCosts_term:1];
    NSInteger btIncome = _modelRE.ope1.taxIncome+amCost;
    CGFloat   debtRp    = [_modelRE.investment.loan getLb:1] / btIncome;
    [UIUtil labelYen:_l_BtIncomeVal         yen:btIncome];
    [UIUtil labelYen:_l_AmuCostVal          yen:-amCost];
    [UIUtil labelYen:_l_DeclaredIncomeVal   yen:_modelRE.ope1.taxIncome];
    [UIUtil labelYen:_l_AtcfVal             yen:_modelRE.ope1.atcf];
    _l_DebtRpVal.text = [NSString stringWithFormat:@"%.1f年",debtRp];
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
