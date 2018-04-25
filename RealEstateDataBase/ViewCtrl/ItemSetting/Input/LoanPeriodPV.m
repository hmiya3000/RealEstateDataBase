//
//  LoanPeriodPV.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/06.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "LoanPeriodPV.h"

@interface LoanPeriodPV ()
{
    NSInteger           _selectIdxYear;
    NSInteger           _selectIdxMonth;
    NSInteger           _numRow;
    NSInteger           _numComponent;
}

@end
//======================================================================
#define START_YEAR  2000    /* 開始年     */
#define NUM_YEAR    50     /* 50年分 */
//======================================================================
@implementation LoanPeriodPV
//======================================================================
@synthesize year    = _year;
@synthesize month   = _month;
//======================================================================
- (id)initWitTarget:(id)target frame:(CGRect)frame
{
    self = [super init];
    if (self){
        [self setIndex_year:2000 month:1];
        _numRow         = NUM_YEAR *12;
        _numComponent   = 2;
        [self makePopup:frame tgt:target];
    }
    return self;
}
//======================================================================
//
//======================================================================
-(void)setIndex_year:(NSInteger)year month:(NSInteger)month
{
    _selectIdxYear       = year;
    _selectIdxMonth      = month;
    [self selectRow:_selectIdxYear  inComponent:0];
    [self selectRow:_selectIdxMonth inComponent:1];
}
//======================================================================
// 列数設定
//======================================================================
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return _numComponent;
}
//======================================================================
// 行数設定
//======================================================================
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ( component == 0 ){
        return NUM_YEAR;
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
        return [NSString stringWithFormat:@"%2ld年",row];
    } else {
        return [NSString stringWithFormat:@"%2ldヶ月",row];
    }
}
//======================================================================
// 行数取得
//======================================================================
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ( component == 0 ){
        _selectIdxYear          = row;
    } else {
        _selectIdxMonth         = row;
    };
//    _l_buildYear.text = [self getBuildStr_year:_selectIdxYear month:_selectIdxMonth];
    
    return;
}

//======================================================================
// データ取得
//======================================================================
-(void)pickedData:(id)sender
{
    _year   = [self selectedRowInComponent:0];
    _month  = [self selectedRowInComponent:1];

    [self closePopup:sender];
}
//======================================================================
@end
//======================================================================
