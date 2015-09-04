//
//  UICalc.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/19.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "UICalc.h"
#import "Calculator.h"


@implementation UICalc
{

    CalcKey         *_k_1;
    CalcKey         *_k_2;
    CalcKey         *_k_3;
    CalcKey         *_k_4;
    CalcKey         *_k_5;
    CalcKey         *_k_6;
    CalcKey         *_k_7;
    CalcKey         *_k_8;
    CalcKey         *_k_9;
    CalcKey         *_k_0;
    CalcKey         *_k_000;
    CalcKey         *_k_com;
    
    CalcKey         *_k_add;
    CalcKey         *_k_sub;
    CalcKey         *_k_mul;
    CalcKey         *_k_div;
    CalcKey         *_k_1x;
    
    CalcKey         *_k_cls;
    CalcKey         *_k_bks;
    CalcKey         *_k_alc;
    CalcKey         *_k_ent;
    
    Calculator      *_calc;
    
    CGFloat         _calcValue;
    
}

@synthesize delegate;
@synthesize workArea    = _workArea;
@synthesize inputArea   = _inputArea;

#define TAG_1       1
#define TAG_2       2
#define TAG_3       3
#define TAG_4       4
#define TAG_5       5
#define TAG_6       6
#define TAG_7       7
#define TAG_8       8
#define TAG_9       9
#define TAG_0       10
#define TAG_COM     11
#define TAG_000     12

#define TAG_ADD     21
#define TAG_SUB     22
#define TAG_MUL     23
#define TAG_DIV     24
#define TAG_EQU     25
#define TAG_1X      26

#define TAG_CLS     31
#define TAG_BKS     32
#define TAG_ALC     33
#define TAG_ENT     34
/****************************************************************
 *
 ****************************************************************/
- (id) initWithValue:(CGFloat)value
{
    self = [super init];
    if (self){
        _calcValue  = value;
        _calc       = [[Calculator alloc]initWithValue:_calcValue];
        _workArea    = _calc.workArea;
        _inputArea   = _calc.inputArea;
        if ([self.delegate respondsToSelector:@selector(updateArea:work:)]) {
            // デリゲート先にイベントを飛ばす
            [self.delegate updateArea:[NSString stringWithFormat:@"%g",_calcValue] work:@"0"];
        }

    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (void) uvinit:(UIView*)view
{
    _k_0    = [self makeKey:@"0" tag:TAG_0];
    _k_1    = [self makeKey:@"1" tag:TAG_1];
    _k_2    = [self makeKey:@"2" tag:TAG_2];
    _k_3    = [self makeKey:@"3" tag:TAG_3];
    _k_4    = [self makeKey:@"4" tag:TAG_4];
    _k_5    = [self makeKey:@"5" tag:TAG_5];
    _k_6    = [self makeKey:@"6" tag:TAG_6];
    _k_7    = [self makeKey:@"7" tag:TAG_7];
    _k_8    = [self makeKey:@"8" tag:TAG_8];
    _k_9    = [self makeKey:@"9" tag:TAG_9];
    _k_000 = [self makeKey:@"000" tag:TAG_000];
    
    _k_add  = [self makeKey:@"+" tag:TAG_ADD];
    _k_sub  = [self makeKey:@"-" tag:TAG_SUB];
    _k_mul  = [self makeKey:@"×" tag:TAG_MUL];
    _k_div  = [self makeKey:@"÷" tag:TAG_DIV];
    _k_ent  = [self makeKey:@"ENT" tag:TAG_ENT];
    _k_com  = [self makeKey:@"." tag:TAG_COM];
    _k_1x   = [self makeKey:@"1/x" tag:TAG_1X];
    _k_alc  = [self makeKey:@"AC" tag:TAG_ALC];
    _k_bks  = [self makeKey:@"BS" tag:TAG_BKS];
    
    [view addSubview:_k_0];
    [view addSubview:_k_1];
    [view addSubview:_k_2];
    [view addSubview:_k_3];
    [view addSubview:_k_4];
    [view addSubview:_k_5];
    [view addSubview:_k_6];
    [view addSubview:_k_7];
    [view addSubview:_k_8];
    [view addSubview:_k_9];
    [view addSubview:_k_000];
    
    [view addSubview:_k_add];
    [view addSubview:_k_sub];
    [view addSubview:_k_mul];
    [view addSubview:_k_div];
    [view addSubview:_k_1x];
    
    [view addSubview:_k_com];
    [view addSubview:_k_ent];
    [view addSubview:_k_alc];
    [view addSubview:_k_bks];
    
}
/****************************************************************
 *
 ****************************************************************/
- (void) setuv:(CGRect)rect
{
    CGFloat x_ini,y_ini,h_all,w_all,h_mag,w_mag,h_1,w_1;
    x_ini = rect.origin.x;
    y_ini = rect.origin.y;
    h_all = rect.size.height;
    w_all = rect.size.width;
    h_mag = h_all * 0.01;
    w_mag = w_all * 0.01;
    w_1 = (w_all - w_mag*5) / 4;
    h_1 = (h_all - h_mag*6) / 5;
    
    [self setKey:_k_alc rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*0,    y_ini+h_mag+(h_1+h_mag)*0, w_1, h_1)];
    [self setKey:_k_bks rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*1,    y_ini+h_mag+(h_1+h_mag)*0, w_1, h_1)];
    [self setKey:_k_1x  rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*2,    y_ini+h_mag+(h_1+h_mag)*0, w_1, h_1)];
    [self setKey:_k_div rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*3,    y_ini+h_mag+(h_1+h_mag)*0, w_1, h_1)];
    
    [self setKey:_k_7   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*0,    y_ini+h_mag+(h_1+h_mag)*1, w_1, h_1)];
    [self setKey:_k_8   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*1,    y_ini+h_mag+(h_1+h_mag)*1, w_1, h_1)];
    [self setKey:_k_9   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*2,    y_ini+h_mag+(h_1+h_mag)*1, w_1, h_1)];
    [self setKey:_k_mul rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*3,    y_ini+h_mag+(h_1+h_mag)*1, w_1, h_1)];
    
    [self setKey:_k_4   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*0,    y_ini+h_mag+(h_1+h_mag)*2, w_1, h_1)];
    [self setKey:_k_5   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*1,    y_ini+h_mag+(h_1+h_mag)*2, w_1, h_1)];
    [self setKey:_k_6   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*2,    y_ini+h_mag+(h_1+h_mag)*2, w_1, h_1)];
    [self setKey:_k_sub rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*3,    y_ini+h_mag+(h_1+h_mag)*2, w_1, h_1)];
    
    [self setKey:_k_1   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*0,    y_ini+h_mag+(h_1+h_mag)*3, w_1, h_1)];
    [self setKey:_k_2   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*1,    y_ini+h_mag+(h_1+h_mag)*3, w_1, h_1)];
    [self setKey:_k_3   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*2,    y_ini+h_mag+(h_1+h_mag)*3, w_1, h_1)];
    [self setKey:_k_add rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*3,    y_ini+h_mag+(h_1+h_mag)*3, w_1, h_1)];
    
    [self setKey:_k_0   rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*0,    y_ini+h_mag+(h_1+h_mag)*4, w_1, h_1)];
    [self setKey:_k_000 rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*1,    y_ini+h_mag+(h_1+h_mag)*4, w_1, h_1)];
    [self setKey:_k_com rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*2,    y_ini+h_mag+(h_1+h_mag)*4, w_1, h_1)];
    [self setKey:_k_ent rect:CGRectMake(x_ini+w_mag+(w_1+w_mag)*3,    y_ini+h_mag+(h_1+h_mag)*4, w_1, h_1)];
}
/****************************************************************
 *
 ****************************************************************/
