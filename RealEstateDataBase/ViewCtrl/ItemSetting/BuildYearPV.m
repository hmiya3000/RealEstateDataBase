//
//  BuildYearPV.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/09/13.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "BuildYearPV.h"
#import "UIUtil.h"

@interface BuildYearPV ()
{
    NSInteger           _selectIdx;
    NSInteger           _numRow;
    NSInteger           _numComponent;
    NSInteger           _thisYear;
}
@end
//======================================================================
#define START_YEAR  2000    /* 開始年     */
#define NUM_YEAR    100     /* １００年分 */
//======================================================================
@implementation BuildYearPV
//======================================================================
-(id)initWitTarget:(id)target frame:(CGRect)frame
{
    self = [super init];
    if (self){
        [self setIndex_year:2000];
        _thisYear = [UIUtil getThisYear];
        _numRow         = NUM_YEAR;
        _numComponent   = 1;
        [self makePopup:frame tgt:target];
    }
    return self;
}
//======================================================================
//
//======================================================================
-(void)setIndex_year:(NSInteger)year
{
    _year       = year;
    _selectIdx  = _thisYear - year +1;
    [self selectRow:_selectIdx inComponent:0];
}

//======================================================================
//
//======================================================================
-(NSString*) getBuildYearStr:(NSInteger)year
{
    
    if (year > _thisYear ){
        return [NSString stringWithFormat:@"建築中"];
    } else if ( year == _thisYear ){
        return [NSString stringWithFormat:@"新築(%4d年/%@)",
                (int)(year),
                [UIUtil getJpnYear:year]];
    } else {
        return [NSString stringWithFormat:@"築%2d年(%4d年/%@)",
                (int)(_thisYear - year ),
                (int)(year),
                [UIUtil getJpnYear:year]];
    }
}
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
// 行数設定
//======================================================================
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _numRow;
}

//======================================================================
// 列数設定
//======================================================================
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return _numComponent;
}

//======================================================================
// 行数取得
//======================================================================
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIdx=row;
}

//======================================================================
// 表示する内容を返す
//======================================================================
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getBuildYearStr:_thisYear - row+1];
}

//======================================================================
// データ取得
//======================================================================
-(void)pickedData:(id)sender
{
    NSInteger row;
    
    row = [self selectedRowInComponent:0];
    
    _selectIdx  = row;
    _year       = _thisYear - row +1;
    [self closePopup:sender];
}
//======================================================================
@end
//======================================================================
