//
//  AnalysisViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/01.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "AnalysisViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "Pos.h"
#import "Finance.h"

@interface AnalysisViewCtrl ()
{
    ModelRE             *_modelRE;
    Pos                 *_pos;
    
    UIScrollView        *_scrollView;
    UILabel             *_l_name;
    
    UILabel             *_l_fcr;
    UILabel             *_l_fcrVal;
    UILabel             *_l_loanConst;
    UILabel             *_l_loanConstVal;
    UILabel             *_l_ccr;
    UILabel             *_l_ccrVal;
    UILabel             *_l_pb;
    UILabel             *_l_pbVal;
    UILabel             *_l_dcr;
    UILabel             *_l_dcrVal;
    UILabel             *_l_ber;
    UILabel             *_l_berVal;
    UILabel             *_l_ltv;
    UILabel             *_l_ltvVal;
    UILabel             *_l_capRate;
    UILabel             *_l_capRateVal;
    
}
@end

@implementation AnalysisViewCtrl

//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"投資分析";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _modelRE = [ModelRE sharedManager];
    }
    return self;
}

//======================================================================
//
//======================================================================
-(void)viewDidLoad {
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
    /****************************************/
    _l_capRate         = [UIUtil makeLabel:@"CapRate"];
    [_l_capRate setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_capRate];
    /*--------------------------------------*/
    _l_capRateVal     = [UIUtil makeLabel:@""];
    [_l_capRateVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_capRateVal];
    /****************************************/
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
}
//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
        [UIUtil setLabel:_l_fcr             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_fcrVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_loanConst       x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_loanConstVal    x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_ccr             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_ccrVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_pb              x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_pbVal           x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_dcr             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_dcrVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_ber             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_berVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_ltv             x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_ltvVal          x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_capRate         x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_capRateVal      x:pos_x+dx*2    y:pos_y length:_pos.len10];
        /*--------------------------------------*/
        
        //        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
        
    }else {
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_fcr             x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_fcrVal          x:pos_x+dx*1    y:pos_y length:_pos.len10/2];
        /*--------------------------------------*/
        dy = dy*0.7;
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_loanConst       x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_loanConstVal    x:pos_x+dx*1    y:pos_y length:_pos.len10/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_ccr             x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_ccrVal          x:pos_x+dx*1    y:pos_y length:_pos.len10/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_pb              x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_pbVal           x:pos_x+dx*1    y:pos_y length:_pos.len10/2];
        /*--------------------------------------*/
        /*--------------------------------------*/
        pos_y = 1.2*_pos.dy;
        [UIUtil setLabel:_l_dcr             x:_pos.x_center         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_dcrVal          x:_pos.x_center+dx*1    y:pos_y length:_pos.len10/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_ber             x:_pos.x_center         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_berVal          x:_pos.x_center+dx*1    y:pos_y length:_pos.len10/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_ltv             x:_pos.x_center         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_ltvVal          x:_pos.x_center+dx*1    y:pos_y length:_pos.len10/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_capRate         x:_pos.x_center         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_capRateVal      x:_pos.x_center+dx*1    y:pos_y length:_pos.len10/2];
        /*--------------------------------------*/
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
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

/****************************************************************
 * 回転時に処理したい内容
 ****************************************************************/
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
/****************************************************************
 * ビューがタップされたとき
 ****************************************************************/
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    //    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
}
//======================================================================
//
//======================================================================
-(void)rewriteProperty
{
    [_modelRE calcAll];
    _l_name.text            = _modelRE.estate.name;
    _l_fcrVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.fcr*100];
    _l_loanConstVal.text    = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.loanConst*100];
    _l_ccrVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.ccr*100];
    _l_pbVal.text           = [NSString stringWithFormat:@"%2.1f年",_modelRE.ope1.pb];

    _l_dcrVal.text          = [NSString stringWithFormat:@"%1.2f",_modelRE.ope1.dcr];
    _l_berVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.ber*100];
    _l_ltvVal.text          = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.ltv*100];
    _l_capRateVal.text      = [NSString stringWithFormat:@"%2.2f%%",_modelRE.ope1.capRate*100];
}
//======================================================================
//
//======================================================================
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
