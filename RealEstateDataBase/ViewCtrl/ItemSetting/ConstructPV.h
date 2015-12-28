//
//  ConstructPV.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/09/13.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopupPickerView.h"

@interface ConstructPV : UIPopupPickerView
{
    NSInteger           _construct;
}
/****************************************************************/
- (id)initWitTarget:(id)target frame:(CGRect)frame;
- (void)setIndex_construct:(NSInteger)construct;
/****************************************************************/
@property   (nonatomic,readonly)    NSInteger   construct;
/****************************************************************/
@end
/****************************************************************/
