//
//  EstateViewCtrl.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/14.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "EstateViewCtrl.h"
#import "ModelRE.h"
#import "UIUtil.h"
#import "Pos.h"


#if 0
#import "SettingViewCtrl.h"
#import "CalculatorModalViewCtrl.h"
#import "LandAssessmentViewCtrl.h"
#import "SettingLoan.h"
#import "BuildYearPV.h"
#import "ConstructPV.h"
#endif

@interface EstateViewCtrl ()
{
    ModelRE         *_modelRE;

    UIScrollView    *_scrollView;
    
    UITextField     *_t_name;

    UILabel         *_l_price;
    UITextField     *_t_price;

    UILabel         *_l_expence;
    UITextField     *_t_expence;
    
    UILabel         *_l_selfFinance;
    UITextField     *_t_selfFinance;
    
    UILabel         *_l_lb;
    
    UILabel         *_l_interest;
    
    
#if 0
    SettingViewCtrl         *_settingVC;
    BuildYearPV             *_buildYearPV;
    ConstructPV             *_constructPV;
    CalculatorModalViewCtrl *_calcVC;
    LandAssessmentViewCtrl  *_landAssessmentVC;
    SettingLoan         *_set_loan;
#endif
    Pos                     *_pos;

    UITextField     *_t_expense;
    UITextField     *_t_selfFnc;

    UITextField     *_t_interest;

    UITextField     *_t_landPrice;
    UIButton        *_btn_landArea;
    UITextField     *_t_landAssessment;
    UIButton        *_btn_landAssessment;

    UITextField     *_t_housePrice;
    UITextField     *_t_houseArea;
    UITextField     *_t_rooms;
    UIButton        *_btn_buildYear;
    UIButton        *_btn_construct;

    UIButton        *_btn_save;
    UIButton        *_btn_load;
    
    UILabel         *_l_lb_val;
    UILabel         *_l_gpi_val;
    UILabel         *_l_empex_val;
    UILabel         *_l_egi_val;
    UILabel         *_l_opex_val;
    UILabel         *_l_noi_val;
    UILabel         *_l_ads_val;
    UILabel         *_l_btcf_val;
    UILabel         *_l_tax_val;
    UILabel         *_l_atcf_val;
    
}

@end

@implementation EstateViewCtrl
#define TTAG_NAME           1


#define TAG_CONSTRUCT       1
#define TAG_BUILD_YEAR      2
#define TAG_LOAD            3
#define TAG_SAVE            4
#define TAG_LAND_AREA       5
#define TAG_LAND_ASSESSMENT 6

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title = @"物件";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
#if 1
        UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithTitle:@"設定" style:UIBarButtonItemStylePlain target:self action:@selector(showSettingView:)];
        self.navigationItem.rightBarButtonItem = button;
#endif
        self.view.backgroundColor = [UIColor  colorWithRed:1.0 green:1.0 blue:0.88 alpha:1.0]; //LightYellow;
    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (void)showSettingView:(id)sender
{
//    _settingVC = [[SettingViewCtrl alloc]init];
//    [self.navigationController pushViewController:_settingVC animated:YES];
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    /****************************************/
    _modelRE    = [ModelRE sharedManager];
    /****************************************/

    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _t_name        = [UIUtil makeTextField:@"" tgt:self];
    _t_name.text   = _modelRE.estate.name;
    [_t_name   setTag:TTAG_NAME];
    [_t_name   setDelegate:(id)self];
    [_scrollView addSubview:_t_name];
    /****************************************/
    _l_price        = [UIUtil makeLabel:@"物件価格"];
    [_scrollView addSubview:_l_price];
    /****************************************/
    _l_expence      = [UIUtil makeLabel:@"諸経費"];
    [_scrollView addSubview:_l_expence];
    /****************************************/
    _l_selfFinance  = [UIUtil makeLabel:@"自己資金"];
    [_scrollView addSubview:_l_selfFinance];
    /****************************************/
    _l_lb           = [UIUtil makeLabel:@"借入金"];
    [_scrollView addSubview:_l_lb];
    /****************************************/
    _l_interest     = [UIUtil makeLabel:@"表面利回り"];
    [_scrollView addSubview:_l_interest];
    /****************************************/
    
    [self viewMake];

#if 0
    /****************************************/
    _modelRE    = [ModelRE sharedManager];
    _set_loan   = [SettingLoan sharedManager];
    Investment  *tmpInvest      = _modelRE.investment;
    Estate      *tmpEstate      = _modelRE.estate;
    /****************************************/
#endif
#if 0
    // ページコントロールのインスタンス化
    CGFloat x = (width - 300) / 2;
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(x, height-120, 300, 50)];
    
    // 背景色を設定
    pageControl.backgroundColor = [UIColor blackColor];
    
    // ページ数を設定
    pageControl.numberOfPages = pageSize;
    
    // 現在のページを設定
    pageControl.currentPage = 0;
    
    // ページコントロールをタップされたときに呼ばれるメソッドを設定
    pageControl.userInteractionEnabled = YES;
    [pageControl addTarget:self
                    action:@selector(pageControl_Tapped:)
          forControlEvents:UIControlEventValueChanged];
    
    // ページコントロールを貼付ける
    [self.view addSubview:pageControl];
