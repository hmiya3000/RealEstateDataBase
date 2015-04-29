//
//  Calculator.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Calculator.h"
#import "CalcKey.h"

/****************************************************************/
#define STATE_INIT      0       /* 未入力の初期状態 */
#define STATE_VALKEY    1       /* 数字入力状態 */
#define STATE_COMKEY    2      /* 小数入力状態 */
#define STATE_CALKEY    3       /* 演算キー入力状態 */
#define STATE_EQUAL     4       /* イコールキー入力（演算済で数字未入力） */
#define STATE_ENTER_IN  5

/****************************************************************/
@implementation Calculator
{
    int             _state;
    int             _inCalckey;
    NSString        *_wkAnswer;

}

/****************************************************************/
@synthesize workArea    = _workArea;
@synthesize inputArea   = _inputArea;
@synthesize calcValue   = _calcValue;
/****************************************************************/

/****************************************************************
 * 初期化
 ****************************************************************/
- (id)initWithValue:(CGFloat)value
{
    self = [super init];
    if (self){
        [self initInput:value];
    }
    return self;
}
/****************************************************************
 * 設定初期化
 * XXXXX    -> INIT
 ****************************************************************/
- (void)initInput:(CGFloat)value
{
    _calcValue      = value;
    
    if ( value == (int)value ){
        _state      = STATE_VALKEY;
    } else {
        _state      = STATE_COMKEY;
    }
    
    _state          = STATE_INIT;
    _inCalckey      = INKEY_NON;
    _wkAnswer       = [NSMutableString stringWithFormat:@"%g",value];
    _workArea       = [self dispStr:_wkAnswer];
    _inputArea      = [NSMutableString stringWithFormat:@"0"];
    
}
/****************************************************************
 * 数字キーの入力
 *
 * INIT    -> VALKEY
 * VALKEY  -> VALKEY
 * COMKEY  -> COMKEY
 * CALKEY  -> VALKEY
 * EQUAL   -> VALKEY
 * ENTER_IN-> VALKEY
 ****************************************************************/
- (void)inputValue:(NSString*)inval
{
    if ( _state == STATE_INIT ){
        /* 未入力でいきなり数字キー入力があったらworkをクリアする */
        [self initInput:0];
    } else if ( _state == STATE_CALKEY ){
        [self addCalcKey];
    }
    if ( _state != STATE_COMKEY ){
        _state = STATE_VALKEY;
    }
    _wkAnswer   = [self inputStr:inval toStr:_wkAnswer];
    _workArea   = [self dispStr:_wkAnswer];
    
}
/****************************************************************
 * 小数点キーの入力
 *
 * INIT    -> COMKEY
 * VALKEY  -> COMKEY
 * COMKEY  -> 処理なし
 * CALKEY  -> COMKEY
 * EQUAL   -> COMKEY
 * ENTER_IN-> COMKEY
 ****************************************************************/
-(void)inputComma
{
    if ( _state != STATE_COMKEY ){
        /* 小数点入力していければ入力可 */
        _state = STATE_COMKEY;
        if( [_wkAnswer isEqualToString:@"0"] == true){
            _wkAnswer   = [self inputStr:@"0." toStr:_wkAnswer];
        } else {
            _wkAnswer   = [self inputStr:@"." toStr:_wkAnswer];
        }
        _workArea       = [self dispStr:_wkAnswer];
    }
    return;
}
/****************************************************************
 * 演算キーの入力
 *
 * INIT    -> CALKEY
 * VALKEY  -> CALKEY
 * COMKEY  -> CALKEY
 * CALKEY  -> CALKEY _inCalcKeyの更新のみ
 * EQUAL   -> CALKEY
 * ENTER_IN-> CALKEY
 ****************************************************************/
- (void)inputCalc:(int)nextKey
{
    if ( _state != STATE_CALKEY){
        _state      = STATE_CALKEY;
        if ( [_inputArea isEqualToString:@"0"] == true ){
            /* 未入力状態 */
            _inputArea  = _wkAnswer;
        } else {
            /* 入力済状態 */
            if (_inCalckey != INKEY_NON ){
                _inputArea  = [_inputArea stringByAppendingString:_wkAnswer ]; /* input Areaへのworkの追加 */
            }
        }
        [self calculate];
    }
    _inCalckey  = nextKey;
    return;
}
/****************************************************************
 * エンターキーの入力
 *
 * INIT    -> EQUAL    inputAreaへのコピー
 * VALKEY  -> ENTER_IN inputAreaへの追加
 * COMKEY  -> ENTER_IN inputAreaへの追加
 * CALKEY  -> ENTER_IN inputAreaへの追加
 * EQUAL   -> EQUAL    inputAreaへの追加
 * ENTER_IN-> ENTER_IN inputAreaへの追加
 ****************************************************************/
