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
#import "UIUtil.h"
#import "AddonMgr.h"
#import "MBProgressHUD.h"

@interface AddonViewCtrl ()
{
    UIPickerView        *_pv;
    NSInteger           _selectIdx;
    Pos                 *_pos;
    AddonMgr            *_addonMgr;

    UIScrollView        *_scrollView;
    UIView              *_uv_grid;
    UITextView          *_tv_comment;

    UILabel             *_l_restore;
    UIButton            *_b_restore;
    UITextView          *_tv_restore;
    
    NSMutableArray      *_arr_pname;
    NSMutableArray      *_arr_pprice;
    NSMutableArray      *_arr_description;
    
//    SKProductsRequest   *_productRequest;

    NSMutableArray      *_arrProductRequest;
//    NSMutableArray      *_arrProduct;
    NSArray             *_arrProduct;
    
    NSTimer             *_timeOut;
}


@end

@implementation AddonViewCtrl
/****************************************************************/

#define ADDON_COMMENT @"■複数年分析\n家賃下落を踏まえて数年に渡っての運営シミュレーションを行います\n\n■運営設定\n家賃下落率や空室率、税率等を詳細に設定できます\n\n■売却分析\n設定した保有期間後に売却した場合のシミュレーションを行います\n\n■データベース\n複数の物件データを保存できます\n\n■外部データ\n物件データをDropboxを使ってインポート・エクスポートできます\n"
/****************************************************************/
#define BTAG_RESTORE    255
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
    NSArray *arrProductIds;
    arrProductIds   = [_addonMgr getProductIds:_addonMgr.appMode];
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
    if ( _addonMgr.friendMode == true ){
        _pv   = [[UIPickerView alloc]init];
        [_pv setBackgroundColor:[UIColor whiteColor]];
        [_pv setDelegate:self];
        [_pv setDataSource:self];
        [_pv setShowsSelectionIndicator:YES];
        _selectIdx = _addonMgr.appMode;
        [_pv selectRow:_selectIdx inComponent:0 animated:NO];
        [_scrollView addSubview:_pv];
    } else {
        _pv = nil;
        if ( [arrProductIds count] != 0 ){
            _l_restore  = [UIUtil makeLabel:@"購入情報リストア"];
            [_l_restore  setTextAlignment:NSTextAlignmentLeft];
            [_scrollView addSubview:_l_restore];
            /*--------------------------------------*/
            _b_restore  = [UIUtil makeButton:@"" tag:BTAG_RESTORE];
            [_b_restore addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:_b_restore];
            /*--------------------------------------*/
            _tv_restore = [[UITextView alloc]init];
            _tv_restore.editable       = false;
            _tv_restore.scrollEnabled  = true;
            _tv_restore.backgroundColor = [UIColor whiteColor];
            _tv_restore.text           = @"一度購入した購入情報が消えてしまった場合や他機種で購入した情報を反映させる場合に実行してください.復元する情報がない場合には何も起きません";
            [_scrollView addSubview:_tv_restore];
        }
        /****************************************/
        _arr_pname          = [NSMutableArray array];
        _arr_pprice         = [NSMutableArray array];
        _arr_description    = [NSMutableArray array];
        for ( int i=0; i<[arrProductIds count]; i++ ){
            /*--------------------------------------*/
            UILabel *l_pname = [UIUtil makeLabel:@""];
            [l_pname  setTextAlignment:NSTextAlignmentLeft];
            [_scrollView addSubview:l_pname];
            [_arr_pname addObject:l_pname];
            /*--------------------------------------*/
            UIButton *b_pprice = [UIUtil makeButton:@"" tag:i];
            [b_pprice addTarget:self action:@selector(clickButtonPurchase:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:b_pprice];
            [_arr_pprice addObject:b_pprice];
            /*--------------------------------------*/
            UITextView *tv_description = [[UITextView alloc]init];
            tv_description.editable       = false;
            tv_description.scrollEnabled  = true;
            tv_description.backgroundColor = [UIColor whiteColor];
            tv_description.text           = @"";
            [_scrollView addSubview:tv_description];
            [_arr_description addObject:tv_description];
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startProductRequest];
        
    }
    return;
}

/****************************************************************
 * Viewの表示前に呼ばれる
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //AppDelegateからの購入通知を登録する
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchased:)       name:@"Purchased"     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionEnd:)  name:@"PurchasedAll"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionEnd:)  name:@"RestoreOK"     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transactionEnd:)  name:@"RestoreNG"     object:nil];
    
    [self rewriteProperty];
    [self viewMake];
}
/****************************************************************
 * Viewの非表示前に呼ばれる
 ****************************************************************/
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    //AppDelegateからの購入通知を解除する
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Purchased"     object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PurchasedAll"  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RestoreOK"     object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RestoreNG"     object:nil];
    return;
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
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        if ( _pos.isPortrait == true ){
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2);
        } else {
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*2.9);
        }
        _scrollView.bounces = YES;
    } else {
    }
    /****************************************/
    pos_y = 0.2*dy;
    [GridTable setRectScroll:_uv_grid rect:CGRectMake(_pos.x_left, pos_y, length30, dy*3)];
    pos_y = pos_y + 3.5*dy;
    _tv_comment.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*4);
    /****************************************/
    pos_y = pos_y + 4*dy;
    /****************************************/
    if ( _addonMgr.friendMode == true ){
        pos_y = pos_y + dy;
        [_pv setFrame:CGRectMake(_pos.x_left,   pos_y, _pos.len30, 216)];
    } else {
        /****************************************/
        [UIUtil setRectLabel:_l_restore x:pos_x         y:pos_y viewWidth:length*2 viewHeight:dy color:[UIUtil color_Yellow]];
        [UIUtil setButton:_b_restore    x:pos_x+2*dx    y:pos_y length:length ];
        pos_y = pos_y + dy;
        _tv_restore.frame = CGRectMake(pos_x, pos_y, length30, dy*2);
        /****************************************/
        pos_y = pos_y + dy;
        for( int i=0; i<[_arr_pname count]; i++ ){
            UILabel     *l_pname        = [_arr_pname       objectAtIndex:i];
            UIButton    *b_pprice       = [_arr_pprice      objectAtIndex:i];
            UITextView  *tv_description = [_arr_description objectAtIndex:i];
            pos_y = pos_y + dy;
            [UIUtil setRectLabel:l_pname x:pos_x y:pos_y viewWidth:length*2 viewHeight:dy color:[UIUtil color_Yellow]];
            [UIUtil setButton:b_pprice x:pos_x+2*dx y:pos_y length:length ];
            pos_y = pos_y + dy;
            tv_description.frame = CGRectMake(pos_x, pos_y, length30, dy*2);
            pos_y = pos_y + 1*dy;
        }
    }
    return;
}