#endif
#if 0
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,lengthR;
    CGRect rect;
    rect = self.view.bounds;
    rect.origin.y       += 45;
    _pos = [[Pos alloc]initWithBounds:rect];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    /****************************************/
    pos_y = _pos.y_top;
    UILabel *l_bukken;
    l_bukken    = [UIUtil makeTitleLabel_x:pos_x y:pos_y viewWidth:self.view.bounds.size.width
                                      text:tmpEstate.name];
    [self.view addSubview:l_bukken];
    /****************************************/
    pos_y = pos_y + dy;
    rect = CGRectMake(self.view.bounds.origin.x,
                      pos_y+2,
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - pos_y);
    _scrollView = [UIUtil makeScrollView:rect xpage:1 ypage:3 tgt:self];
    _scrollView.pagingEnabled = YES;
    /****************************************/
    pos_y = 0 - dy;
    /****************************************/
    pos_y = pos_y + dy;
    UILabel* l_price;
    l_price         = [UIUtil makeLabel_x:pos_x             y:pos_y     length:length
                                     text:@"物件価格"];
    UILabel *l_expense;
    l_expense       = [UIUtil makeLabel_x:pos_x+dx          y:pos_y     length:length
                                     text:@"諸経費"];
    UILabel *l_selfFnc;
    l_selfFnc       = [UIUtil makeLabel_x:pos_x+dx*2        y:pos_y     length:length
                                     text:@"自己資金"];
    [_scrollView addSubview:l_price];
    [_scrollView addSubview:l_expense];
    [_scrollView addSubview:l_selfFnc];
    /****************************************/
    pos_y = pos_y + dy;
    _t_price         = [UIUtil makeTextFieldDec_x:pos_x         y:pos_y     length:length
                                     text:[NSString stringWithFormat:@"%ld",(long)tmpInvest.prices.price/10000]    tgt:self];
    _t_expense       = [UIUtil makeTextFieldDec_x:pos_x+dx*1    y:pos_y     length:length
                                            text:@"200"     tgt:self];
    _t_selfFnc       = [UIUtil makeTextFieldDec_x:pos_x+dx*2    y:pos_y     length:length
                                             text:@"500"     tgt:self];
    [_scrollView addSubview:_t_price];
    [_scrollView addSubview:_t_expense];
    [_scrollView addSubview:_t_selfFnc];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel *l_interest;
    l_interest      = [UIUtil makeLabel_x:      pos_x+dx*0      y:pos_y     length:length
                                     text:@"表面利回り"];
    _t_interest     = [UIUtil makeTextFieldDec_x:pos_x+dx*1     y:pos_y     length:length
                                             text:[NSString stringWithFormat:@"%2.1f",tmpInvest.prices.interest*100]    tgt:self];
    [_scrollView addSubview:l_interest];
    [_scrollView addSubview:_t_interest];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel* l_landPrice;
    l_landPrice     = [UIUtil makeLabel_x:pos_x         y:pos_y     length:length
                                         text:@"土地価格"];
    UILabel *l_landAreae;
    l_landAreae     = [UIUtil makeLabel_x:pos_x+dx      y:pos_y     length:length
                                     text:@"土地面積"];
    UILabel *l_landAssessment;
    l_landAssessment= [UIUtil makeLabel_x:pos_x+dx*2    y:pos_y     length:length
                                     text:@"路線価"];
    [_scrollView addSubview:l_landPrice];
    [_scrollView addSubview:l_landAreae];
    [_scrollView addSubview:l_landAssessment];
    /****************************************/
    pos_y = pos_y + dy;
    _t_landPrice         = [UIUtil makeTextFieldDec_x:pos_x              y:pos_y     length:length
                                                text:[NSString stringWithFormat:@"%ld",(long)tmpEstate.land.price/10000]    tgt:self];
    _btn_landArea       = [UIUtil makeTextButton_x:pos_x+dx*1        y:pos_y     length:length
                                              text:@"999"    tag:TAG_LAND_AREA];
    [_btn_landArea  addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    _t_landAssessment           = [UIUtil makeTextFieldDec:[NSString stringWithFormat:@"%g",tmpEstate.land.assessment]    tgt:self];
    [UIUtil setTextField:_t_landAssessment x:pos_x+dx*2              y:pos_y     length:length];
    [_scrollView addSubview:_t_landPrice];
    [_scrollView addSubview:_btn_landArea];
    [_scrollView addSubview:_t_landAssessment];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel* l_bldPrice;
    l_bldPrice          = [UIUtil makeLabel_x:pos_x         y:pos_y     length:length
                                         text:@"建物価格"];
    UILabel *l_floorAreae;
    l_floorAreae        = [UIUtil makeLabel_x:pos_x+dx      y:pos_y     length:length
                                         text:@"床面積"];
    UILabel *l_rooms;
    l_rooms             = [UIUtil makeLabel_x:pos_x+dx*2    y:pos_y      length:length
                                         text:@"戸数"];
    [_scrollView addSubview:l_bldPrice];
    [_scrollView addSubview:l_floorAreae];
    [_scrollView addSubview:l_rooms];
    /****************************************/
    pos_y = pos_y + dy;
    _t_housePrice       = [UIUtil makeTextFieldDec_x:pos_x      y:pos_y length:length text:@"9999"      tgt:self];
    _t_houseArea        = [UIUtil makeTextFieldDec_x:pos_x+dx*1 y:pos_y length:length text:@"999.99"    tgt:self];
    _t_rooms            = [UIUtil makeTextFieldDec_x:pos_x+dx*2 y:pos_y length:length text:@"99"        tgt:self];
    [_scrollView addSubview:_t_housePrice];
    [_scrollView addSubview:_t_houseArea];
    [_scrollView addSubview:_t_rooms];
    /****************************************/
    pos_y = pos_y + dy;
    _btn_buildYear      = [UIUtil makeButton:@"築１０年" tag:TAG_BUILD_YEAR];
    _btn_construct      = [UIUtil makeButton:@"木造" tag:TAG_CONSTRUCT];
    _btn_landAssessment = [UIUtil makeButton:@"路線価計算"    tag:TAG_LAND_ASSESSMENT];

    [UIUtil setButton:_btn_buildYear        x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setButton:_btn_construct        x:pos_x+dx*1    y:pos_y length:length];
    [UIUtil setButton:_btn_landAssessment   x:pos_x+dx*2    y:pos_y length:length];

    [_btn_buildYear         addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_construct         addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_landAssessment    addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

    [_scrollView addSubview:_btn_buildYear];
    [_scrollView addSubview:_btn_construct];
    [_scrollView addSubview:_btn_landAssessment];
    /****************************************/
    pos_y = pos_y + 1.5*dy;
    _btn_load       = [UIUtil makeButton_x:pos_x+0*dx       y:pos_y     length:length
                                      text:@"ロード" tag:TAG_LOAD];
    [_btn_load  addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    _btn_save       = [UIUtil makeButton_x:pos_x+1*dx       y:pos_y     length:length
                                      text:@"セーブ" tag:TAG_SAVE];
    [_btn_save  addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    _btn_landAssessment = [UIUtil makeTextButton_x:pos_x+dx*2        y:pos_y     length:length
                                              text:@"99.9"    tag:TAG_LAND_ASSESSMENT];
    [_btn_landAssessment  addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btn_load];
    [_scrollView addSubview:_btn_save];
    /****************************************/
    /****************************************/
    pos_y = pos_y + 4.5*dy;
    UILabel         *_l_lb;
    _l_lb           = [UIUtil makeLabelR_x:pos_x     y:pos_y        length:lengthR
                                      text:@"借入金(LB)"];
    _l_lb_val       = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y        length:lengthR
                                      text:@"借入金"];
    [_scrollView addSubview:_l_lb];
    [_scrollView addSubview:_l_lb_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_gpi;
    _l_gpi          = [UIUtil makeLabelR_x:pos_x     y:pos_y        length:lengthR
                                      text:@"潜在総収入(GPI)" ];
    _l_gpi_val      = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y        length:lengthR
                                      text:@"潜在総収入"];
    [_scrollView addSubview:_l_gpi];
    [_scrollView addSubview:_l_gpi_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_empex;
    _l_empex        = [UIUtil makeLabelR_x:pos_x     y:pos_y        length:lengthR
                                      text:@"空室損"];
    _l_empex_val    = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y        length:lengthR
                                      text:@"潜在総収入"];
    [_scrollView addSubview:_l_empex];
    [_scrollView addSubview:_l_empex_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_egi;
    _l_egi          = [UIUtil makeLabelR_x:pos_x     y:pos_y length:lengthR
                                      text:@"実効総収入(EGI)" ];
    _l_egi_val      = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y length:lengthR
                                      text:@"潜在総収入" ];
    [_scrollView addSubview:_l_egi];
    [_scrollView addSubview:_l_egi_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_opex;
    _l_opex         = [UIUtil makeLabelR_x:pos_x     y:pos_y length:lengthR
                                      text:@"運営費(Opex)" ];
    _l_opex_val     = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y  length:lengthR
                                      text:@"潜在総収入"];
    [_scrollView addSubview:_l_opex];
    [_scrollView addSubview:_l_opex_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_noi;
    _l_noi          = [UIUtil makeLabelR_x:pos_x     y:pos_y length:lengthR
                                      text:@"営業純利益(NOI)" ];
    _l_noi_val      = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y length:lengthR
                                      text:@"潜在総収入" ];
    [_scrollView addSubview:_l_noi];
    [_scrollView addSubview:_l_noi_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_ads;
    _l_ads          = [UIUtil makeLabelR_x:pos_x     y:pos_y length:lengthR
                                      text:@"負債支払額(ADS)" ];
    _l_ads_val      = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y length:lengthR
                                      text:@"潜在総収入" ];
    [_scrollView addSubview:_l_ads];
    [_scrollView addSubview:_l_ads_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_btcf;
    _l_btcf         = [UIUtil makeLabelR_x:pos_x     y:pos_y    length:lengthR
                                      text:@"税引前CF" ];
    _l_btcf_val     = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y    length:lengthR
                                      text:@"潜在総収入" ];
    [_scrollView addSubview:_l_btcf];
    [_scrollView addSubview:_l_btcf_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_tax;
    _l_tax          = [UIUtil makeLabelR_x:pos_x     y:pos_y    length:lengthR
                                      text:@"固都税/所得税" ];
    _l_tax_val      = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y    length:lengthR
                                      text:@"" ];
    [_scrollView addSubview:_l_tax];
    [_scrollView addSubview:_l_tax_val];
    /****************************************/
    pos_y = pos_y + dy;
    UILabel         *_l_atcf;    
    _l_atcf         = [UIUtil makeLabelR_x:pos_x     y:pos_y    length:lengthR
                                      text:@"税引後CF" ];
    _l_atcf_val     = [UIUtil makeLabelR_x:pos_x+dx  y:pos_y    length:lengthR
                                      text:@"" ];
    [_scrollView addSubview:_l_atcf];
    [_scrollView addSubview:_l_atcf_val];

    /****************************************/
    [self.view addSubview:_scrollView];
    /****************************************/
    [self rewriteProperty];
    /****************************************/
    _buildYearPV    = [[BuildYearPV alloc]initWitTarget:self frame:rect];
    _constructPV    = [[ConstructPV alloc]initWitTarget:self frame:rect];
#endif
}
/****************************************************************
 *
 ****************************************************************/
- (void)viewMake
{
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,lengthR;
    _pos = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    /****************************************/
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0;
    [UIUtil setTitleTextField:_t_name x:pos_x y:pos_y viewWidth:self.view.bounds.size.width];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_price       x:pos_x         y:pos_y length:length];
    [UIUtil setLabel:_l_expence     x:pos_x+dx      y:pos_y length:length];
    [UIUtil setLabel:_l_selfFinance x:pos_x+dx*2    y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_interest    x:pos_x         y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_lb          x:pos_x         y:pos_y length:length];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#if 0
    /****************************************/
    [_set_loan makeSegmentedControl:_pos.x_left
                                  y:_pos.y_btm - _pos.dy*1.5
                             length:_pos.len30];
    [_set_loan.sc addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_set_loan.sc];
#endif
    /****************************************/
    [self rewriteProperty];
    /****************************************/
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
    //    NSLog(@"%s",__FUNCTION__);
    //    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskAll;
}

/****************************************************************
 * 回転時に処理したい内容
 ****************************************************************/
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self viewMake];
}
/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
#if 0
    if ( sender.tag == TAG_BUILD_YEAR ){
        [_buildYearPV setIndex_buildYear:_modelRE.estate.house.buildYear];
        [_buildYearPV showPickerView:self.view];
        
    }else if (sender.tag == TAG_CONSTRUCT ){
        [_constructPV setIndex_construct:_modelRE.estate.house.construct];
        [_constructPV showPickerView:self.view];
        
    } else if ( sender.tag == TAG_SAVE ){
        [_modelRE saveData];
        
    } else if ( sender.tag == TAG_LOAD ){
        [_modelRE loadData];
        
    } else if ( sender.tag == TAG_LAND_AREA ){
        Estate      *tmpEstate      = _modelRE.estate;
        _calcVC = [[CalculatorModalViewCtrl alloc]initWithValue:tmpEstate.land.area target:self];
        [self presentViewController:_calcVC animated:YES completion:nil];
    } else if ( sender.tag == TAG_LAND_ASSESSMENT ){
        Estate      *tmpEstate      = _modelRE.estate;
        _landAssessmentVC = [[LandAssessmentViewCtrl alloc]initWithValue:tmpEstate.land.assessment target:self];
        [self presentViewController:_landAssessmentVC  animated:YES completion:nil];
    }
