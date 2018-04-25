//
//  InputOpeEmptyViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2016/03/27.
//  Copyright © 2016年 Beetre. All rights reserved.
//

#import "InputOpeEmptyViewCtrl.h"
#import "Graph.h"
#import "GraphData.h"

@interface InputOpeEmptyViewCtrl ()
{
    CGFloat             _declineRate;
    CGFloat             _emptyRate;
    NSInteger           _bootMonth;
    
    UILabel             *_l_bg;
    UILabel             *_l_declineRate;
    UILabel             *_l_emptyRate;
    UILabel             *_l_bootMonthVal;
    UILabel             *_l_addEmptyLoss;
    UILabel             *_l_addEmptyLossVal;
    
    UITextField         *_t_declineRate;
    UITextField         *_t_emptyRate;

    UITextView          *_tv_tips;

    UISlider            *_sl;

    Graph               *_g_rentroll;
    Graph               *_g_vacant;

}

@end

@implementation InputOpeEmptyViewCtrl
//======================================================================
#define TTAG_DECLINE        1
#define TTAG_EMPTY          2

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"空室想定";
    _declineRate    = _modelRE.declineRate;
    _emptyRate      = _modelRE.investment.emptyRate;
    _bootMonth      = _modelRE.investment.bootMonth;
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_bg           = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_bg];
    /****************************************/
    _l_declineRate      = [UIUtil makeLabel:@"家賃下落率[%]"];
    [_scrollView addSubview:_l_declineRate];
    /*--------------------------------------*/
    _l_emptyRate        = [UIUtil makeLabel:@"空室率[%]"];
    [_scrollView addSubview:_l_emptyRate];
    /****************************************/
    _t_declineRate      = [UIUtil makeTextFieldDec:@"0.00" tgt:self];
    [_t_declineRate     setTag:TTAG_DECLINE];
    [_t_declineRate     setDelegate:(id)self];
    [_scrollView addSubview:_t_declineRate];
    /*--------------------------------------*/
    _t_emptyRate        = [UIUtil makeTextFieldDec:@"0.00" tgt:self];
    [_t_emptyRate   setTag:TTAG_EMPTY];
    [_t_emptyRate   setDelegate:(id)self];
    [_scrollView addSubview:_t_emptyRate];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"家賃下落率は毎年の潜在総収入(GPI)の下落率を設定します\n空室率はGPIに対する空室損を一定比率で見込みます\n"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _g_rentroll   = [[Graph alloc]init];
    [_scrollView addSubview:_g_rentroll];
    /****************************************/
    _g_vacant   = [[Graph alloc]init];
    [_scrollView addSubview:_g_vacant];
    /****************************************/
    _l_addEmptyLoss         = [UIUtil makeLabel:@"追加空室損"];
    [_l_addEmptyLoss setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_addEmptyLoss];
    /*--------------------------------------*/
    _l_addEmptyLossVal      = [UIUtil makeLabel:@"000"];
    [_l_addEmptyLossVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_addEmptyLossVal];
    /****************************************/
    _l_bootMonthVal = [UIUtil makeLabel:@"0ヶ月"];
    [_scrollView addSubview:_l_bootMonthVal];
    /*--------------------------------------*/
    _sl             = [[UISlider alloc]init];
    _sl.minimumValue = 0;  // 最小値を0に設定
    _sl.maximumValue = 12;  // 最大値を500に設定
    _sl.value = _bootMonth;  // 初期値を250に設定
    // 値が変更された時にhogeメソッドを呼び出す
    [_sl addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_sl];
    
    
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
    pos_x       = _pos.x_ini;
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
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:_pos.x_left   y:pos_y viewWidth:_pos.len30 viewHeight:dy*2 color:[UIUtil color_Ivory]];
        [UIUtil setLabel:_l_declineRate         x:pos_x         y:pos_y length:length];
        [UIUtil setLabel:_l_emptyRate           x:pos_x+dx      y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setTextField:_t_declineRate     x:pos_x         y:pos_y length:length];
        [UIUtil setTextField:_t_emptyRate       x:pos_x+dx      y:pos_y length:length];
        
        /****************************************/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*3);
        /****************************************/
        pos_y = pos_y + dy;
        [_g_rentroll      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*3.5)];
        [_g_rentroll setNeedsDisplay];
        pos_y = pos_y + dy*3;
        /****************************************/
        pos_y = pos_y + dy;
        [_g_vacant      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*3.5)];
        [_g_vacant setNeedsDisplay];
        pos_y = pos_y + dy*3;
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_addEmptyLoss        x:pos_x         y:pos_y length:length];
        [UIUtil setLabel:_l_addEmptyLossVal     x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_bootMonthVal    x:pos_x         y:pos_y length:length];
        [_sl setFrame:CGRectMake(       pos_x+dx, pos_y,length*2,dy)];
    }else {
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:_pos.x_left   y:pos_y viewWidth:_pos.len30 viewHeight:dy*2 color:[UIUtil color_Ivory]];
        [UIUtil setLabel:_l_declineRate         x:pos_x         y:pos_y length:length];
        [UIUtil setLabel:_l_emptyRate           x:pos_x+dx      y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setTextField:_t_declineRate     x:pos_x         y:pos_y length:length];
        [UIUtil setTextField:_t_emptyRate       x:pos_x+dx      y:pos_y length:length];
        /****************************************/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*3);
        /****************************************/
        pos_y = pos_y + dy;
        [_g_rentroll      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
        [_g_rentroll setNeedsDisplay];
        pos_y = pos_y + dy*4;
        /****************************************/
        pos_y = pos_y + dy;
        [_g_vacant      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*4.5)];
        [_g_vacant setNeedsDisplay];
        pos_y = pos_y + dy*4;
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_addEmptyLoss        x:pos_x         y:pos_y length:length];
        [UIUtil setLabel:_l_addEmptyLossVal     x:pos_x+dx*2    y:pos_y length:length];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_bootMonthVal    x:pos_x         y:pos_y length:length];
        [_sl setFrame:CGRectMake(       pos_x+dx, pos_y,length*2,dy)];
    }
    
    return;
}

