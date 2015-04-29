//
//  UICalc.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/19.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalcKey.h"

/****************************************************************/
@protocol UICalcDelegate <NSObject>

- (void) updateArea:(NSString*)inputArea work:(NSString*)workArea;
- (void) enterIn:(CGFloat)value;

@end
/****************************************************************/
@interface UICalc : NSObject
{
    NSString*   _workArea;
    NSString*   _inputArea;
}
/****************************************************************/
- (id) initWithValue:(CGFloat)value;
- (void) uvinit:(UIView*)view;
- (void) setuv:(CGRect)rect;
/****************************************************************/
@property   (nonatomic,assign)      id<UICalcDelegate> delegate;
@property   (nonatomic,readonly)    NSString    *workArea;
@property   (nonatomic,readonly)    NSString    *inputArea;
/****************************************************************/
@end
/****************************************************************/
