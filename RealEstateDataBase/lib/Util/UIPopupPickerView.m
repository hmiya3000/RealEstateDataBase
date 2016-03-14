//
//  UIPopupPickerView.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/17.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "UIPopupPickerView.h"
#import "UIUtil.h"
#import "Pos.h"


@interface UIPopupPickerView ()
{
    UILabel             *_l_bg;
    UIPickerView        *_pv;
    UIButton            *_btn_cancel;
    
    Pos                 *_pos;
    
    
    CGRect              _frame;
    id                  _target;
    NSInteger           _numRow;
    NSInteger           _numComponent;
}
@end

#define BTAG_CANCEL     1

@implementation UIPopupPickerView

/****************************************************************
 * ポップアップ作成
 ****************************************************************/
- (void)makePopup:(CGRect)frame tgt:(id)target
{
    _target         = target;
    _frame          = frame;
    self.title  = @"PickerView";
//    self.view.backgroundColor = [UIUtil color_LightYellow];
    self.view.backgroundColor = [UIUtil color_UsusumiIro];

}
/****************************************************************
 * PickerViewをポップアップする
 ****************************************************************/
- (void)showPickerView:(UIView*)view
{
    [_target presentViewController:self animated:YES completion:nil];
    
}
/****************************************************************
 *　ポップアップを閉じる
 ****************************************************************/
- (BOOL)closePopup:(id)sender
{
    if (_target != nil){
        [_target closePopup:sender];
    }
    return YES;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _l_bg = [UIUtil makeLabel:@""];
    [self.view addSubview:_l_bg];
    
    _pv   = [[UIPickerView alloc]init ];
    [_pv setBackgroundColor:[UIColor whiteColor]];
    [_pv setDelegate:self];
    [_pv setShowsSelectionIndicator:YES];
    [self.view addSubview:_pv];

    _btn_cancel = [UIUtil makeButton:@"Cancel" tag:BTAG_CANCEL];
    [_btn_cancel addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_cancel];
    
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    
    
    [self viewMake];
}

/****************************************************************
 *
 ****************************************************************/
- (void) viewMake
{
    CGFloat pos_x,pos_y,dx,dy,length,length30;
    _pos        = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    length30    = _pos.len30;
    if ( _pos.isPortrait == true ){

        pos_y = _pos.y_btm -230-dy;
        [UIUtil setRectLabel:_l_bg x:0 y:pos_y viewWidth:_pos.frame.size.width viewHeight:_pos.frame.size.height color:[UIUtil color_LightYellow]];
        pos_y = pos_y+dy;
        [_pv setFrame:CGRectMake(pos_x, pos_y, length30, _pos.y_btm - pos_y -dy)];
        pos_y = _pos.y_btm - dy;
        [UIUtil setButton:_btn_cancel x:pos_x y:pos_y length:length30];
    }
    [self rewriteProperty];
}
/****************************************************************
 * 回転処理の許可
 ****************************************************************/
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //    NSLog(@"%s",__FUNCTION__);
    return UIInterfaceOrientationMaskPortrait;
    //return UIInterfaceOrientationMaskAll;
}

/****************************************************************
 *
 ****************************************************************/
- (void) rewriteProperty
{
    return;
}

/****************************************************************
 * ビューがタップされたとき
 ****************************************************************/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [self pickedData:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_CANCEL ){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return;
}

/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/

/****************************************************************
 * 指定した列の行番号を設定する
 ****************************************************************/
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_pv selectRow:row inComponent:component animated:YES];
}

/****************************************************************
 * 指定した列で選択された行番号を返す
 ****************************************************************/
- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [_pv selectedRowInComponent:component];
}

/****************************************************************
 *　行数の高さ指定
 ****************************************************************/
-(CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

/****************************************************************
 * 取得データ決定：継承先でオーバーライド
 ****************************************************************/
- (void)pickedData:(id)sender
{
    [self closePopup:sender];
    return;
}

/****************************************************************
 *　行数設定：継承先でオーバーライド
 ****************************************************************/
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

/****************************************************************
 * 列数設定：継承先でオーバーライド
 ****************************************************************/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return _numRow;
}

/****************************************************************
 *　行数取得：継承先でオーバーライド
 ****************************************************************/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    return;
}

/****************************************************************
 * 表示する内容を返す：継承先でオーバーライド
 ****************************************************************/
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d",(int)row];
}

/****************************************************************/
@end
/****************************************************************/
