//
//  AddonViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/02.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "AddonViewCtrl.h"
#import "UIUtil.h"
#import "GridTable.h"
#import "Pos.h"
#import "AddonMgr.h"

@interface AddonViewCtrl ()
{
    UIPickerView        *_pv;
    NSInteger           _selectIdx;
    Pos                 *_pos;
    AddonMgr            *_addonMgr;

    UIScrollView        *_scrollView;
    UIView              *_uv_grid;
    UITextView          *_tv_comment;
    
    SKProductsRequest   *_productRequest;
    SKProduct           *_product;

}


@end

@implementation AddonViewCtrl

#define ADDON_COMMENT @"■複数年分析\n家賃下落を踏まえて数年に渡っての運営シミュレーションを行います\n\n■運営設定\n家賃下落率や空室率、税率等を詳細に設定できます\n\n■売却分析\n設定した保有期間後に売却した場合のシミュレーションを行います\n\n■データベース\n複数の物件データを保存できます\n\n■外部データ\n物件データをDropboxを使ってインポート・エクスポートできます\n"
#define PRODUCT_ID @"upgrade_FreeToLite"
/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self) {
        self.title  = @"アドオン購入";
        self.view.backgroundColor = [UIUtil color_LightYellow];
    }
    return self;
}


/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *retButton =
    [[UIBarButtonItem alloc] initWithTitle:@"戻る"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(retButtonTapped:)];
    self.navigationItem.leftBarButtonItem = retButton;

    
    /****************************************/
    _addonMgr   = [AddonMgr sharedManager];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _uv_grid = [GridTable makeGridTable];
    [_scrollView addSubview:_uv_grid];
    /****************************************/
    _tv_comment                = [[UITextView alloc]init];
    _tv_comment.editable       = false;
    _tv_comment.scrollEnabled  = true;
    _tv_comment.backgroundColor = [UIUtil color_LightYellow];
    _tv_comment.text           = ADDON_COMMENT;
    [_scrollView addSubview:_tv_comment];
    /****************************************/
//    _pv   = [[UIPickerView alloc]init];
    [_pv setBackgroundColor:[UIColor whiteColor]];
    [_pv setDelegate:self];
    [_pv setDataSource:self];
    [_pv setShowsSelectionIndicator:YES];
    _selectIdx = _addonMgr.appMode;
    [_pv selectRow:_selectIdx inComponent:0 animated:NO];
    [_scrollView addSubview:_pv];
    
    

    _product    = nil;
    
    NSSet *productIds   = [NSSet setWithObject:PRODUCT_ID];
    _productRequest     = [[SKProductsRequest alloc]initWithProductIdentifiers:productIds];
    _productRequest.delegate    = self;
    [_productRequest start];
    
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self rewriteProperty];
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
    [GridTable setRectScroll:_uv_grid rect:CGRectMake(_pos.x_left, pos_y, length30, dy*3)];
    pos_y = pos_y + 3.5*dy;
    _tv_comment.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*4);
    if ( _pos.isPortrait == true ){
        [_pv setFrame:CGRectMake(_pos.x_left,   _pos.y_btm - 300, _pos.len30, 216)];
    } else {
        [_pv setFrame:CGRectMake(_pos.x_center, _pos.y_btm - 250, _pos.len15, 216)];
    }
    /****************************************/
    return;
}

/****************************************************************
 *
 ****************************************************************/
-(void)rewriteProperty
{
    [GridTable setScroll:_uv_grid table:[_addonMgr getAddonArray]];
}
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
- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    if (response == nil ){
        //アプリ内課金プロダクトを取得できなかった
        return;
    }
    /****************************************/
    for( NSString *identifier in response.invalidProductIdentifiers ){
        NSLog(@"invalidProductIdentifiers : %@",identifier);
    }
    /****************************************/
    for ( SKProduct *tmp_product in response.products ){
        NSLog( @"Product : %@ %@ %@ %d",
              tmp_product.productIdentifier,
              tmp_product.localizedTitle,
              tmp_product.localizedDescription,
              [tmp_product.price intValue]  );
        _product = tmp_product;
    }
    if ( _product == nil ){
        //商品情報が取れなかった
        return;
    }
    /****************************************/
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:_product.priceLocale];
    NSString *localedPrice = [numberFormatter stringFromNumber:_product.price];
    
    
    
    
}
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
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
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
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
    return 4;
}
/****************************************************************
 * 表示する内容を返す
 ****************************************************************/
-(NSString*)pickerView:(UIPickerView*)pickerView
           titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_addonMgr getStrAppMode:row];
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
    switch (_selectIdx) {
        case APP_FREE:
            [_addonMgr setAppModeFree];
            break;
        case APP_LITE:
            [_addonMgr setAppModeLite];
            break;
        case APP_STANDALONE:
            [_addonMgr setAppModeStandAlone];
            break;
        case APP_NETWORK:
            [_addonMgr setAppModeNetwork];
            break;
        default:
            break;
    }
    return;
}



/****************************************************************/
@end
/****************************************************************/
