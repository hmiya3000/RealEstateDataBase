//
//  PaymentViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2017/04/23.
//  Copyright © 2017年 Beetre. All rights reserved.
//

#import "PaymentViewCtrl.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "Pos.h"
#import "Graph.h"
#import "GraphData.h"

@interface PaymentViewCtrl ()

@end

@implementation PaymentViewCtrl
{
    ModelRE                 *_modelRE;
    UIScrollView            *_scrollView;
    Pos                     *_pos;
    UILabel                 *_l_name;

    UITextView              *_tv_calc;
    UISlider                *_sl_term;

    Graph                   *_g_loan;
    UIButton                *_b_close;
    NSInteger               _target_term;

}
//======================================================================
#define BTAG_CLOSE     1
//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"融資(残高推移)";
        self.tabBarItem.image = [UIImage imageNamed:@"graph.png"];
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
    /****************************************/
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        UIBarButtonItem *retButton =
        [[UIBarButtonItem alloc] initWithTitle:@"物件リスト"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(retButtonTapped:)];
        self.navigationItem.leftBarButtonItem = retButton;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_name         = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_name];
    /****************************************/
    _g_loan   = [[Graph alloc]init];
    [_scrollView addSubview:_g_loan];
    /****************************************/
    /*--------------------------------------*/
    UIFont* font= [UIFont fontWithName:@"Courier" size:[UIFont smallSystemFontSize]];
    /*--------------------------------------*/
    _tv_calc         = [UIUtil makeTextView_x:0 y:0 width:0 height:0];
    [_tv_calc setFont:font];
    [_tv_calc setEditable:NO];
    [_tv_calc setText:[self getStringLoan]];
    [_scrollView addSubview:_tv_calc];
    /*--------------------------------------*/
    [_tv_calc       setText:[self getStringLoan]];
    /****************************************/
    _sl_term                        = [[UISlider alloc]init];
    _sl_term.minimumValue = 0;      // 最小値を0に設定
    _sl_term.maximumValue = 1;  // 最大値を600に設定
    _sl_term.value = 0;             // 初期値を0に設定
    _target_term = 0;
    // 値が変更された時にhogeメソッドを呼び出す
    [_sl_term addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_sl_term];
    /****************************************/
    _b_close  = [UIUtil makeButton:@"戻る" tag:BTAG_CLOSE];
    [_b_close addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_close];
    
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
-(void)viewMake
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
#if 1
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        if ( _pos.isPortrait == true ){
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*0.5);
        } else {
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*1);
        }
        _scrollView.bounces = YES;
    } else {
    }
#endif
    /****************************************/
    pos_y = 0.2*dy;
    [UIUtil setRectLabel:_l_name x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_WakatakeIro]];
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [_g_loan      setFrame:CGRectMake(_pos.x_left, pos_y, _pos.len30, dy*3.5)];
    [_g_loan setNeedsDisplay];
    pos_y = pos_y + dy*1.5;
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    CGFloat heightTitle = 1.4 * dy;
    [_tv_calc       setFrame:CGRectMake(pos_x, pos_y+heightTitle, length30, 5*dy - heightTitle)];
    pos_y = pos_y + 4*dy;
    /*--------------------------------------*/
    pos_y = pos_y + dy;
    [_sl_term setFrame:CGRectMake(       pos_x, pos_y,length30,dy)];
    /*--------------------------------------*/
    pos_y   =  _pos.frame.size.height - dy*5.5;
    [UIUtil setButton:_b_close x:pos_x y:pos_y length:length30];
    /*--------------------------------------*/
}

//======================================================================
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{
    NSInteger year  = [UIUtil getYear_term:_modelRE.investment.loan.periodTerm];
    NSInteger month = [UIUtil getMonth_term:_modelRE.investment.loan.periodTerm-1];
    if (month == 12 ){
        _l_name.text            = [NSString stringWithFormat:@"%g万円 %2.2f%% %ld年",
                                   _modelRE.investment.loan.loanBorrow/10000.0,
                                   _modelRE.investment.loan.rateYear*100,
                                   year];
    } else {
        _l_name.text            = [NSString stringWithFormat:@"%g万円 %2.2f%% %ld年%ldヶ月",
                                   _modelRE.investment.loan.loanBorrow/10000.0,
                                   _modelRE.investment.loan.rateYear*100,
                                   year,
                                   month];
    }
    NSValue *valNow = [NSValue valueWithCGPoint:CGPointMake( _target_term/12.0+1,_modelRE.investment.loan.loanBorrow )];
    NSValue *val0   = [NSValue valueWithCGPoint:CGPointMake( _target_term/12.0+1,0)];
    NSArray *arr_now = @[val0,valNow];
    GraphData *gd_now = [[GraphData alloc]initWithData:arr_now];
    gd_now.precedent   = @"Now";
    gd_now.type        = LINE_GRAPH;
    NSArray *arr_loan    = [_modelRE.investment.loan getLbArrayTerm];
    GraphData *gd_loan = [[GraphData alloc]initWithData:arr_loan];
    gd_loan.precedent   = @"借入残高";
    gd_loan.type        = LINE_GRAPH;
    [_g_loan setGraphtMinMax_xmin:1 ymin:0 xmax:_modelRE.investment.loan.periodTerm/12.0+1 ymax:_modelRE.investment.loan.loanBorrow];
    
    _g_loan.GraphDataAll  = [[NSArray alloc]initWithObjects:gd_now,gd_loan,nil];
    [_g_loan setNeedsDisplay];

    [_tv_calc setText:[self getStringLoan]];
}
//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_CLOSE){
        [self.navigationController popViewControllerAnimated:YES];
    }
    return;
}
//======================================================================
//
//======================================================================
-(void)slider:(UISlider*)slider
{
    // ここに何かの処理を記述する
    // （引数の slider には呼び出し元のUISliderオブジェクトが引き渡されてきます）
    _target_term = (NSInteger)(slider.value * _modelRE.investment.loan.periodTerm);
    [self rewriteProperty];
}