#endif
}
/****************************************************************
 *
 ****************************************************************/
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
#if 0
    Investment  *tmpInvest      = _modelRE.investment;
    Estate      *tmpEstate      = _modelRE.estate;
    tmpInvest.prices.price      = [_t_price.text    integerValue] * 10000;
    tmpInvest.selfFinance       = [_t_selfFnc.text  integerValue] * 10000;
    tmpInvest.expense           = [_t_expense.text  integerValue] * 10000;
    tmpInvest.prices.interest   = [_t_interest.text  floatValue] / 100;
    [tmpEstate setLandPrice:[_t_landPrice.text integerValue] * 10000];
    [tmpEstate setHousePrice:[_t_housePrice.text integerValue] * 10000];
    tmpEstate.house.area        = [_t_houseArea.text floatValue];
    tmpEstate.house.rooms       = [_t_rooms.text integerValue];
    tmpEstate.land.assessment   = [_t_landAssessment.text floatValue];
#endif
    [self rewriteProperty];
}

/****************************************************************
 *
 ****************************************************************/
- (BOOL)closePopup:(id)sender
{
#if 0
    _modelRE.estate.house.buildYear = _buildYearPV.year;
    _modelRE.estate.house.construct = _constructPV.construct;
#endif
    [self rewriteProperty];
    return YES;
    
}
/****************************************************************
 *
 ****************************************************************/
