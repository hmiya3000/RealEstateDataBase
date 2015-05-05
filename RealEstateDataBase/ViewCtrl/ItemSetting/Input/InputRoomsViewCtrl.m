//
//  InputRoomsViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/26.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputRoomsViewCtrl.h"

@interface InputRoomsViewCtrl ()
{
    NSInteger           _value;

    UILabel             *_l_bg;
    UITextField         *_t_rooms;
    UILabel             *_l_rooms;
    UITextView          *_tv_tips;
    
    UILabel             *_l_area;
    UILabel             *_l_areaVal;
    UILabel             *_l_price;
    UILabel             *_l_priceVal;
    UILabel             *_l_income;
    UILabel             *_l_incomeVal;
}

@end

@implementation InputRoomsViewCtrl


#define TTAG_ROOMS          1

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"戸数";
    
    _value          = _modelRE.estate.house.rooms;
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_bg           = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_bg];
    /****************************************/
    _t_rooms        = [UIUtil makeTextFieldDec:@"99" tgt:self];
    [_t_rooms       setTag:TTAG_ROOMS];
    [_t_rooms       setDelegate:(id)self];
    [_scrollView addSubview:_t_rooms];
    /*--------------------------------------*/
    _l_rooms        = [UIUtil makeLabel:@"戸"];
    [_scrollView addSubview:_l_rooms];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"一戸あたりの価格・面積・賃料を計算します"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _l_price                = [UIUtil makeLabel:@"価格/戸"];
    [_l_price setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_price];
    /*--------------------------------------*/
    _l_priceVal             = [UIUtil makeLabel:@"9999.9万円"];
    [_l_priceVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_priceVal];
    /****************************************/
    _l_area                 = [UIUtil makeLabel:@"床面積/戸"];
    [_l_area setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_area];
    /*--------------------------------------*/
    _l_areaVal              = [UIUtil makeLabel:@"99.9㎡"];
    [_l_areaVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_areaVal];
    /****************************************/
    _l_income               = [UIUtil makeLabel:@"月賃料/戸"];
    [_l_income setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_income];
    /*--------------------------------------*/
    _l_incomeVal            = [UIUtil makeLabel:@"99.9万円"];
    [_l_incomeVal setTextAlignment:NSTextAlignmentRight];
    [_scrollView addSubview:_l_incomeVal];
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
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:pos_x         y:pos_y         viewWidth:_pos.len30 viewHeight:dy*1.05 color:[UIUtil color_Ivory]];
        [UIUtil setTextField:_t_rooms           x:pos_x+0.1*dx  y:pos_y+dy*0.1  length:_pos.len15];
        [UIUtil setLabel:_l_rooms               x:pos_x+2*dx    y:pos_y+dy*0.1  length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);

        /****************************************/
        pos_y = pos_y + dy*2;
        [UIUtil setLabel:_l_price               x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_priceVal            x:pos_x+1.5*dx  y:pos_y length:_pos.len15];
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_area                x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_areaVal             x:pos_x+1.5*dx  y:pos_y length:_pos.len15];
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_income              x:pos_x         y:pos_y length:_pos.len15];
        [UIUtil setLabel:_l_incomeVal           x:pos_x+1.5*dx  y:pos_y length:_pos.len15];
        
    }else {
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:pos_x         y:pos_y         viewWidth:_pos.len15 viewHeight:dy*1.05 color:[UIUtil color_Ivory]];
        [UIUtil setTextField:_t_rooms           x:pos_x+0.1*dx  y:pos_y+dy*0.1  length:_pos.len15/2];
        [UIUtil setLabel:_l_rooms               x:pos_x+dx      y:pos_y+dy*0.1  length:_pos.len10/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*2);

        /****************************************/
        pos_y = 0.2*dy;
        [UIUtil setLabel:_l_price               x:_pos.x_center         y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_priceVal            x:_pos.x_center+0.5*dx  y:pos_y length:_pos.len15/2];
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_area                x:_pos.x_center         y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_areaVal             x:_pos.x_center+0.5*dx  y:pos_y length:_pos.len15/2];
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_income              x:_pos.x_center         y:pos_y length:_pos.len15/2];
        [UIUtil setLabel:_l_incomeVal           x:_pos.x_center+0.5*dx  y:pos_y length:_pos.len15/2];

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
    if (sender.tag == 1){
        
    } else {
        _modelRE.estate.house.rooms = _value;
        [_modelRE valToFile];

        [self.navigationController popViewControllerAnimated:YES];
    }
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
    tmp_value   = [_t_rooms.text integerValue];
    if ( tmp_value <= 100 && tmp_value > 0 ){
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
    _t_rooms.text       = [NSString stringWithFormat:@"%ld",(long) _value];
    _l_priceVal.text    = [NSString stringWithFormat:@"%4.1f万円",(float)_modelRE.estate.prices.price/_value/10000];
    _l_areaVal.text     = [NSString stringWithFormat:@"%2.1f㎡",(float)_modelRE.estate.house.area/_value];
    _l_incomeVal.text   = [NSString stringWithFormat:@"%2.1f万円",(float)_modelRE.estate.prices.gpi/_value/12/10000];
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