//======================================================================
//
//======================================================================
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//======================================================================
//
//======================================================================
-(NSString*) getStringLoan
{
    NSInteger year,month,pmt,ipmt,ppmt,bal,year_term;
    NSMutableString* str;
    str = [[NSMutableString alloc]init];
    
    NSInteger startYear = [UIUtil getYear_term:_modelRE.estate.house.acquisitionTerm];
    
    bal = 0;
    NSInteger term;
    if ( _target_term > _modelRE.investment.loan.periodTerm -5 ){
        term = _modelRE.investment.loan.periodTerm -5;
    } else {
        term = _target_term;
    }
    if ( _modelRE.investment.loan.levelPayment == true ){
        [str appendString:[NSString stringWithFormat:@"  返済    %@\n年月(回目)      元金        利息       残高\n",
                                                [UIUtil yenValue:[_modelRE.investment.loan getPmt:1]]]];
    }else {
        [str appendString:[NSString stringWithFormat:@"  元金    %@\n年月(回目)      返済        利息       残高\n",
                [UIUtil yenValue:[_modelRE.investment.loan getPpmt:1]]]];
    }
    //    CGFloat rate;
    year        = [UIUtil getYear_term:_modelRE.estate.house.acquisitionTerm+term];  //取得した次の月から返済
    year_term   = year - startYear+1;
    [str appendString:[NSString stringWithFormat:@"%4d年 (%d年目)\n",(int)year,(int)year_term]];
    for ( NSInteger i=0; i<6; i++){
        month       = [UIUtil getMonth_term:_modelRE.estate.house.acquisitionTerm+term+i]; //取得した次の月から返済
        pmt         = [_modelRE.investment.loan getPmt:term+i];
        ppmt        = [_modelRE.investment.loan getPpmt:term+i];
        ipmt        = [_modelRE.investment.loan getIpmt:term+i];
        bal         = [_modelRE.investment.loan getLb:term+i];
        [str appendString:[NSString stringWithFormat:@" %2d(%3ld) ",(int)month,(long)(term+i)]];
        if ( _modelRE.investment.loan.levelPayment == true ){
            [str appendString:[UIUtil fixString:[UIUtil yenValue:ppmt] length:11]];
        } else {
            [str appendString:[UIUtil fixString:[UIUtil yenValue:pmt] length:11]];
        }
        [str appendString:[UIUtil fixString:[UIUtil yenValue:ipmt] length:11]];
        [str appendString:[UIUtil fixString:[UIUtil yenValue:bal] length:13]];
        [str appendString:[NSString stringWithFormat:@"\n"]];
    }
    return str;
}
//======================================================================
//
//======================================================================
-(NSString*) getStringLoanTitle
{
    if ( _modelRE.investment.loan.levelPayment == true ){
        return [NSString stringWithFormat:@"  返済    %@\n年月(回目)      元金        利息       残高\n",
                [UIUtil yenValue:[_modelRE.investment.loan getPmt:1]]];
    }else {
        return [NSString stringWithFormat:@"  元金    %@\n年月(回目)      返済        利息       残高\n",
                [UIUtil yenValue:[_modelRE.investment.loan getPpmt:1]]];
    }
}
//======================================================================
//
//======================================================================
-(NSString*) getStringLoan2
{
    //    CGFloat rate;
    NSInteger year,month,pmt,ipmt,ppmt,bal,year_term;
    NSMutableString* str;
    str = [[NSMutableString alloc]init];
    
    NSInteger startYear = [UIUtil getYear_term:_modelRE.estate.house.acquisitionTerm];
    
    bal = 0;
    for( NSInteger term=0; term <= _modelRE.investment.loan.periodTerm; term++){
        month       = [UIUtil getMonth_term:_modelRE.estate.house.acquisitionTerm+term]; //取得した次の月から返済
        year        = [UIUtil getYear_term:_modelRE.estate.house.acquisitionTerm+term];  //取得した次の月から返済
        year_term   = year - startYear+1;
        pmt         = [_modelRE.investment.loan getPmt:term];
        ppmt        = [_modelRE.investment.loan getPpmt:term];
        ipmt        = [_modelRE.investment.loan getIpmt:term];
        bal         = [_modelRE.investment.loan getLb:term];
        if ( term==0 || month == 1 ){
            [str appendString:[NSString stringWithFormat:@"%4d年 (%d年目)\n",(int)year,(int)year_term]];
        }
        [str appendString:[NSString stringWithFormat:@" %2d(%3d) ",(int)month,(int)term]];
        if ( _modelRE.investment.loan.levelPayment == true ){
            [str appendString:[UIUtil fixString:[UIUtil yenValue:ppmt] length:11]];
        } else {
            [str appendString:[UIUtil fixString:[UIUtil yenValue:pmt] length:11]];
        }
        [str appendString:[UIUtil fixString:[UIUtil yenValue:ipmt] length:11]];
        [str appendString:[UIUtil fixString:[UIUtil yenValue:bal] length:13]];
        [str appendString:[NSString stringWithFormat:@"\n"]];
    }
    return str;
}


//======================================================================
@end
//======================================================================
