//
//  InputHoldingPeriodViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputHoldingPeriodViewCtrl.h"

@interface InputHoldingPeriodViewCtrl ()
{
   
    UILabel             *_l_period;
    UITextView          *_tv_tips;

    UIPickerView        *_pv;
    NSInteger           _selectIdxYear;
    NSInteger           _selectIdxMonth;
    NSInteger           _acquYear;
    NSInteger           _acquMonth;
    
}
@end

@implementation InputHoldingPeriodViewCtrl


#define TTAG_PERIOD          1
#define ROW_YEAR    50

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"保有期間";
    
    /****************************************/
    _acquYear   = [UIUtil getYear_term:_modelRE.estate.house.acquisitionTerm];
    _acquMonth  = [UIUtil getMonth_term:_modelRE.estate.house.acquisitionTerm];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_period        = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_period];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"個人所有物件の場合、譲渡時期によって税率が変わります\n〜%ld年/12月:短期譲渡(所得税+住民税率39%%)\n%ld年/1月〜:長期譲渡(所得税+住民税率20%%)",
                               _acquYear+5,
                               _acquYear+6
                               ];
//    _tv_tips.text           = [NSString stringWithFormat:@"譲渡した年の1月1日において所有期間が5年以下の場合は短期譲渡となり、所得税・住民税の税率は39%%になります\n5年を越える場合には長期譲渡となり、税率は20%%になります"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _pv   = [[UIPickerView alloc]init];
    [_pv setBackgroundColor:[UIColor whiteColor]];
    [_pv setDelegate:self];
    [_pv setDataSource:self];
    [_pv setShowsSelectionIndicator:YES];
    NSInteger period = _modelRE.holdingPeriodTerm + _acquMonth -1;
    _selectIdxYear      = period/12;
    _selectIdxMonth     = period%12;
    [_pv selectRow:_selectIdxYear   inComponent:0 animated:NO];
    [_pv selectRow:_selectIdxMonth  inComponent:1 animated:NO];
    [_scrollView addSubview:_pv];
    
    _l_period.text = [self getHoldStr_year:_selectIdxYear month:_selectIdxMonth];
    /****************************************/
    
    
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
        /****************************************/
        [UIUtil setRectLabel:_l_period          x:pos_x         y:pos_y         viewWidth:_pos.len30 viewHeight:dy      color:[UIUtil color_Ivory] ];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*3);
        [_pv setFrame:CGRectMake(_pos.x_left,   _pos.y_btm - 300, _pos.len30, 216)];
        
    }else {
        /****************************************/
        [UIUtil setRectLabel:_l_period          x:pos_x         y:pos_y         viewWidth:_pos.len15 viewHeight:dy      color:[UIUtil color_Ivory] ];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*3);        
        [_pv setFrame:CGRectMake(_pos.x_center, pos_y, _pos.len30/2, 300)];
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
// Viewが消える直前
//======================================================================
-(void) viewWillDisappear:(BOOL)animated
{
    if ( _b_cancel == false ){
        NSInteger period = _selectIdxYear*12 + _selectIdxMonth - _acquMonth+1;
        if ( period < 1 ){
            period = 1;
        }
        _modelRE.holdingPeriodTerm = period;
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
    if (sender.tag == 1){
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return;
}
//======================================================================
//
//======================================================================
-(NSString*) getHoldStr_year:(NSInteger)idxYear month:(NSInteger)idxMonth
{

    NSInteger month = idxMonth +1;
    NSInteger year = idxYear + _acquYear;
    NSInteger period = idxYear*12 + idxMonth - _acquMonth+1;
    
    NSString *str;
    str = [NSString stringWithFormat:@"%ld年%ldヶ月(%ld年%ld月売却)",
                            period/12,
                            period%12,
                            year,
                            month];

    return str;
}
//======================================================================
//
//======================================================================
-(NSString*) getHoldStr_year:(NSInteger)idxYear
{
    
    NSInteger year = idxYear + _acquYear;
    NSInteger period = idxYear*12 + _selectIdxMonth - _acquMonth+1;
    
    NSString *str;
    str = [NSString stringWithFormat:@"%ld年%ldヶ月/%ld年",
           period/12,
           period%12,
           year];
    
    return str;
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
        return  [self getHoldStr_year:row];
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
        [_pv reloadAllComponents];
    };
    _l_period.text = [self getHoldStr_year:_selectIdxYear month:_selectIdxMonth];
    
    return;
}

//======================================================================
@end
//======================================================================
