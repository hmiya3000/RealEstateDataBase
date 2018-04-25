//
//  LoanPeriodPV.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/06.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopupPickerView.h"

//======================================================================
@interface LoanPeriodPV : UIPopupPickerView
{
    NSInteger           _year;
    NSInteger           _month;
}
//======================================================================
- (id)initWitTarget:(id)target frame:(CGRect)frame;
-(void)setIndex_year:(NSInteger)year month:(NSInteger)month;
//======================================================================
@property   (nonatomic,readonly)    NSInteger   year;
@property   (nonatomic,readonly)    NSInteger   month;
//======================================================================
@end
//======================================================================
