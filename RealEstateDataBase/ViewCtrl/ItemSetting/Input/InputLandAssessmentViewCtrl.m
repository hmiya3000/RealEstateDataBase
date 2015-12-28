//
//  InputLandAssessmentViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/27.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputLandAssessmentViewCtrl.h"

@interface InputLandAssessmentViewCtrl ()
{
    NSInteger               _value;
    
    UILabel                 *_l_bg;
    UITextField             *_t_lAssess;
    UILabel                 *_l_lAssess;
    UILabel                 *_l_address;
    UITextView              *_tv_tips;
    
    UIWebView               *_wv;

    
}
@end

@implementation InputLandAssessmentViewCtrl


#define TTAG_LASSESS          1

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"路線価";
    
    _value          = _modelRE.estate.land.assessment;
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_bg           = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_bg];
    /****************************************/
    _t_lAssess        = [UIUtil makeTextFieldDec:@"99" tgt:self];
    [_t_lAssess       setTag:TTAG_LASSESS];
    [_t_lAssess       setDelegate:(id)self];
    [_scrollView addSubview:_t_lAssess];
    /*--------------------------------------*/
    _l_lAssess        = [UIUtil makeLabel:@"千円/㎡"];
    [_scrollView addSubview:_l_lAssess];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"路線価は積算評価の計算に使われます"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _l_address                = [UIUtil makeLabel:_modelRE.estate.land.address];
    [_l_address setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_address];
    /****************************************/
    _wv = [[UIWebView alloc] init];
    _wv.delegate = self;
    _wv.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:@"http://www.rosenka.nta.go.jp/main_h27/index.htm"];

    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [_wv loadRequest:req];
    [_scrollView addSubview:_wv];
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
#if 0
    CGRect rect = CGRectMake(_pos.frame.origin.x,
                      _pos.frame.origin.y,
                      _pos.frame.size.width,
                      _pos.frame.size.height);
    _scrollView = [UIUtil makeScrollView:rect xpage:2 ypage:1 tgt:self];
    _scrollView.pagingEnabled = YES;
#endif
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0.2*dy;
    if ( _pos.isPortrait == true ){
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:pos_x         y:pos_y         viewWidth:_pos.len30 viewHeight:dy*1.05 color:[UIUtil color_Ivory]];
        [UIUtil setTextField:_t_lAssess         x:pos_x+0.1*dx  y:pos_y+dy*0.1  length:_pos.len15];
        [UIUtil setLabel:_l_lAssess             x:pos_x+2*dx    y:pos_y+dy*0.1  length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy);
        
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_address             x:pos_x         y:pos_y length:_pos.len30];
        /****************************************/
        pos_y = pos_y + dy;
//        pos_x   = pos_x + _pos.x_page;
//        CGFloat webHeight = 11;
        _wv.frame = CGRectMake(pos_x, pos_y, _pos.len30, _pos.frame.size.height - pos_y);


    }else {
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:pos_x         y:pos_y         viewWidth:_pos.len15 viewHeight:dy*1.05 color:[UIUtil color_Ivory]];
        [UIUtil setTextField:_t_lAssess         x:pos_x+0.1*dx  y:pos_y+dy*0.1  length:_pos.len15/2];
        [UIUtil setLabel:_l_lAssess             x:pos_x+dx      y:pos_y+dy*0.1  length:_pos.len10/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*2);
        
        /****************************************/
        pos_y = 0.2*dy;
        [UIUtil setLabel:_l_address             x:_pos.x_center         y:pos_y length:_pos.len30];
        /****************************************/
        pos_y = pos_y + dy;
//        pos_x   = pos_x + _pos.x_page;
//        CGFloat webHeight = 11;
        _wv.frame = CGRectMake(pos_x, pos_y, _pos.len30, _pos.frame.size.height - pos_y);
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
        _modelRE.estate.land.assessment = _value;
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
/****************************************************************
 *
 ****************************************************************/
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
    [self readTextFieldData];
}

/****************************************************************
 *
 ****************************************************************/
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self readTextFieldData];
    return YES;
}

/****************************************************************
 *
 ****************************************************************/
-(void) readTextFieldData
{
    /*--------------------------------------*/
    NSInteger tmp_value;
    tmp_value    = [_t_lAssess.text integerValue];
    if ( tmp_value <= 100000 && tmp_value > 0 ){
        _value  = tmp_value;
    }
    /*--------------------------------------*/
    [self rewriteProperty];
}
/****************************************************************
 *
 ****************************************************************/
-(void)rewriteProperty
{
    _t_lAssess.text     = [NSString stringWithFormat:@"%ld", (long)_value];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
