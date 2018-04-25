//
//  OperationViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "OperationViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "Pos.h"
#import "GridTable.h"

@interface OperationViewCtrl ()
{
    ModelRE             *_modelRE;
    UIScrollView        *_scrollView;
    UIView              *_uv_grid;
    Pos                 *_pos;
    UILabel             *_l_name;
    
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
    UILabel             *_l_TitleSafety;
    UILabel             *_l_dcr;
    UILabel             *_l_dcrVal;
    UILabel             *_l_ber;
    UILabel             *_l_berVal;
    UILabel             *_l_ltv;
    UILabel             *_l_ltvVal;
    
    UITextView          *_tv_comment1;
    UITextView          *_tv_comment2;

}
@end

@implementation OperationViewCtrl
//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"運営";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _modelRE = [ModelRE sharedManager];
    }
    return self;
}
//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
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
    _uv_grid = [GridTable makeGridTable];
    [_scrollView addSubview:_uv_grid];
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
    /****************************************/
    _tv_comment2    = [[UITextView alloc]init];
    _tv_comment2.editable       = false;
    _tv_comment2.scrollEnabled  = false;
    _tv_comment2.text           = [NSString stringWithFormat:@""];
    [_scrollView addSubview:_tv_comment2];
    /****************************************/

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
//    [_scrollView setFrame:CGRectMake(_pos.frame.origin.x, _pos.frame.origin.y, _pos.frame.size.width, _pos.frame.size.height*2)];
    [_scrollView setFrame:_pos.frame];
    _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2);
    /****************************************/
    pos_y = 0.2*dy;
    if ( _pos.isPortrait == true ){
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
        pos_y = pos_y + dy;
        [GridTable setRectScroll:_uv_grid rect:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*6)];
        
    }else {
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
        pos_y = pos_y + dy;
        [GridTable setRectScroll:_uv_grid rect:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*6)];
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
    [GridTable setScroll:_uv_grid table:[_modelRE getOperationArray]];

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