/****************************************************************
 *
 ****************************************************************/
-(void)rewriteProperty
{
    [GridTable setScroll:_uv_grid table:[_addonMgr getAddonArray]];


    int i=0;
    for (SKProduct *tmp_product in _arrProduct ) {
        if ( tmp_product != nil ){
            UILabel *l_pname            = [_arr_pname       objectAtIndex:i];
            UIButton *b_pprice          = [_arr_pprice      objectAtIndex:i];
            UITextView *tv_description  = [_arr_description objectAtIndex:i];
            l_pname.text    = [NSString stringWithFormat:@"%@",tmp_product.localizedTitle];
            [b_pprice setTitle:[self localedPrice:tmp_product] forState:UIControlStateNormal];
            tv_description.text = tmp_product.localizedDescription;
            i++;
            [_b_restore setTitle:[UIUtil localedPrice:[NSNumber numberWithInteger:0] locale:tmp_product.priceLocale] forState:UIControlStateNormal];
        }
    }
    if ( [_arrProductRequest count] == [_arrProduct count] ){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_timeOut invalidate];
    }
    
    
    return;
    
}
/****************************************************************/
- (NSString*)localedPrice:(SKProduct*)product
{
    return [UIUtil localedPrice:product.price locale:product.priceLocale];
}
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************
 * 購入情報取得の開始
 ****************************************************************/
- (void) startProductRequest
{
    NSArray *arrProductId;
    arrProductId        = [_addonMgr getProductIds:_addonMgr.appMode];
    _arrProduct         = nil;
    _addonMgr.products  = nil;
    
    _arrProductRequest  = [NSMutableArray array];
    for (NSString *pid in arrProductId ) {
        NSSet *productIds   = [NSSet setWithObject:pid];
        SKProductsRequest *productReq;
        productReq      = [[SKProductsRequest alloc]initWithProductIdentifiers:productIds];
        productReq.delegate    = self;
        [productReq start];
        [_arrProductRequest addObject:productReq];
    }
    _timeOut = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(timeoutOfGetProductRequest:) userInfo:nil repeats:NO];
    return;
}

/****************************************************************
 * 購入情報取得の応答
 ****************************************************************/
- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct           *product;
    product    = nil;
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
        product = tmp_product;
    }

    /****************************************/
    if ( product != nil ){
        //ちゃんと商品情報が取れた
        [_addonMgr addProduct:product];
        _arrProduct = _addonMgr.products;
        [self rewriteProperty];
    }
    
}

/****************************************************************
 * プロダクト取得でタイムアウトした
 ****************************************************************/
- (void) timeoutOfGetProductRequest:(NSTimer*)timer
{
    [_timeOut invalidate];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *al_timeout;
    al_timeout = [UIAlertController alertControllerWithTitle:@"通信タイムアウト"
                                                    message:@"Apple Storeとの通信ができませんでした.再度実行してください"
                                             preferredStyle:UIAlertControllerStyleAlert];
    [al_timeout addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //何もしない
    }]];
    [self presentViewController:al_timeout animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}

/****************************************************************
 * 購入手続き完了時に呼ばれる
 ****************************************************************/
- (void) purchased:(NSNotification*)notification
{
//    NSLog(@"Purchased call");
    return;
    
}
/****************************************************************
 * すべての購入・リストア手続き完了時に呼ばれる
 ****************************************************************/
- (void) transactionEnd:(NSNotification*)notification
{
    [_addonMgr loadAddons];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}

/****************************************************************
 * 購入ボタン押下時に呼ばれる
 ****************************************************************/
-(void)clickButtonPurchase:(UIButton*)sender
{
    if ( [SKPaymentQueue canMakePayments] == NO ){
        UIAlertController *al_purchase;
        al_purchase = [UIAlertController alertControllerWithTitle:@"購入できません"
                                                         message:@"App内の購入が機能制限されています"
                                                  preferredStyle:UIAlertControllerStyleAlert];
        [al_purchase addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //何もしない
        }]];
        [self presentViewController:al_purchase animated:YES completion:nil];
        return;
    }
    SKProduct *tgtProduct = [_addonMgr.products objectAtIndex:sender.tag];
    if ( tgtProduct != nil ){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SKPayment *payment = [SKPayment paymentWithProduct:tgtProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}

/****************************************************************
 * ボタン押下時に呼ばれる
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    return;
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
