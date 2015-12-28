//
//  SalesCFViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/04.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "SalesCFViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "Pos.h"

@interface SalesCFViewCtrl ()
{
    ModelRE             *_modelRE;
    Pos                 *_pos;
    
    UIScrollView        *_scrollView;
    UILabel             *_l_name;
    
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
    
}
@end

@implementation SalesCFViewCtrl

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"物件売却";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _modelRE = [ModelRE sharedManager];
    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *retButton =
    [[UIBarButtonItem alloc] initWithTitle:@"物件リスト"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(retButtonTapped:)];
    self.navigationItem.leftBarButtonItem = retButton;
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_name         = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_name];
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
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
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
    dy          = _pos.dy;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    length30    = _pos.len30;
    /****************************************/
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0.2*dy;
    if ( _pos.isPortrait == true ){
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price             x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_priceVal          x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferExp       x:pos_x           y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_transferExpVal    x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_lb       x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_lbVal    x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_btcf             x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_btcfVal          x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_amCosts              x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_amCostsVal           x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferIncome             x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_transferIncomeVal          x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferTax             x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_transferTaxVal          x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_atcf             x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_atcfVal          x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        
    }else {
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price               x:pos_x                 y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_priceVal            x:pos_x+dx*0.75         y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        dy = dy*0.7;
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferExp         x:pos_x                 y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_transferExpVal      x:pos_x+dx*0.75         y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_lb                  x:pos_x                 y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_lbVal               x:pos_x+dx*0.75         y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_btcf                x:pos_x                 y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_btcfVal             x:pos_x+dx*0.75         y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        /*--------------------------------------*/
        pos_y = 1.2*_pos.dy;
        [UIUtil setLabel:_l_amCosts             x:_pos.x_center         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_amCostsVal          x:_pos.x_center+dx*0.75    y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferIncome      x:_pos.x_center         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_transferIncomeVal   x:_pos.x_center+dx*0.75    y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_transferTax         x:_pos.x_center         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_transferTaxVal      x:_pos.x_center+dx*0.75    y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_atcf                x:_pos.x_center         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_atcfVal             x:_pos.x_center+dx*0.75    y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        /*--------------------------------------*/
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
    _l_name.text            = _modelRE.estate.name;
    [UIUtil labelYen:_l_priceVal            yen:_modelRE.sale.price];
    [UIUtil labelYen:_l_transferExpVal      yen:-_modelRE.sale.expense];
    [UIUtil labelYen:_l_lbVal               yen:-_modelRE.sale.loanBorrow];
    [UIUtil labelYen:_l_btcfVal             yen:_modelRE.sale.btcf];
    [UIUtil labelYen:_l_amCostsVal          yen:-_modelRE.sale.amCosts];
    [UIUtil labelYen:_l_transferIncomeVal   yen:_modelRE.sale.transferIncome];
    [UIUtil labelYen:_l_transferTaxVal      yen:-_modelRE.sale.transferTax];
    [UIUtil labelYen:_l_atcfVal             yen:_modelRE.sale.atcf];
}
/****************************************************************
 *
 ****************************************************************/
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