//======================================================================
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    //    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
}

//======================================================================
// 回転時に処理したい内容
//======================================================================
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self viewMake];
    return;
}
//======================================================================
//
//======================================================================
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
    [self readTextFieldData];
}
//======================================================================
//
//======================================================================
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self readTextFieldData];
    return YES;
}

//======================================================================
//
//======================================================================
-(void) readTextFieldData
{
    /*--------------------------------------*/
    float tmp_declineRate;
    tmp_declineRate         = [_t_declineRate.text  floatValue]/100;
    if ( tmp_declineRate < 100 && tmp_declineRate >= 0 ){
        _declineRate        = tmp_declineRate;
    }
    /*--------------------------------------*/
    float tmp_emptyRate;
    tmp_emptyRate           = [_t_emptyRate.text    floatValue]/100;
    if ( tmp_emptyRate < 100 && tmp_emptyRate >= 0 ){
        _emptyRate          = tmp_emptyRate;
    }
    /*--------------------------------------*/
    [self rewriteProperty];
}

//======================================================================
// Viewが消える直前
//======================================================================
-(void) viewWillDisappear:(BOOL)animated
{
    if ( _b_cancel == false ){
        [self readTextFieldData];
        _modelRE.declineRate            = _declineRate;
        _modelRE.investment.emptyRate   = _emptyRate;
        _modelRE.investment.bootMonth   = _bootMonth;
        [_modelRE valToFile];
    }
    [super viewWillDisappear:animated];
}

//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    [self.navigationController popViewControllerAnimated:YES];
    return;
}
//======================================================================
//
//======================================================================
-(void)slider:(UISlider*)slider
{
    _bootMonth =  (NSInteger)(slider.value *6) / 6;
    [self rewriteProperty];
}

//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================

