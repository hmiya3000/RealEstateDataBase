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

@interface GraphViewCtrl ()
{
    ModelRE             *_modelRE;
    UIScrollView        *_scrollView;
    UIView              *_uv_grid;
    Pos                 *_pos;
    UILabel             *_l_name;

    Graph               *_g_pmt;
    Graph               *_g_cf;
    Graph               *_g_loan;

}
@end

@implementation GraphViewCtrl
/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"グラフ";
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
    _g_pmt  = [[Graph alloc]init];
    [_scrollView addSubview:_g_pmt];
    /****************************************/
    _g_cf   = [[Graph alloc]init];
    [_scrollView addSubview:_g_cf];
    /****************************************/
    _g_loan     = [[Graph alloc]init];
    [_scrollView addSubview:_g_loan];
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
        /****************************************/
        pos_y = pos_y + dy*2;
        [_g_pmt     setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
        pos_y = pos_y + dy*5;
        [_g_cf      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
        pos_y = pos_y + dy*5;
        [_g_loan    setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
    }else {
        [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
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
    
    /****************************************/
    Loan *_loan = _modelRE.investment.loan;
    
    GraphData *gd_ppmt = [[GraphData alloc]initWithData:[_loan getPpmtArrayYear]];
    gd_ppmt.precedent   = @"元金返済分";
    gd_ppmt.type        = BAR_GPAPH;
    
    GraphData *gd_pmt   = [[GraphData alloc]initWithData:[_loan getPmtArrayYear]];
    gd_pmt.precedent    = @"利息分";
    gd_pmt.type         = BAR_GPAPH;

    
    _g_pmt.GraphDataAll = [[NSArray alloc]initWithObjects:gd_pmt,gd_ppmt,nil];
    [_g_pmt setGraphtMinMax_xmin:0 ymin:0 xmax:_loan.periodYear+0.5 ymax:[_loan getPmtYear:1]];
    
    [_g_pmt setNeedsDisplay];
    /****************************************/
    [ModelCF setGraphData:_g_cf ModelRE:_modelRE ];
    [_g_cf setNeedsDisplay];
    /****************************************/

    
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