-(void)changeSeg:(SVSegmentedControl*)seg
{
#if 0
    Investment  *tmpInvest      = _modelRE.investment;
    SettingLoan *set_loan = [SettingLoan sharedManager];
    switch(_set_loan.sc.selectedSegmentIndex){
        case 0:
            tmpInvest.loan  = set_loan.loan0;
            break;
        case 1:
            tmpInvest.loan  = set_loan.loan1;
            break;
        case 2:
            tmpInvest.loan  = set_loan.loan2;
            break;
    }
#endif
    [self rewriteProperty];
}
/****************************************************************
 *
 ****************************************************************/
-(void)rewriteProperty
{
    
    _t_name.text    = _modelRE.estate.name;
    
#if 0
    /*--------------------------------------*/
    SettingLoan *set_loan = [SettingLoan sharedManager];
    NSString *seg0 = [NSString stringWithFormat:@"%g%% %2d年",set_loan.loan0.rateYear*100,(int)set_loan.loan0.periodYear];
    NSString *seg1 = [NSString stringWithFormat:@"%g%% %2d年",set_loan.loan1.rateYear*100,(int)set_loan.loan1.periodYear];
    NSString *seg2 = [NSString stringWithFormat:@"%g%% %2d年",set_loan.loan2.rateYear*100,(int)set_loan.loan2.periodYear];
    NSArray *arr = [NSArray arrayWithObjects:seg0,seg1,seg2,nil];
    [_set_loan.sc setSectionTitles:arr];
    /*--------------------------------------*/

    Investment  *tmpInvest      = _modelRE.investment;
    Estate      *tmpEstate      = _modelRE.estate;
    [tmpInvest calcAll];
    _t_price.text       = [NSString stringWithFormat:@"%ld",(long)tmpInvest.prices.price  / 10000];
    _t_selfFnc.text     = [NSString stringWithFormat:@"%ld",(long)tmpInvest.selfFinance   / 10000];
    _t_expense.text     = [NSString stringWithFormat:@"%ld",(long)tmpInvest.expense       / 10000];
    _t_interest.text    = [NSString stringWithFormat:@"%g",(float)tmpInvest.prices.interest * 100];
    _t_landPrice.text   = [NSString stringWithFormat:@"%ld",(long)tmpEstate.land.price    / 10000];
    _t_landAssessment.text  = [NSString stringWithFormat:@"%g",tmpEstate.land.assessment];
    NSInteger year = [UIUtil getThisYear] - tmpEstate.house.buildYear;
    if ( year < 0 ){
        [_btn_buildYear     setTitle:[NSString stringWithFormat:@"建築中"]   forState:UIControlStateNormal];
    }else{
        [_btn_buildYear     setTitle:[NSString stringWithFormat:@"築%2d年",(int)year]   forState:UIControlStateNormal];
    }
    [_btn_construct     setTitle:[NSString stringWithFormat:@"%@",[House constructStr:tmpEstate.house.construct]]   forState:UIControlStateNormal];
    [_btn_landArea      setTitle:[NSString stringWithFormat:@"%g",(float)tmpEstate.land.area]   forState:UIControlStateNormal];
    [_btn_landAssessment setTitle:[NSString stringWithFormat:@"%2.1g",(float)tmpEstate.land.assessment]   forState:UIControlStateNormal];
    _t_housePrice.text  = [NSString stringWithFormat:@"%ld",(long)tmpEstate.house.price   / 10000];
    _t_houseArea.text   = [NSString stringWithFormat:@"%g",(float)tmpEstate.house.area];
    _t_rooms.text       = [NSString stringWithFormat:@"%ld",(long)tmpEstate.house.rooms];

    
    _l_lb_val           = [UIUtil labelYen:_l_lb_val yen:tmpInvest.loan.loanBorrow];
    _l_gpi_val          = [UIUtil labelYen:_l_gpi_val yen:tmpInvest.prices.gpi];
    _l_empex_val        = [UIUtil labelYen:_l_empex_val yen:-tmpInvest.emptyLoss];
    _l_egi_val          = [UIUtil labelYen:_l_egi_val yen:tmpInvest.egi];
    _l_opex_val         = [UIUtil labelYen:_l_opex_val yen:-tmpInvest.opex];
    _l_noi_val          = [UIUtil labelYen:_l_noi_val yen:tmpInvest.noi];
    _l_noi_val          = [UIUtil labelYen:_l_ads_val yen:tmpInvest.ads];
    _l_btcf_val         = [UIUtil labelYen:_l_btcf_val yen:tmpInvest.btcf];
    _l_tax_val          = [UIUtil labelYen:_l_tax_val yen:-tmpInvest.tax];
    _l_atcf_val         = [UIUtil labelYen:_l_atcf_val yen:tmpInvest.atcf];
#endif



}
/****************************************************************
 *
 ****************************************************************/
/**
 * スクロールビューがスワイプされたとき
 * @attention UIScrollViewのデリゲートメソッド
 */
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    if ((NSInteger)fmod(scrollView.contentOffset.x , pageWidth) == 0) {
        // ページコントロールに現在のページを設定
        pageControl.currentPage = scrollView.contentOffset.x / pageWidth;
    }
}
/****************************************************************
 * ページコントロールがタップされたとき
 ****************************************************************/
- (void)pageControl_Tapped:(id)sender
{
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    [scrollView scrollRectToVisible:frame animated:YES];
}

/****************************************************************
 *
 ****************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
