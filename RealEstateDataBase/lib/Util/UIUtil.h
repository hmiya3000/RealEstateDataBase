//
//  UIUtil.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/03.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVSegmentedControl.h"

@interface UIUtil : NSObject
{
}
/****************************************************************/
+ (UILabel*)makeLabel:(NSString*)text;
/*--------------------------------------------------------------*/
+ (void)setLabel:(UILabel*)label x:(CGFloat)x y:(CGFloat)y length:(CGFloat)length;
+ (void)setRectLabel:(UILabel*)label  x:(CGFloat)x y:(CGFloat)y viewWidth:(CGFloat)viewWidth viewHeight:(CGFloat)viewHeight color:(UIColor*)color;
+ (void)setTitleLabel:(UILabel*)label  x:(CGFloat)x y:(CGFloat)y viewWidth:(CGFloat)viewWidth;
/*--------------------------------------------------------------*/
+ (UILabel*)makeLine_y:(CGFloat)y length:(CGFloat)length;
/****************************************************************/
+ (UITextField*)makeTextField:(NSString*)text       tgt:(id)obj;
+ (UITextField*)makeTextFieldDec:(NSString*)text    tgt:(id)obj;
+ (UITextField*)makeTextFieldNum:(NSString*)text    tgt:(id)obj;
/*--------------------------------------------------------------*/
+ (void)setTextField:(UITextField*)textField x:(CGFloat)x y:(CGFloat)y length:(CGFloat)length;
+ (void)setTitleTextField:(UITextField*)textField x:(CGFloat)x y:(CGFloat)y  viewWidth:(CGFloat)viewWidth;
/*--------------------------------------------------------------*/
+ (void)closeKeyboard:(id)sender;
/****************************************************************/
+ (UIButton*)makeButton:(NSString*)text tag:(int)tag;
/*--------------------------------------------------------------*/
+ (void)setButton:(UIButton*)button x:(CGFloat)x y:(CGFloat)y length:(CGFloat)length;
+ (void)setTextButton:(UIButton*)button x:(CGFloat)x y:(CGFloat)y length:(CGFloat)length;
+ (void)setTitleButton:(UIButton*)button x:(CGFloat)x y:(CGFloat)y viewWidth:(CGFloat)viewWidth;
/****************************************************************/
+ (NSString*)yenValue:(NSInteger)yen;
+ (UILabel*)labelYen:(UILabel*)label yen:(NSInteger)yen;
+ (NSString*)localedPrice:(NSNumber*)price locale:(NSLocale *)locale;
/*--------------------------------------------------------------*/
+ (NSInteger)getThisYear;
+ (NSInteger)getThisMonth;
+ (NSInteger)getMaxDay_year:(NSInteger)year month:(NSInteger)month;
+ (NSString*)getJpnYear:(NSInteger)year;
/****************************************************************/
+ (SVSegmentedControl*)makeSegmentedControl_x:(CGFloat)x y:(CGFloat)y length:(CGFloat)len array:(NSArray*)arr;
/****************************************************************/
+ (NSString*)fixString:(NSString*)str length:(NSInteger)length;
+(NSString*)removePrefix:(NSString*)prefix targetStr:(NSString*)targetStr;
/****************************************************************/
+ (UIScrollView*)makeScrollView:(CGRect)rect  xpage:(CGFloat)xpage ypage:(NSInteger)ypage tgt:(id)obj;
//====================================================================
+ (UITextView*)makeTextView_x:(CGFloat)x y:(CGFloat)y width:(CGFloat)w height:(CGFloat)h;
//====================================================================
+ (UIImageView*)makeImageView;
+ (void)setImageView:(UIImageView*)image frame:(CGRect)frame;
//====================================================================
+ (CGRect)mergin_rect:(CGRect)rect top:(CGFloat)top bottom:(CGFloat)bottom left:(CGFloat)left right:(CGFloat)right;
/****************************************************************/
+ (UIColor*)color_Yellow;
+ (UIColor*)color_LightYellow;
+ (UIColor*)color_Ivory;
+ (UIColor*)color_WakatakeIro;
+ (UIColor*)color_UsusumiIro;

/****************************************************************/
@end
/****************************************************************/
