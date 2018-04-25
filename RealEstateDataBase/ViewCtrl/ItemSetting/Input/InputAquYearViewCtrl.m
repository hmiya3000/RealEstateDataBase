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
    NSInteger           _selectIdxYear;
    NSInteger           _selectIdxMonth;
    NSInteger       _thisYear;
}
@end

@implementation InputAquYearViewCtrl
#define ROW_YEAR    25
//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"取得年";
    
    /****************************************/
    _thisYear = [UIUtil getThisYear];
    NSInteger acquYear  = [UIUtil getYear_term:_modelRE.estate.house.acquisitionTerm];
    NSInteger acquMonth = [UIUtil getMonth_term:_modelRE.estate.house.acquisitionTerm];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_aquYear        = [UIUtil makeLabel:[self getAcquStr_year:acquYear month:acquMonth]];
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
    _selectIdxYear      = acquYear- _thisYear + ROW_YEAR -3;
    _selectIdxMonth     = acquMonth -1;
    [_pv selectRow:_selectIdxYear   inComponent:0 animated:NO];
    [_pv selectRow:_selectIdxMonth  inComponent:1 animated:NO];
    [_scrollView addSubview:_pv];
    
    
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
        [_pv setFrame:CGRectMake(_pos.x_center, pos_y, _pos.len30/2, 300)];
    }
    /****************************************/
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
// Viewが消える直前
//======================================================================
-(void) viewWillDisappear:(BOOL)animated
{
    if ( _b_cancel == false ){
        NSInteger acquYear  = _selectIdxYear + _thisYear - ROW_YEAR +3;
        NSInteger acquMonth = _selectIdxMonth +1;
        _modelRE.estate.house.acquisitionTerm = [UIUtil getTerm_year:acquYear month:acquMonth];
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
-(NSString*) getYearStr:(NSInteger)year
{
    return [NSString stringWithFormat:@"%4d年/%@",
            (int)(year),
            [UIUtil getJpnYear:year]];
}
//======================================================================
//
//======================================================================
-(NSString*) getAcquStr_year:(NSInteger)year month:(NSInteger)month
{
    return [NSString stringWithFormat:@"%4d年(%@)%ld月",
            (int)(year),
            [UIUtil getJpnYear:year],
            month];
}
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
// 列数設定
//======================================================================
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}
//======================================================================
// 行数設定
//======================================================================
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ( component == 0 ){
        return ROW_YEAR;
    } else {
        return 12;
    }
}
//======================================================================
// 表示する内容を返す
//======================================================================
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ( component == 0 ){
        return [self getYearStr:(row + _thisYear - ROW_YEAR+3)];
    } else {
        return [NSString stringWithFormat:@"%2ld月",row+1];
    }

}
//======================================================================
// 行数の高さ指定
//======================================================================
-(CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
//======================================================================
// 列の幅指定
//======================================================================
-(CGFloat)pickerView:(UIPickerView*)pickerView widthForComponent:(NSInteger)component
{
    if ( _pos.isPortrait == true ){
        if ( component == 0 ){
            return _pos.len30 * 0.7;
        } else {
            return _pos.len30 * 0.3;
        }
    } else {
        if ( component == 0 ){
            return _pos.len30/2 * 0.7;
        } else {
            return _pos.len30/2 * 0.3;
        }
    }
}

//======================================================================
// 行数取得：継承先でオーバーライド
//======================================================================
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ( component == 0 ){
        _selectIdxYear          = row;
    } else {
        _selectIdxMonth         = row;
    };
    _l_aquYear.text = [self getAcquStr_year:(_selectIdxYear + _thisYear - ROW_YEAR+3) month:_selectIdxMonth+1];
    return;
}
//======================================================================
@end
//======================================================================