-(CalcKey*)makeKey:(NSString*)text tag:(int)tag
{
    CalcKey *name = [[CalcKey alloc]init];
    name.text = text;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setTag:tag];
    
    button.layer.shadowOpacity = 0.5;
    button.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    [button addTarget:self action:@selector(keyUp:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(keyDown:) forControlEvents:UIControlEventTouchDown];
    
    [name addSubview:button];
    return name;
    
}

/****************************************************************
 *
 ****************************************************************/
- (void) setKey:(CalcKey*)key rect:(CGRect)rect
{
    [key setFrame:rect];
    [key setNeedsDisplay];
    NSInteger last = [key.subviews count] - 1;
    UIView *button = [key.subviews objectAtIndex:last];
    [button setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
}


/****************************************************************
 *
 ****************************************************************/
-(void)keyDown:(CalcKey*)sender
{
    if (       sender.tag == TAG_0){
        [_k_0 keyDown];
    }else if ( sender.tag == TAG_1){
        [_k_1 keyDown];
    }else if ( sender.tag == TAG_2){
        [_k_2 keyDown];
    }else if ( sender.tag == TAG_3){
        [_k_3 keyDown];
    }else if ( sender.tag == TAG_4){
        [_k_4 keyDown];
    }else if ( sender.tag == TAG_5){
        [_k_5 keyDown];
    }else if ( sender.tag == TAG_6){
        [_k_6 keyDown];
    }else if ( sender.tag == TAG_7){
        [_k_7 keyDown];
    }else if ( sender.tag == TAG_8){
        [_k_8 keyDown];
    }else if ( sender.tag == TAG_9){
        [_k_9 keyDown];
    }else if ( sender.tag == TAG_000){
        [_k_000 keyDown];
    }else if ( sender.tag == TAG_COM){
        [_k_com keyDown];
    }else if ( sender.tag == TAG_ADD){
        [_k_add keyDown];
    }else if ( sender.tag == TAG_SUB){
        [_k_sub keyDown];
    }else if ( sender.tag == TAG_MUL){
        [_k_mul keyDown];
    }else if ( sender.tag == TAG_DIV){
        [_k_div keyDown];
    }else if ( sender.tag == TAG_1X){
        [_k_1x keyDown];
    }else if ( sender.tag == TAG_BKS){
        [_k_bks keyDown];
    }else if ( sender.tag == TAG_ALC){
        [_k_alc keyDown];
    } else if ( sender.tag == TAG_ENT){
        [_k_ent keyDown];
    }
}
/****************************************************************
 *
 ****************************************************************/
-(void)keyUp:(CalcKey*)sender
{
//    NSLog(@"%s",__FUNCTION__);
    [_k_add keyUp];
    [_k_sub keyUp];
    [_k_mul keyUp];
    [_k_div keyUp];
    if (        sender.tag == TAG_0){
        [self keyInValue:_k_0];
        [_calc  inputValue:@"0"];
    } else if ( sender.tag == TAG_1){
        [self keyInValue:_k_1];
        [_calc inputValue:@"1"];
    } else if ( sender.tag == TAG_2){
        [self keyInValue:_k_2];
        [_calc inputValue:@"2"];
    } else if ( sender.tag == TAG_3){
        [self keyInValue:_k_3];
        [_calc inputValue:@"3"];
    } else if ( sender.tag == TAG_4){
        [self keyInValue:_k_4];
        [_calc inputValue:@"4"];
    } else if ( sender.tag == TAG_5){
        [self keyInValue:_k_5];
        [_calc inputValue:@"5"];
    } else if ( sender.tag == TAG_6){
        [self keyInValue:_k_6];
        [_calc inputValue:@"6"];
    } else if ( sender.tag == TAG_7){
        [self keyInValue:_k_7];
        [_calc inputValue:@"7"];
    } else if ( sender.tag == TAG_8){
        [self keyInValue:_k_8];
        [_calc inputValue:@"8"];
    } else if ( sender.tag == TAG_9){
        [self keyInValue:_k_9];
        [_calc inputValue:@"9"];
    } else if ( sender.tag == TAG_000){
        [self keyInValue:_k_000];
        [_calc inputValue:@"000"];
    }else if ( sender.tag == TAG_1X){
        [self keyInValue:_k_1x];
        [_calc inputInv];
    } else if ( sender.tag == TAG_COM){
        [self keyInValue:_k_com];
        [_calc inputComma];
    }else if ( sender.tag == TAG_ADD){
        [self keyInCalc:_k_add];
        [_calc inputCalc:INKEY_ADD];
    }else if ( sender.tag == TAG_SUB){
        [self keyInCalc:_k_sub];
        [_calc inputCalc:INKEY_SUB];
    }else if ( sender.tag == TAG_MUL){
        [self keyInCalc:_k_mul];
        [_calc inputCalc:INKEY_MUL];
    }else if ( sender.tag == TAG_DIV){
        [self keyInCalc:_k_div];
        [_calc inputCalc:INKEY_DIV];
    }else if ( sender.tag == TAG_BKS){
        [self keyInValue:_k_bks];
        [_calc inputBackSpace];
    }else if ( sender.tag == TAG_ALC){
        [self keyInValue:_k_alc];
        [_calc inputAllClear];
    }else if ( sender.tag == TAG_ENT){
        [self keyInValue:_k_ent];
        [_calc inputEnter];
    }
    /* Update chara of Enter key */
    if ( [_calc isEnterKeyMode] == true ){
        _k_ent.text = @"ENT";
    } else {
        _k_ent.text = @"=";
    }
    
    _workArea    = _calc.workArea;
    _inputArea   = _calc.inputArea;
    if ( [_calc isEnterIn] == true ){
        _calcValue      = _calc.calcValue;
        if ([self.delegate respondsToSelector:@selector(enterIn:)]) {
            // デリゲート先にイベントを飛ばす
            [self.delegate enterIn:_calc.calcValue];
        }
//        [_calc initInput:_calcValue];
    }
    if ([self.delegate respondsToSelector:@selector(updateArea:work:)]) {
        // デリゲート先にイベントを飛ばす
        [self.delegate updateArea:_calc.inputArea work:_calc.workArea];
    }
    
}

/****************************************************************
 *
 ****************************************************************/
- (void)keyInValue:(CalcKey*)selKey
{
    [_k_add keyUp];
    [_k_sub keyUp];
    [_k_mul keyUp];
    [_k_div keyUp];
    if ( selKey != nil){
        [selKey keyUp];
    }
}
/****************************************************************
 *
 ****************************************************************/
- (void)keyInCalc:(CalcKey*)selKey
{
    [_k_add keyUp];
    [_k_sub keyUp];
    [_k_mul keyUp];
    [_k_div keyUp];
    if ( selKey != nil){
        [selKey keyDown];
    }
}


@end
