//
//  BuildYearPV.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/09/13.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopupPickerView.h"

@interface BuildYearPV : UIPopupPickerView
{
    NSInteger           _year;
}
//======================================================================
- (id)initWitTarget:(id)target frame:(CGRect)frame;
-(void)setIndex_year:(NSInteger)year;
//======================================================================
@property   (nonatomic,readonly)    NSInteger   year;
//======================================================================
@end
//======================================================================
