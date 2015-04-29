//
//  CacheFlowViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/27.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "CacheFlowViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "Pos.h"

@interface CacheFlowViewCtrl ()
{
    ModelRE             *_modelRE;
    Pos                 *_pos;

    UIScrollView        *_scrollView;
    UILabel             *_l_name;

    UILabel             *_l_price;
    UILabel             *_l_priceVal;
    UILabel             *_l_equity;
    UILabel             *_l_equityVal;
    UILabel             *_l_loanBorrow;
    UILabel             *_l_loanBorrowVal;
    UILabel             *_l_gpi;
    UILabel             *_l_gpiVal;
    UILabel             *_l_empex;
    UILabel             *_l_empexVal;
    UILabel             *_l_egi;
    UILabel             *_l_egiVal;
    UILabel             *_l_opex;
    UILabel             *_l_opexVal;
    UILabel             *_l_noi;
    UILabel             *_l_noiVal;
    UILabel             *_l_ads;
    UILabel             *_l_adsVal;
    UILabel             *_l_btcf;
    UILabel             *_l_btcfVal;
}
@end

@implementation CacheFlowViewCtrl

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"収支計算";
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

    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_name         = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_name];
    /****************************************/
    _l_price        = [UIUtil makeLabel:@"物件価格+諸費用"];
    [_l_price setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_price];
    /*--------------------------------------*/
    _l_priceVal     = [UIUtil makeLabel:@""];
    [_l_priceVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceVal];
    /****************************************/
    _l_equity      = [UIUtil makeLabel:@"自己資金"];
    [_l_equity setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_equity];
    /*--------------------------------------*/
    _l_equityVal   = [UIUtil makeLabel:@""];
    [_l_equityVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_equityVal];
    /****************************************/
    _l_loanBorrow   = [UIUtil makeLabel:@"借入金"];
    [_l_loanBorrow setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_loanBorrow];
    /*--------------------------------------*/
    _l_loanBorrowVal     = [UIUtil makeLabel:@""];
    [_l_loanBorrowVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_loanBorrowVal];
    /****************************************/
    _l_gpi          = [UIUtil makeLabel:@"潜在総収入(GPI)"];
    [_l_gpi setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_gpi];
    /*--------------------------------------*/
    _l_gpiVal       = [UIUtil makeLabel:@""];
    [_l_gpiVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_gpiVal];
    /****************************************/
    _l_empex        = [UIUtil makeLabel:@"空室損"];
    [_l_empex setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_empex];
    /*--------------------------------------*/
    _l_empexVal     = [UIUtil makeLabel:@""];
    [_l_empexVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_empexVal];
    /****************************************/
    _l_egi          = [UIUtil makeLabel:@"実効総収入(EGI)"];
    [_l_egi setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_egi];
    /*--------------------------------------*/
    _l_egiVal          = [UIUtil makeLabel:@""];
    [_l_egiVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_egiVal];
    /****************************************/
    _l_opex         = [UIUtil makeLabel:@"運営費(Opex)"];
    [_l_opex setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opex];
    /*--------------------------------------*/
    _l_opexVal     = [UIUtil makeLabel:@""];
    [_l_opexVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_opexVal];
    /****************************************/
    _l_noi          = [UIUtil makeLabel:@"営業純利益(NOI)"];
    [_l_noi setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_noi];
    /*--------------------------------------*/
    _l_noiVal       = [UIUtil makeLabel:@""];
    [_l_noiVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_noiVal];
    /****************************************/
    _l_ads          = [UIUtil makeLabel:@"負債支払額(ADS)"];
    [_l_ads setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_ads];
    /*--------------------------------------*/
    _l_adsVal       = [UIUtil makeLabel:@""];
    [_l_adsVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_adsVal];
    /****************************************/
    _l_btcf         = [UIUtil makeLabel:@"税引前CF"];
    [_l_btcf setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_btcf];
    /*--------------------------------------*/
    _l_btcfVal     = [UIUtil makeLabel:@""];
    [_l_btcfVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_btcfVal];
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
        [UIUtil setLabel:_l_price           x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_priceVal        x:pos_x+dx*1.5    y:pos_y length:_pos.len15];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_equity          x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_equityVal       x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_loanBorrow      x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_loanBorrowVal   x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_gpi             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_gpiVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_empex           x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_empexVal        x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_egi             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_egiVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_opex            x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_opexVal         x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_noi             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_noiVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_ads             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_adsVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_btcf            x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_btcfVal         x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        
//        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
        
    }else {
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price           x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_priceVal        x:pos_x+dx*0.75 y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        dy = dy*0.7;
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_equity          x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_equityVal       x:pos_x+dx*0.75 y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_loanBorrow      x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_loanBorrowVal   x:pos_x+dx*0.75 y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        /*--------------------------------------*/
        pos_y = 1.2*_pos.dy;
        [UIUtil setLabel:_l_gpi             x:_pos.x_center     y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_gpiVal          x:_pos.x_center+dx*0.75  y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_empex           x:_pos.x_center     y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_empexVal        x:_pos.x_center+dx*0.75  y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_egi             x:_pos.x_center     y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_egiVal          x:_pos.x_center+dx*0.75  y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_opex     x:_pos.x_center       y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_opexVal  x:_pos.x_center+dx*0.75     y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_noi     x:_pos.x_center       y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_noiVal  x:_pos.x_center+dx*0.75    y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_ads     x:_pos.x_center       y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_adsVal  x:_pos.x_center+dx*0.75     y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_btcf     x:_pos.x_center       y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_btcfVal  x:_pos.x_center+dx*0.75     y:pos_y length:_pos.len15/2];
        /*--------------------------------------*/
//        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
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
    [UIUtil labelYen:_l_priceVal        yen:(_modelRE.investment.prices.price+_modelRE.investment.expense)];
    [UIUtil labelYen:_l_equityVal       yen:_modelRE.investment.equity];
    [UIUtil labelYen:_l_loanBorrowVal   yen:_modelRE.investment.loan.loanBorrow];
    [UIUtil labelYen:_l_gpiVal          yen:_modelRE.investment.prices.gpi];
    _l_empex.text           = [NSString stringWithFormat:@"空室損(%2.1f%%)",_modelRE.investment.emptyRate*100];
    [UIUtil labelYen:_l_empexVal        yen:-_modelRE.ope1.emptyLoss];
    [UIUtil labelYen:_l_egiVal          yen:_modelRE.ope1.egi];
    _l_opex.text            = [NSString stringWithFormat:@"運営費(Opex,%2.1f%%)",_modelRE.investment.mngRate*100];
    [UIUtil labelYen:_l_opexVal         yen:-_modelRE.ope1.opex];
    [UIUtil labelYen:_l_noiVal          yen:_modelRE.ope1.noi];
    [UIUtil labelYen:_l_adsVal          yen:-_modelRE.ope1.ads];
    [UIUtil labelYen:_l_btcfVal         yen:_modelRE.ope1.btcf];
    return;
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
