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
    
    _value  = _modelRE.priceSales /10000;
    _uicalc = [[UICalc alloc]initWithValue:_value];
    _uicalc.delegate = self;
    
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_price        = [UIUtil makeLabel:[NSString stringWithFormat:@"%d 万円",(int)_modelRE.priceSales/10000]];
    [_scrollView addSubview:_l_price];
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
    _tv_tips.text           = @"売却時NOIをもとにキャップレートを設定して売却価格を決定します";
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
    [super viewDidAppear:animated];
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
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
    }else {
        [UIUtil setRectLabel:_l_price       x:pos_x     y:pos_y viewWidth:_pos.len15 viewHeight:dy  color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*2);
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
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    _modelRE.priceSales = _value*10000;
    [_modelRE valToFile];
    
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
    _l_price.text                   = [NSString stringWithFormat:@"%d 万円",(int)_value];
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