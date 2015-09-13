//
//  ConstructPV.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/09/13.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "ConstructPV.h"
#import "House.h"

@interface ConstructPV ()
{
    NSInteger           _selectIdx;
    NSInteger           _numRow;
    NSInteger           _numComponent;
}
@end
/****************************************************************/
#define START_YEAR  2000    /* 開始年     */
#define NUM_YEAR    100     /* １００年分 */
/****************************************************************/

@implementation ConstructPV
/****************************************************************/
- (id)initWitTarget:(id)target frame:(CGRect)frame
{
    self = [super init];
    if (self){
        [self setIndex_construct:0];
        _numRow         = CONST_MAX;
        _numComponent   = 1;
        [self makePopup:frame tgt:target];
    }
    return self;
}
/****************************************************************
 *
 ****************************************************************/
- (void)setIndex_construct:(NSInteger)construct
{
    _construct      = construct;
    _selectIdx      = construct;
    [self selectRow:_selectIdx inComponent:0];
}

/****************************************************************
 *
 ****************************************************************/
- (NSString*) getConstStr:(NSInteger)constNum
{
    return [NSString stringWithFormat:@"%@(%ld年)",[House constructStr:constNum],(long)[House usefulLife:constNum]];
}

/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************
 *　行数設定
 ****************************************************************/
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _numRow;
}

/****************************************************************
 * 列数設定
 ****************************************************************/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return _numComponent;
}

/****************************************************************
 *　行数取得
 ****************************************************************/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIdx=row;
}

/****************************************************************
 * 表示する内容を返す
 ****************************************************************/
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self getConstStr:row];
}

/****************************************************************
 * データ取得
 ****************************************************************/
- (void)pickedData:(id)sender
{
    NSInteger row;
    
    
    row = [self selectedRowInComponent:0];
    
    _selectIdx=row;
    _construct    = row;
    [self closePopup:sender];
}
/****************************************************************/
@end
/****************************************************************/