- (void)inputEnter
{
    if ( [_inputArea isEqualToString:@"0"] == true ){
        /* 未入力状態 */
        _inputArea      = _wkAnswer;
    } else {
        /* 入力済状態 */
        if (_inCalckey != INKEY_NON ){
            _inputArea  = [_inputArea stringByAppendingString:_wkAnswer ]; /* input Areaへのworkの追加 */
        }
    }
    [self calculate];
    _inCalckey  = INKEY_NON;

    if ( _state != STATE_EQUAL && _state != STATE_INIT ){
        _state = STATE_EQUAL;
    } else if ( _state == STATE_INIT ){
        _state  = STATE_INIT;
    }else {
        _state  = STATE_ENTER_IN;
    }
    return;
}
/****************************************************************
 * バックスペースキーの入力
 ****************************************************************/
- (void)inputBackSpace
{
    if ( _state == STATE_CALKEY){
        _wkAnswer= @"0";
    }
    NSMutableString *str = [NSMutableString stringWithString:_wkAnswer];
    NSInteger len = [str length];
    if ( len > 1 ){
        [str deleteCharactersInRange:NSMakeRange(len-1,1)];
        NSRange range = [str rangeOfString:@"."];
        if ( range.location == NSNotFound ){
            _state  = STATE_VALKEY;
        } else {
            _state  = STATE_COMKEY;
        }
    } else if ( len == 1 ){
        str = [NSMutableString stringWithString:@"0"];
        _state = STATE_EQUAL;
    }
    _wkAnswer   = str;
    _workArea   = [self dispStr:_wkAnswer];
    return;
}
/****************************************************************
 * オールクリアキーの入力
 ****************************************************************/
- (void)inputAllClear
{
    [self initInput:0];
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
/****************************************************************
 *
 ****************************************************************/
-(NSString*)dispStr:(NSString*)orgStr
{
    return orgStr;
}


/****************************************************************
 * 演算キーをInputエリアに追加
 ****************************************************************/
- (void) addCalcKey
{
    _wkAnswer   = @"0";
    NSString *inkeyStr;
    switch (_inCalckey) {
        case INKEY_ADD:
            inkeyStr = @"+";
            break;
        case INKEY_SUB:
            inkeyStr = @"-";
            break;
        case INKEY_MUL:
            inkeyStr = @"×";
            break;
        case INKEY_DIV:
            inkeyStr = @"÷";
            break;
        default:
            break;
    }
    _inputArea  = [_inputArea stringByAppendingString:inkeyStr ];  /* input Areaへのworkの追加 */
}
/****************************************************************
 * 「0」の場合以外に文字列の追加
 ****************************************************************/
-(NSString*)inputStr:(NSString*)inStr toStr:(NSString*)toStr
{
    NSString *str0 = @"0";
    
    if ( [toStr isEqualToString:str0] == true ){
        return inStr;
    } else {
        return [toStr stringByAppendingString:inStr];
    }
}

/****************************************************************
 * [_calcValue]  [_inCalcKey] [_wkAnswer]  で計算
 ****************************************************************/
- (void)calculate
{
    CGFloat newin = [_wkAnswer floatValue];
    _calcValue  = [self calc:newin];                               /* workとの計算 */
    _wkAnswer   = [NSString stringWithFormat:@"%g",_calcValue];   /* 計算結果のworkへの書き戻し */
    NSLog(@"%g    ",_calcValue);
    _workArea   = [self dispStr:_wkAnswer];           /* workの表示領域への変換 */
    
}
/****************************************************************
 *
 ****************************************************************/
-(CGFloat)calc:(CGFloat)newin
{
    CGFloat tmp;
    switch(_inCalckey){
        case INKEY_ADD:
            tmp  = _calcValue + newin;
            break;
        case INKEY_SUB:
            tmp = _calcValue - newin;
            break;
        case INKEY_MUL:
            tmp = _calcValue * newin;
            break;
        case INKEY_DIV:
            tmp = _calcValue / newin;
            break;
        default:
            tmp = newin;
            break;
    }
    return tmp;
}

/****************************************************************
 *
 ****************************************************************/
- (BOOL)isEnterKeyMode
{
    if ( _state == STATE_INIT || _state == STATE_EQUAL ){
        return true;
    } else {
        return false;
    }
}
/****************************************************************
 *
 ****************************************************************/
- (BOOL)isEnterIn
{
    if ( _state == STATE_ENTER_IN  || _state == STATE_INIT ){
        return true;
    } else {
        return false;
    }
    
}
@end
