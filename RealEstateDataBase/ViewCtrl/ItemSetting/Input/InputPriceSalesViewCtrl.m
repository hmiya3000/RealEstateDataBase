//
//  InputPriceSalesViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputPriceSalesViewCtrl.h"

@interface InputPriceSalesViewCtrl ()
{
    UILabel         *_l_price;
    UILabel         *_l_noiLast;
    UILabel         *_l_noiLastVal;
    UILabel         *_l_capLast;
    UILabel         *_l_capLastVal;
    UITextView      *_tv_tips;
    NSInteger       _value;
    
    UILabel         *_l_workArea;
    UICalc          *_uicalc;
}
@end

@implementation InputPriceSalesViewCtrl


/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"売却価格";
    
    _value  = _modelRE.sale.price /10000;
    _uicalc = [[UICalc alloc]initWithValue:_value];
    _uicalc.delegate = self;
    [_modelRE calcAll];
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_price        = [UIUtil makeLabel:[NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_value]]];
    [_scrollView addSubview:_l_price];
    /****************************************/
    _l_noiLast      = [UIUtil makeLabel:[NSString stringWithFormat:@"%d年目NOI",(int)_modelRE.holdingPeriod]];
    [_l_noiLast setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_noiLast];
    /****************************************/
    _l_noiLastVal   = [UIUtil makeLabel:[NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_modelRE.opeLast.noi /10000]]];
    [_l_noiLastVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_noiLastVal];
    /****************************************/
    _l_capLast      = [UIUtil makeLabel:@"売却時キャプレート"];
    [_l_capLast setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_capLast];
    /****************************************/
    _l_capLastVal   = [UIUtil makeLabel:[NSString stringWithFormat:@"%2.2f%%",((CGFloat)_modelRE.opeLast.noi/_value/10000 *100)]];
    [_l_capLastVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_capLastVal];
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
    _tv_tips.text           = @"売却価格 = 売却時NOI / キャップレート \nで設定します";
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    [_uicalc uvinit:_scrollView];
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
        [UIUtil setRectLabel:_l_price       x:pos_x     y:pos_y viewWidth:_pos.len30 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_noiLast           x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_noiLastVal        x:pos_x+dx*2    y:pos_y length:_pos.len10];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_capLast           x:pos_x         y:pos_y length:_pos.len10*2];
        [UIUtil setLabel:_l_capLastVal        x:pos_x+dx*2    y:pos_y length:_pos.len10];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*1.5);
        
    }else {
        [UIUtil setRectLabel:_l_price       x:pos_x         y:pos_y viewWidth:_pos.len15 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_noiLast         x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_noiLastVal      x:pos_x+dx*0.75 y:pos_y length:_pos.len15/2];
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_capLast         x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_capLastVal      x:pos_x+dx*0.75 y:pos_y length:_pos.len15/2];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*2);
    }
    
    /****************************************/
    if ( _pos.isPortrait == true ){
        pos_y = _pos.y_page/2-2*dy;
        [UIUtil setRectLabel:_l_workArea    x:pos_x     y:pos_y viewWidth:_pos.len30 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [_uicalc setuv:CGRectMake(pos_x, pos_y, _pos.len30, _pos.y_page/2+dy)];
    }else {
        pos_y = 0;
        [UIUtil setRectLabel:_l_workArea    x:_pos.x_center     y:pos_y viewWidth:_pos.len30/2 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        [_uicalc setuv:CGRectMake(_pos.x_center, pos_y, _pos.len30/2, _pos.y_page-dy)];
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
        _modelRE.sale.price     = _value*10000;
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
    _l_price.text       = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_value]];
    _l_capLastVal.text  = [NSString stringWithFormat:@"%2.2f%%",((CGFloat)_modelRE.opeLast.noi/_value/10000 *100)];

}
/****************************************************************/
@end
/****************************************************************/

