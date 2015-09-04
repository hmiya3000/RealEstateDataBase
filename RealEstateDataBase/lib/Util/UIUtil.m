//
//  UIUtil.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/03.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "UIUtil.h"
#import "UIButtonWithObj.h"
#import "SVSegmentedControl.h"

/****************************************************************/
@interface UIUtil()
+ (UITextField*)makeTextFieldWithKbType:(UIKeyboardType)kbtype text:(NSString*)text tgt:(id)obj;
@end
/****************************************************************/


/****************************************************************/
@implementation UIUtil

/****************************************************************
 *
 ****************************************************************/
+ (UILabel*)makeLabel:(NSString*)text
{
    UILabel* label = [[UILabel alloc] init];
    [label setText:text];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
}
/****************************************************************
 *
 ****************************************************************/
+ (void)setLabel:(UILabel*)label x:(CGFloat)x y:(CGFloat)y length:(CGFloat)length
{
    NSString *text = [NSString stringWithFormat:@"aaa"];
    UIFont* font= [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect rect = CGRectMake(x, y+size.height*0.2, length,size.height);
    [label setFrame:rect];
    return;
}
/****************************************************************
 *
 ****************************************************************/
+ (void)setTitleLabel:(UILabel*)label  x:(CGFloat)x y:(CGFloat)y viewWidth:(CGFloat)viewWidth
{
    UIFont* font= [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect rect = CGRectMake(x, y+size.height*0.1, viewWidth-2*x,size.height*1.8 );
    [label setFrame:rect];
    [label setBackgroundColor:[self color_WakatakeIro]];
    return;
}
/****************************************************************
 *
 ****************************************************************/
+ (void)setRectLabel:(UILabel*)label  x:(CGFloat)x y:(CGFloat)y viewWidth:(CGFloat)viewWidth viewHeight:(CGFloat)viewHeight color:(UIColor*)color
{
    CGRect rect = CGRectMake(x, y, viewWidth,viewHeight );
    [label setFrame:rect];
    [label setBackgroundColor:color]; //wakatake iro
    return;
}
/****************************************************************
 *
 ****************************************************************/
+ (UILabel*)makeLine_y:(CGFloat)y length:(CGFloat)length
{
    NSString* line = [NSString stringWithFormat:@"---------------"];
    UIFont* font= [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGSize size = [line sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect rect = CGRectMake(10, y, size.width,size.height);
    
    UILabel* label = [[UILabel alloc] init];
    [label setFrame:rect];
    [label setText:line];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByCharWrapping];
    [label setBackgroundColor:[UIColor clearColor]];
    return label;
    
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
/****************************************************************
 *
 ****************************************************************/
+ (UITextField*)makeTextField:(NSString*)text tgt:(id)obj
{
    return [self makeTextFieldWithKbType:UIKeyboardTypeDefault text:text tgt:obj];
}

/****************************************************************
 *
 ****************************************************************/
+ (UITextField*)makeTextFieldDec:(NSString*)text tgt:(id)obj
{
    return [self makeTextFieldWithKbType:UIKeyboardTypeDecimalPad text:text tgt:obj];
}

/****************************************************************
 *
 ****************************************************************/
+ (UITextField*)makeTextFieldNum:(NSString*)text tgt:(id)obj
{
    return [self makeTextFieldWithKbType:UIKeyboardTypeNumberPad text:text tgt:obj];
}

/****************************************************************
 *
 ****************************************************************/
+ (UITextField*)makeTextFieldWithKbType:(UIKeyboardType)kbtype text:(NSString*)text tgt:(id)obj
{
    
    UITextField* textField= [[UITextField alloc] init];
    [textField setText:text];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    [textField setKeyboardAppearance:UIKeyboardAppearanceDefault];
    [textField setKeyboardType:kbtype];
    [textField setReturnKeyType:UIReturnKeyDone];
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    textField.textAlignment = NSTextAlignmentCenter;
    

	// ボタンを配置するUIViewを作成
	UIView* accessoryView =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,44)];
	accessoryView.backgroundColor = [UIColor whiteColor];
    
	// ボタンを作成
	UIButtonWithObj* button = [UIButtonWithObj buttonWithType:UIButtonTypeRoundedRect];
    
    UIFont* font= [UIFont systemFontOfSize:[UIFont labelFontSize]];
    NSString *title = [NSString stringWithFormat:@"完了"];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat width_obj = ((UIViewController *)obj).view.bounds.size.width;
    CGFloat width_btn = size.width*2;
    CGRect rect = CGRectMake( width_obj - width_btn - 20 , 7, width_btn, size.height*1.4);
	
    [button setFrame:rect];
    [button setTitle:title forState:UIControlStateNormal];
    
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = button.frame.size.height/4.0;
    
    button.layer.shadowOpacity = 0.2;
    button.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    
    
    button.textField = textField;
    
	// ボタンを押したときに呼ばれる動作を設定
	[button addTarget:obj action:@selector(closeKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
	// ボタンをViewに追加
	[accessoryView addSubview:button];
    
	// ビューをUITextFieldのinputAccessoryViewに設定
	textField.inputAccessoryView = accessoryView;
    
    
    return textField;
}

/****************************************************************
 *
 ****************************************************************/
+ (void)setTextField:(UITextField*)textField x:(CGFloat)x y:(CGFloat)y length:(CGFloat)length
{
    [textField setFrame:CGRectMake(x,y,length, 30)];
    return;
}

/****************************************************************
 *
 ****************************************************************/
+ (void)setTitleTextField:(UITextField*)textField x:(CGFloat)x y:(CGFloat)y  viewWidth:(CGFloat)viewWidth
{
    UIFont* font= [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGSize size = [textField.text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect rect = CGRectMake(x, y+size.height*0.1, viewWidth-2*x,size.height*1.8 );
    [textField setFrame:rect];
    [textField setBackgroundColor:[UIColor  colorWithRed:84/255.f green:190/255.f blue:146/255.f alpha:1.0]]; //wakatake iro
    return;
}

/****************************************************************
 *
 ****************************************************************/
+(void)closeKeyboard:(id)sender
{
    UIButtonWithObj *btn = (UIButtonWithObj*)sender;
    [btn.textField resignFirstResponder];
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
/****************************************************************
 *
 ****************************************************************/
+ (UIButton*)makeButton:(NSString*)text tag:(int)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTag:tag];

    UIFont* font= [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat frame_size_height = size.height*1.4;
    button.layer.cornerRadius = frame_size_height /4.0;
    
    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    button.layer.borderWidth = 1.0f;
    
    button.layer.shadowOpacity = 0.2;
    button.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    return button;
}
/****************************************************************
 *
 ****************************************************************/
+ (void)setButton:(UIButton*)button x:(CGFloat)x y:(CGFloat)y length:(CGFloat)length
{
    NSString *text = [NSString stringWithFormat:@"aaa"];

    UIFont *font= [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];

    CGRect rect = CGRectMake(x, y, length,size.height*1.4);
    [button setFrame:rect];
    return;
}

/****************************************************************
 *
 ****************************************************************/
+ (void)setTextButton:(UIButton*)button x:(CGFloat)x y:(CGFloat)y length:(CGFloat)length
{
    NSString *text = [NSString stringWithFormat:@"aaa"];

    UIFont* font= [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];

    CGRect rect = CGRectMake(x, y, length,size.height*1.5);
    [button setFrame:rect];

    
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]*0.9]];

    CGFloat frame_size_height = size.height*1.4;
    button.layer.cornerRadius = frame_size_height /5.0;
    button.layer.borderWidth = 0.5f;
    button.layer.shadowOpacity = 0;
    
}
/****************************************************************
 *
 ****************************************************************/
+ (void)setTitleButton:(UIButton*)button x:(CGFloat)x y:(CGFloat)y viewWidth:(CGFloat)viewWidth
{
    UIFont* font= [UIFont systemFontOfSize:[UIFont labelFontSize]];
    CGSize size = [button.titleLabel.text  sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect rect = CGRectMake(x, y+size.height*0.1, viewWidth-2*x,size.height*1.8 );
    [button setFrame:rect];
    [button setBackgroundColor:[UIColor  colorWithRed:84/255.f green:190/255.f blue:146/255.f alpha:1.0]]; //wakatake iro

    
    return;
}

/****************************************************************
 *
 ****************************************************************/
+ (UILabel*)labelYen:(UILabel*)label yen:(NSInteger)yen
{
    label.text = [self yenValue:yen];
    if ( yen < 0 ){
        label.textColor = [UIColor redColor];
    } else {
        label.textColor = [UIColor blackColor];
    }
    return label;
}

/****************************************************************
 *
 ****************************************************************/
+ (NSInteger)getThisYear
{
    NSCalendar          *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents    *comp = [calender components:NSCalendarUnitYear fromDate:[NSDate date]];
    return comp.year;
}
/****************************************************************
 *
 ****************************************************************/
+ (NSInteger)getThisMonth
{
    NSCalendar          *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents    *comp = [calender components:NSCalendarUnitMonth fromDate:[NSDate date]];
    return comp.month;
}
/****************************************************************
 *
 ****************************************************************/
+ (NSInteger)getThisDay
{
    NSCalendar          *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents    *comp = [calender components:NSCalendarUnitDay fromDate:[NSDate date]];
    return comp.day;
}

/****************************************************************
 *
 ****************************************************************/
+ (NSInteger)getMaxDay_year:(NSInteger)year month:(NSInteger)month
{
    NSInteger maxDay;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            maxDay = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            maxDay = 30;
            break;
        case 2:
            if ( year % 4 == 0 ){
                if ( year % 100 == 0 ){
                    if ( year % 400 == 0){
                        maxDay = 28;
                    } else {
                        maxDay = 29;
                    }
                } else {
                    maxDay = 29;
                }
            } else {
                maxDay = 28;
            }
            break;
        default:
            maxDay = 0;
            break;
    }
    return maxDay;
}


/****************************************************************
 *
 ****************************************************************/
+ (NSString*)getJpnYear:(NSInteger)year
{
    if ( year > 1989 ){
        return [NSString stringWithFormat:@"平成%2d年",(int)year- 1988];
    } else if ( year == 1989 ){
        return [NSString stringWithFormat:@"平成元年"];
    } else if (year > 1926 ){
        return [NSString stringWithFormat:@"昭和%2d年",(int)year- 1925];
    } else if (year == 1926 ){
        return [NSString stringWithFormat:@"昭和元年"];
    } else if (year > 1912 ){
        return [NSString stringWithFormat:@"大正%2d年",(int)year- 1911];
    } else if (year == 1911 ){
        return [NSString stringWithFormat:@"大正元年"];
    } else {
        return [NSString stringWithFormat:@"明治%2d年",(int)year- 1867];
    }
}
/****************************************************************
 *
 ****************************************************************/
+(NSString*)yenValue:(NSInteger)yen
{
    NSInteger yen_tmp;
    if ( yen >= 0 ){
        yen_tmp = yen;
    }else {
        yen_tmp = -yen;
    }

    NSMutableString* str;
    NSMutableString* str_tmp;

    str = [NSMutableString stringWithString:@""];
    while (1) {
        if ( (yen_tmp /1000) > 0 ){
            str_tmp = [NSMutableString stringWithFormat:@",%03ld",(long)yen_tmp%1000];
            [str_tmp appendString:str];
            str = str_tmp;
        } else {
            str_tmp = [NSMutableString stringWithFormat:@"%d",(int)yen_tmp%1000];
            [str_tmp appendString:str];
            str = str_tmp;
            break;
        }
        yen_tmp = yen_tmp /1000;
    }
    if ( yen < 0 ){
        str_tmp = [NSMutableString stringWithString:@"-"];
        [str_tmp appendString:str];
        str = str_tmp;
    }
    
    return str;
}

/****************************************************************
 *
 ****************************************************************/
+ (NSString*)localedPrice:(NSNumber*)price locale:(NSLocale *)locale
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:locale];
    NSString *localedPrice = [numberFormatter stringFromNumber:price];
    return localedPrice;
}

/****************************************************************
 *
 ****************************************************************/
+(SVSegmentedControl*)makeSegmentedControl_x:(CGFloat)x y:(CGFloat)y length:(CGFloat)len array:(NSArray*)arr
{

    SVSegmentedControl *sc = [[SVSegmentedControl alloc]initWithSectionTitles:arr];
    sc.frame = CGRectMake( x, y, len,30);
    return sc;
}
/****************************************************************
 *
 ****************************************************************/
+(NSString*)fixString:(NSString*)str length:(NSInteger)length
{
    NSInteger orgLen = [str length];

    NSString* retStr = [[@"" stringByPaddingToLength:length-orgLen withString:@" " startingAtIndex:0]
                        stringByAppendingString:str];
    return retStr;
    
}
/****************************************************************
 *
 ****************************************************************/
+ (UIScrollView*)makeScrollView:(CGRect)rect  xpage:(CGFloat)xpage ypage:(NSInteger)ypage tgt:(id)obj
{
    UIScrollView *scrollView;
    // UIScrollViewのインスタンス化
    scrollView = [[UIScrollView alloc]init];
    
    // 横スクロールのインジケータを非表示にする
    scrollView.showsHorizontalScrollIndicator = NO;
    
    // ページングを有効にする
    scrollView.pagingEnabled = NO;
    
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = obj;
    scrollView.frame = rect;
    
    // スクロールの範囲を設定
    [scrollView setContentSize:CGSizeMake(rect.size.width*xpage, rect.size.height*ypage)];
    
    return scrollView;
}

/****************************************************************
 *
 ****************************************************************/
+ (UITextView*)makeTextView_x:(CGFloat)x y:(CGFloat)y width:(CGFloat)w height:(CGFloat)
h
{
    UITextView *tv     = [[UITextView alloc]init];
    CGRect rect = CGRectMake(x, y,w,h );
//    [tv setFont:font];
    [tv setFrame:rect];
//    [tv setEditable:editable];
    return tv;
    
}
/****************************************************************
 *
 ****************************************************************/
+ (CGRect)mergin_rect:(CGRect)rect top:(CGFloat)top bottom:(CGFloat)bottom left:(CGFloat)left right:(CGFloat)right
{
    CGFloat origin_x;
    CGFloat origin_y;
    CGFloat size_width;
    CGFloat size_height;
    
    if ( top    < 0 )   top     = 0;
    if ( bottom < 0 )   bottom  = 0;
    if ( left   < 0 )   left    = 0;
    if ( right  < 0 )   right   = 0;
    
    origin_x    = rect.origin.x     + left;
    origin_y    = rect.origin.y     + top;
    size_width  = rect.size.width   - left - right;
    size_height = rect.size.height  - top - bottom;

    if ( size_width  < 0 )  size_width = 1;
    if ( size_height < 0 )  size_height = 1;

    return CGRectMake(origin_x, origin_y, size_width, size_height);
}
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************
 * Color イエロー
 ****************************************************************/
+ (UIColor*)color_Yellow
{
    return [UIColor  colorWithRed:1.0 green:1.0 blue:0.00 alpha:1.0];
}
/****************************************************************
 * Color ライトイエロー
 ****************************************************************/
+ (UIColor*)color_LightYellow
{
    return [UIColor  colorWithRed:1.0 green:1.0 blue:0.88 alpha:1.0];
}
/****************************************************************
 * Color アイボリー
 ****************************************************************/
+ (UIColor*)color_Ivory
{
    return [UIColor  colorWithRed:221/255.f green:222/255.f blue:211/255.f alpha:1.0];
}
/****************************************************************
 * Color 若竹色
 ****************************************************************/
+ (UIColor*)color_WakatakeIro
{
    return [UIColor  colorWithRed:84/255.f green:190/255.f blue:146/255.f alpha:1.0];
}

/****************************************************************
 * Color 薄炭色
 ****************************************************************/
+ (UIColor*)color_UsusumiIro
{
    return [UIColor  colorWithRed:158/255.f green:158/255.f blue:158/255.f alpha:1.0];
}


@end
/****************************************************************/
