//
//  UIPopupPickerView.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/17.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPopupPickerView : UIViewController<UIPickerViewDelegate>
{
}
/****************************************************************/
- (void)makePopup:(CGRect)frame tgt:(id)target;
- (void)showPickerView:(UIView*)view;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (BOOL)closePopup:(id)sender;
/****************************************************************/
@end
/****************************************************************/
