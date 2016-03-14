//
//  Calculator.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/05.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/****************************************************************/
@interface Calculator : NSObject
{
    NSString    *_workArea;
    NSString    *_inputArea;
    CGFloat     _calcValue;
}
/****************************************************************/
#define INKEY_NON   0
#define INKEY_ADD   1
#define INKEY_SUB   2
#define INKEY_MUL   3
#define INKEY_DIV   4
/****************************************************************/
- (id)initWithValue:(CGFloat)value;
- (void)initInput:(CGFloat)value;
- (void)inputValue:(NSString*)inval;
- (void)inputComma;
- (void)inputCalc:(int)nextKey;
- (void)inputBackSpace;
- (void)inputAllClear;
- (void)inputEnter;
- (void)inputInv;
- (BOOL)isEnterKeyMode;
- (BOOL)isEnterIn;

/****************************************************************/
@property   (nonatomic,readonly)    NSString    *workArea;
@property   (nonatomic,readonly)    NSString    *inputArea;
@property   (nonatomic,readonly)    CGFloat     calcValue;
/****************************************************************/
@end
/****************************************************************/
