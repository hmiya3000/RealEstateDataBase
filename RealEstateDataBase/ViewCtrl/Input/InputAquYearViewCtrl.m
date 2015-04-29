//
//  InputAquYearViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/03/29.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "InputAquYearViewCtrl.h"

@interface InputAquYearViewCtrl ()
{
    UILabel         *_l_aquYear;
    UITextView      *_tv_tips;
    UIPickerView    *_pv;
    NSInteger       _selectIdx;
    NSInteger       _thisYear;
}
@end

@implementation InputAquYearViewCtrl
/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"取得年";
    
    /****************************************/
    _thisYear = [UIUtil getThisYear];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_aquYear        = [UIUtil makeLabel:[self getYearStr:_modelRE.yearAquisition]];
    [_scrollView addSubview:_l_aquYear];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = @"築10年を越えると大規模修繕が必要な場合があります";
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _pv   = [[UIPickerView alloc]init];
    [_pv setBackgroundColor:[UIColor whiteColor]];
    [_pv setDelegate:self];
    [_pv setDataSource:self];
    [_pv setShowsSelectionIndicator:YES];
    _selectIdx = _thisYear - _modelRE.yearAquisition +10;
    [_pv selectRow:_selectIdx inComponent:0 animated:NO];
    [_scrollView addSubview:_pv];
    
    
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
        [UIUtil setRectLabel:_l_aquYear   x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
        [_pv setFrame:CGRectMake(_pos.x_left,   _pos.y_btm - 300, _pos.len30, 216)];
    } else {
        [UIUtil setRectLabel:_l_aquYear   x:pos_x y:pos_y viewWidth:_pos.len15 viewHeight:dy color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*2);
        [_pv setFrame:CGRectMake(_pos.x_center, _pos.y_btm - 250, _pos.len15, 216)];
    }
    /****************************************/
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
    _modelRE.yearAquisition = _thisYear - _selectIdx +10;
    [_modelRE valToFile];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (NSString*) getYearStr:(NSInteger)year
{
    return [NSString stringWithFormat:@"%4d年/%@",
            (int)(year),
            [UIUtil getJpnYear:year]];
}
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************
 * 列数設定
 ****************************************************************/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
/****************************************************************
 *　行数設定
 ****************************************************************/
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 50;
}
/****************************************************************
 * 表示する内容を返す
 ****************************************************************/
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getYearStr:_thisYear - row+10];
}
/****************************************************************
 *　行数の高さ指定
 ****************************************************************/
-(CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
/****************************************************************
 *　行数取得：継承先でオーバーライド
 ****************************************************************/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIdx             = row;
    _l_aquYear.text = [self getYearStr:_thisYear - row+10];
    return;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
