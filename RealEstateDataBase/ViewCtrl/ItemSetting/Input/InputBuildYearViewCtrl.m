//
//  InputBuildYearViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/15.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputBuildYearViewCtrl.h"

@interface InputBuildYearViewCtrl ()
{
    UILabel             *_l_buildYear;
    UITextView          *_tv_tips;
    UIPickerView        *_pv;
    NSInteger           _selectIdxYear;
    NSInteger           _selectIdxMonth;
    NSInteger           _thisYear;
    NSInteger           _thisMonth;
}

@end

@implementation InputBuildYearViewCtrl
#define ROW_YEAR    100

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"建築年";
    
    /****************************************/
    _thisYear   = [UIUtil getThisYear];
    _thisMonth  = [UIUtil getThisMonth];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_buildYear        = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_buildYear];
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
    NSInteger buildYear  = [UIUtil getYear_term:_modelRE.estate.house.buildTerm];
    NSInteger buildMonth = [UIUtil getMonth_term:_modelRE.estate.house.buildTerm];
    _selectIdxYear      = buildYear - _thisYear + ROW_YEAR -3;
    _selectIdxMonth     = buildMonth -1;
    [_pv selectRow:_selectIdxYear inComponent:0 animated:NO];
    [_pv selectRow:_selectIdxMonth inComponent:1 animated:NO];
    [_scrollView addSubview:_pv];
    
    _l_buildYear.text = [self getBuildStr_year:_selectIdxYear month:_selectIdxMonth];
                                                                     
    
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
        [UIUtil setRectLabel:_l_buildYear   x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
        [_pv setFrame:CGRectMake(_pos.x_left,   _pos.y_btm - 300, _pos.len30, 216)];
    } else {
        [UIUtil setRectLabel:_l_buildYear   x:pos_x y:pos_y viewWidth:_pos.len15 viewHeight:dy color:[UIUtil color_Ivory] ];
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
        NSInteger buildYear  = _selectIdxYear + _thisYear - ROW_YEAR +3;
        NSInteger buildMonth = _selectIdxMonth +1;
        _modelRE.estate.house.buildTerm = [UIUtil getTerm_year:buildYear month:buildMonth];
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
-(NSString*) getBuildYearStr:(NSInteger)year
{
    NSInteger month = _selectIdxMonth + 1;
    NSInteger build = (_thisYear - year)*12 + (_thisMonth - month);
    
    if (year > _thisYear ){
        return [NSString stringWithFormat:@"建築中/%@(%@)",
                [UIUtil getYearShort:year],
                [UIUtil getJpnYearShort:year]];
    } else if ( year == _thisYear ){
        return [NSString stringWithFormat:@"新築/%@(%@)",
                [UIUtil getYearShort:year],
                [UIUtil getJpnYearShort:year]];
    } else {
        return [NSString stringWithFormat:@"築%ld年/%@(%@)",
                (NSInteger)build/12,
                [UIUtil getYearShort:year],
                [UIUtil getJpnYearShort:year]
                ];
    }
}
//======================================================================
//
//======================================================================
-(NSString*) getBuildStr_year:(NSInteger)idxYear month:(NSInteger)idxMonth
{
    NSString *str;

    NSInteger year  = idxYear + _thisYear - ROW_YEAR +3;
    NSInteger month = idxMonth + 1;

    NSInteger build = (_thisYear - year)*12 + (_thisMonth - month);
    
    if ( build >= 0 ){
        if ( build%12 != 0 ){
            str = [NSString stringWithFormat:@"築%ld年%ldヶ月/%ld年%ld月",
                                build/12,build%12,
                                year,month
                                ];
        }else{
            str = [NSString stringWithFormat:@"築%ld年/%ld年%ld月",
                   build/12,
                   year,month
                   ];
            
        }
    } else {
        str = [NSString stringWithFormat:@"%ld年%ld月築予定",
                            year,
                            month];
        
    }
    return str;
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
        return [self getBuildYearStr:row + _thisYear - ROW_YEAR +3];
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
        [_pv setFrame:CGRectMake(_pos.x_center,  1.2*_pos.dy, _pos.len30/2, 300)];
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
        [_pv reloadAllComponents];
    };
    _l_buildYear.text = [self getBuildStr_year:_selectIdxYear month:_selectIdxMonth];
    
    return;
}
//======================================================================
@end
//======================================================================
