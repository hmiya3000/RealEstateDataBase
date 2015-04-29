//
//  InputTaxRateViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/03/29.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "InputTaxRateViewCtrl.h"

@interface InputTaxRateViewCtrl ()
{
    UILabel         *_l_taxRate;
    UITextView      *_tv_tips;
    UIPickerView    *_pv;
    NSInteger       _selectIdx;
}


@end

@implementation InputTaxRateViewCtrl
/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"所得税・住民税";
    
    /****************************************/
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_taxRate    = [UIUtil makeLabel:[self getTaxStr:[self getIdx_taxRate:_modelRE.investment.incomeTaxRate]]];
    [_scrollView addSubview:_l_taxRate];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = @"課税所得を参考に税率を選択してください\n\n課税所得は給与所得や他の物件など所得の合計に医療費・社会保険料控除を差し引いて決まり、所得税は課税所得に対して一定額を控除した額に対して税率を掛けて決まります\nこのように税額は物件単独で決まらないため、このアプリでは物件の利益に設定した税率を掛けて税額を算出しています";
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _pv   = [[UIPickerView alloc]init];
    [_pv setBackgroundColor:[UIColor whiteColor]];
    [_pv setDelegate:self];
    [_pv setDataSource:self];
    [_pv setShowsSelectionIndicator:YES];
    
    _selectIdx = [self getIdx_taxRate:_modelRE.investment.incomeTaxRate];
    [_pv selectRow:_selectIdx inComponent:0 animated:NO];
    [_scrollView addSubview:_pv];
    
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewMake];
}
/****************************************************************
 *
 ****************************************************************/
- (void)viewMake
{
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,lengthR,length30;
    _pos = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    length30    = _pos.len30;
    /****************************************/
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0.2*dy;
    if ( _pos.isPortrait == true ){
        [UIUtil setRectLabel:_l_taxRate   x:pos_x y:pos_y viewWidth:_pos.len30 viewHeight:dy color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*2);
        [_pv setFrame:CGRectMake(_pos.x_left,   _pos.y_btm - 300, _pos.len30, 300)];
    } else {
        [UIUtil setRectLabel:_l_taxRate   x:pos_x y:pos_y viewWidth:_pos.len15 viewHeight:dy color:[UIUtil color_Ivory] ];
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*2);
        [_pv setFrame:CGRectMake(_pos.x_center, _pos.y_btm - 250, _pos.len15, 250)];
    }
    /****************************************/
    return;
}


/****************************************************************
 * ビューがタップされたとき
 ****************************************************************/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    //    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
}

/****************************************************************
 * 回転時に処理したい内容
 ****************************************************************/
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self viewMake];
    return;
}
/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    _modelRE.investment.incomeTaxRate = [self getTaxRate_idx:_selectIdx];
    //    _modelRE.estate.house.construct = (int)_selectIdx;
    [_modelRE valToFile];
    
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

/****************************************************************/

/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************
 * 列数設定
 ****************************************************************/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
/****************************************************************
 *　行数設定
 ****************************************************************/
-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 8;
}
/****************************************************************
 * 表示する内容を返す
 ****************************************************************/
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str;
    switch (row) {
        case 0:
            str = @"15%(個人事業:1000円〜194.9万円)";
            break;
        case 1:
            str = @"20%(個人事業:195万円〜329.9万円)";
            break;
        case 2:
            str = @"30%(個人事業:330万円〜694.9万円)";
            break;
        case 3:
            str = @"33%(個人事業:695万円〜899.9万円)";
            break;
        case 4:
            str = @"43%(個人事業:900万円〜1799.9万円)";
            break;
        case 5:
            str = @"50%(個人事業:1800万円〜)";
            break;
        case 6:
            str = @"32.3%(法人:〜800万円)";
            break;
        case 7:
            str = @"42.8%(法人:800万円〜)";
            break;
            
        default:
            break;
    }
    return str;
}
/****************************************************************
 *　行数の高さ指定
 ****************************************************************/
-(CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
/****************************************************************
 *　行数取得：継承先でオーバーライド
 ****************************************************************/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIdx             = row;
    _l_taxRate.text = [self getTaxStr:row];
    return;
}
/****************************************************************
 * 税率からIndexを取得
 ****************************************************************/
-(NSInteger)getIdx_taxRate:(CGFloat)taxRate
{
    NSInteger idx;
    if ( taxRate <= 0.16 ){
        idx = 0;
    } else if ( 0.16 < taxRate && taxRate <= 0.21 ){
        idx = 1;
    } else if ( 0.21 < taxRate && taxRate <= 0.31 ){
        idx = 2;
    } else if ( 0.31 < taxRate && taxRate <= 0.324 ){
        idx = 6;
    } else if ( 0.324 < taxRate && taxRate <= 0.34 ){
        idx = 3;
    } else if ( 0.34 < taxRate && taxRate <= 0.429 ){
        idx = 7;
    } else if ( 0.429 < taxRate && taxRate <= 0.44 ){
        idx = 4;
    } else if ( 0.44 < taxRate ){
        idx = 5;
    }
    return idx;
}

/****************************************************************
 * Indexから税率を取得
 ****************************************************************/
-(CGFloat)getTaxRate_idx:(NSInteger)idx
{
    CGFloat taxRate;
    switch (idx) {
        case 0:
            taxRate = 0.15;
            break;
        case 1:
            taxRate = 0.20;
            break;
        case 2:
            taxRate = 0.30;
            break;
        case 3:
            taxRate = 0.33;
            break;
        case 4:
            taxRate = 0.43;
            break;
        case 5:
            taxRate = 0.50;
            break;
        case 6:
            taxRate = 0.323;
            break;
        case 7:
            taxRate = 0.428;
            break;
        default:
            taxRate = 0.43;
            break;
    }
    return taxRate;
}

/****************************************************************
 *　Indexから税率文字列を取得する
 ****************************************************************/
-(NSString*)getTaxStr:(NSInteger)idx
{
    NSString *str;
    switch (idx) {
        case 0:
            str = @"15%=所得税:5%+住民税:10%";
            break;
        case 1:
            str = @"20%=所得税:10%+住民税:10%";
            break;
        case 2:
            str = @"30%=所得税:20%+住民税:10%";
            break;
        case 3:
            str = @"33%=所得税:23%+住民税:10%";
            break;
        case 4:
            str = @"43%=所得税:33%+住民税:10%";
            break;
        case 5:
            str = @"50%=所得税:40%+住民税:10%";
            break;
        case 6:
            str = @"32.3%=所得税:15%+住民税:17.3%";
            break;
        case 7:
            str = @"42.8%=所得税:25.5%+住民税:17.3%";
            break;
        default:
            break;
    }
    return str;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
