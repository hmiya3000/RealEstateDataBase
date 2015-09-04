//
//  InputInterestViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/22.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputInterestViewCtrl.h"

@interface InputInterestViewCtrl ()
{
    UILabel         *_l_gpi;
    UITextView      *_tv_tips;
    UIView          *_uv;
    NSInteger       _value;
    
    UILabel         *_l_price;
    UILabel         *_l_priceVal;
    UILabel         *_l_interest;
    UILabel         *_l_interestVal;
    UILabel         *_l_workArea;
    
    UICalc          *_uicalc;
}
@end

@implementation InputInterestViewCtrl


/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"潜在総収入";
    
    _value  = _modelRE.estate.prices.gpi/10000;
    _uicalc = [[UICalc alloc]initWithValue:_value];
    _uicalc.delegate = self;
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_gpi     = [UIUtil makeLabel:[NSString stringWithFormat:@"%@円",[UIUtil yenValue:_value]]];
    [_scrollView addSubview:_l_gpi];
    /****************************************/
    _l_price        = [UIUtil makeLabel:@"物件価格"];
    [_l_price setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_price];
    /****************************************/
    _l_priceVal     = [UIUtil makeLabel:@"9999万円"];
    [_l_priceVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceVal];
    /****************************************/
    _l_interest         = [UIUtil makeLabel:@"表面利回り"];
    [_l_interest setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_interest];
    /****************************************/
    _l_interestVal      = [UIUtil makeLabel:@"9.99%%"];
    [_l_interestVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_interestVal];
    /****************************************/
    _l_workArea     = [UIUtil makeLabel:@"100"];
    [_l_workArea setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_workArea];
    [self updateArea:_uicalc.inputArea work:_uicalc.workArea];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"年間の家賃収入(潜在総収入)から表面利回りを算出します\n諸費用等を加味した実質利回りはこれより下がります"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _uv  = [[UIView alloc]init];
    [_uicalc uvinit:_scrollView];
    [_scrollView addSubview:_uv];
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
    [super viewWillAppear:animated];
    [self viewMake];
    [self enterIn:_value];
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
        [UIUtil setRectLabel:_l_gpi     x:pos_x     y:pos_y viewWidth:_pos.len30 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price       x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_priceVal    x:pos_x+dx*2    y:pos_y length:_pos.len10];
        pos_y = pos_y + dy*0.65;
        [UIUtil setLabel:_l_interest    x:pos_x         y:pos_y length:_pos.len10];
        [UIUtil setLabel:_l_interestVal x:pos_x+dx*2    y:pos_y length:_pos.len10];
        pos_y = pos_y + dy*0.6;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*1.7);
    }else {
        [UIUtil setRectLabel:_l_gpi     x:pos_x     y:pos_y viewWidth:_pos.len15 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_price       x:pos_x         y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_priceVal    x:pos_x+dx*0.75 y:pos_y length:_pos.len15/2];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_interest    x:pos_x         y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_interestVal x:pos_x+dx*0.75 y:pos_y length:_pos.len15/2];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*1.5);
    }
    
    if ( _pos.isPortrait == true ){
        pos_y = _pos.y_btm - dy -dy - _pos.y_page/2;
        [UIUtil setRectLabel:_l_workArea    x:pos_x     y:pos_y viewWidth:_pos.len30 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [_uicalc setuv:CGRectMake(pos_x, pos_y, _pos.len30, _pos.y_page/2)];
        
    }else {
        pos_y = 0;
        [UIUtil setRectLabel:_l_workArea    x:_pos.x_center     y:pos_y viewWidth:_pos.len15 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [_uicalc setuv:CGRectMake(_pos.x_center, pos_y, _pos.len15, _pos.y_page/1.5)];
    }
    
    return;
}

/****************************************************************
 * ビューがタップされたとき
 ****************************************************************/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    //    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
}

/****************************************************************
 * 回転時に処理したい内容
 ****************************************************************/
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self viewMake];
    return;
}

/****************************************************************
 * Viewが消える直前
 ****************************************************************/
-(void) viewWillDisappear:(BOOL)animated
{
    if ( _b_cancel == false ){
        _modelRE.estate.prices.gpi      = _value*10000;
        _modelRE.investment.prices.gpi  = _value*10000;
        [_modelRE valToFile];
    }
    [super viewWillDisappear:animated];
}

/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/

/****************************************************************
 *
 ****************************************************************/
- (void) updateArea:(NSString*)inputArea work:(NSString *)workArea
{
    _l_workArea.text    = [NSString stringWithFormat:@"%@", workArea ];
}
/****************************************************************
 *
 ****************************************************************/
- (void) enterIn:(CGFloat)value
{
    _value              = value;
    _l_gpi.text         = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_value]];
    _l_priceVal.text    = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_modelRE.estate.prices.price/10000]];
    _l_interestVal.text = [NSString stringWithFormat:@"%2.2f%%",(float)_value*10000/_modelRE.estate.prices.price*100 ];

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