//======================================================================
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{
    _t_declineRate.text = [NSString stringWithFormat:@"%g",_declineRate*100];
    _t_emptyRate.text   = [NSString stringWithFormat:@"%g",_emptyRate*100];

    /****************************************/
    NSInteger rentRoll      = _modelRE.investment.gpi / _modelRE.estate.house.rooms / 12;
    NSInteger buildYear;
    if (_modelRE.estate.house.acquisitionTerm >= _modelRE.estate.house.buildTerm){
        buildYear = (_modelRE.estate.house.acquisitionTerm - _modelRE.estate.house.buildTerm) / 12;
    } else {
        buildYear = 0;
    }
    NSInteger buildYearEnd  = buildYear +_modelRE.holdingPeriodTerm/12;
    if (buildYearEnd - buildYear < 10 ){
        //原則、保有期間が短い場合にも10年分は表示する
        buildYearEnd = buildYear + 10;
    }
    NSArray *rentRollArr = [_modelRE getRentRollArray:rentRoll startYear:buildYear endYear:buildYearEnd declineRate:_declineRate];
    GraphData *gd_rentRoll = [[GraphData alloc]initWithData:rentRollArr];
    gd_rentRoll.precedent   = @"月額家賃@築年数";
    gd_rentRoll.type        = BAR_GPAPH;
    
    NSValue *val = rentRollArr[buildYearEnd-buildYear-1];
    CGPoint rentMin = [val CGPointValue];
    
    _g_rentroll.GraphDataAll = [[NSArray alloc]initWithObjects:gd_rentRoll,nil];
    [_g_rentroll setGraphtMinMax_xmin:buildYear-0.5
                                 ymin:((NSInteger)rentMin.y/5000)*5000
                                 xmax:buildYearEnd
                                 ymax:(rentRoll/1000 + 1)*1000];
    _g_rentroll.title         = @"家賃下落推移";
    [_g_rentroll setNeedsDisplay];
    /****************************************/
    NSInteger gpiMonth      = _modelRE.investment.gpi / _modelRE.estate.house.rooms;

    
    _l_addEmptyLossVal.text = [UIUtil yenValue:[self getAddEmptyLoss:gpiMonth emptyRate:_emptyRate bootMonth:_bootMonth]];
    _l_bootMonthVal.text    = [NSString stringWithFormat:@"%ldヶ月",_bootMonth];
    
    
    NSMutableArray *gpiArr = [NSMutableArray array];
    CGPoint tmpGpiPoint;
    for(int i=0; i<13; i++){
        tmpGpiPoint = CGPointMake(i,gpiMonth);
        [gpiArr addObject:[NSValue valueWithCGPoint:tmpGpiPoint]];
    }
    GraphData *gd_gpi   = [[GraphData alloc]initWithData:gpiArr];
    gd_gpi.precedent     = @"空室損";
    gd_gpi.type          = BAR_GPAPH;

    NSArray *vacantArr = [_modelRE getVacantArray:gpiMonth emptyRate:_emptyRate bootMonth:_bootMonth ];
    GraphData *gd_vacant = [[GraphData alloc]initWithData:vacantArr];
    gd_vacant.precedent   = @"実効収入";
    gd_vacant.type        = BAR_GPAPH;
    
#if 0
    NSValue *val = rentRollArr[buildYearEnd-buildYear-1];
    CGPoint rentMin = [val CGPointValue];
#endif
    _g_vacant.GraphDataAll = [[NSArray alloc]initWithObjects:gd_gpi,gd_vacant,nil];
    [_g_vacant setGraphtMinMax_xmin:-0.5
                               ymin:0
                               xmax:13
                               ymax:gpiMonth];
    _g_vacant.title         = @"入居設定推移";
    [_g_vacant setNeedsDisplay];
    return;
}
//======================================================================
- (NSInteger) getAddEmptyLoss:(NSInteger)gpiMonth emptyRate:(CGFloat)emptyRate bootMonth:(NSInteger)bootMonth
{
    NSInteger emptyLoss = 0;
    NSInteger egi = (CGFloat)gpiMonth*( 1- emptyRate);
    NSInteger tmpEgi;
    
    for(int i=0; i<7; i++){
        //レントロール
        if ( bootMonth != 0 && i <= bootMonth ){
            tmpEgi = egi * i  / bootMonth;
        } else {
            tmpEgi = egi;
        }
        emptyLoss = emptyLoss + egi - tmpEgi;
    }
    
    return emptyLoss;
}

//======================================================================
@end
//======================================================================
