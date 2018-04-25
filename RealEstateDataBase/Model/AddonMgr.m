//
//  AddonMgr.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/02.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "AddonMgr.h"
#import "ViewMgr.h"


@implementation AddonMgr
{
}

//======================================================================
static AddonMgr* sharedAddonMgr = nil;
//======================================================================
@synthesize multiYear           = _multiYear;
@synthesize opeSetting          = _opeSetting;
@synthesize database            = _database;
@synthesize saleAnalysys        = _saleAnalysis;
@synthesize importExport        = _importExport;
@synthesize pdfOut              = _pdfOut;
@synthesize appMode             = _appMode;
@synthesize friendMode          = _friendMode;
//======================================================================
#define FRIEND_KEYWORD      @"yakinikudaijin"
//======================================================================
//
//======================================================================
+ (AddonMgr*)sharedManager
{
    @synchronized(self){
        if (sharedAddonMgr == nil ){
            sharedAddonMgr = [[self alloc ]init ];
        }
    }
    return sharedAddonMgr;
}
//======================================================================
//
//======================================================================
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if ( sharedAddonMgr == nil){
            sharedAddonMgr  = [super allocWithZone:zone];
            return sharedAddonMgr;
        }
    }
    return nil;
}
//======================================================================
//
//======================================================================
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}
//======================================================================
//
//======================================================================
/****************************************************************
 * 初期化
 ****************************************************************/
-(id)init
{
    self = [super init];
    if (self) {
        _appMode = [self loadAppMode];
        [self setAddons:_appMode];
        _products = nil;
    }
    return self;
}
//======================================================================
//
//======================================================================
/****************************************************************
 * NSUserDefaultsへProduct IDをsave
 ****************************************************************/
-(void)saveProductId:(NSString *)productId
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:productId];
    [ud synchronize];
}
//======================================================================
//
//======================================================================
/****************************************************************
 * NSUserDefaultsからアドオン情報をLoad
 ****************************************************************/
-(void)loadAddons
{
    NSInteger appMode = [self loadAppMode];
    [self setAddons:appMode];
}

//======================================================================
//
//======================================================================
/****************************************************************
 * NSUserDefaultsを初期化する.　テスト用
 ****************************************************************/
-(void)initializeAddons
{
    [self deleteProductId:APP_FREE];
    [self deleteProductId:APP_LITE];
    [self deleteProductId:APP_STANDALONE];
    [self deleteProductId:APP_NETWORK];
    [self deleteFriendMode];
    [self setAddons:_appMode];
}

//======================================================================
//
//======================================================================
/****************************************************************
 * FriendModeのアクティベート
 ****************************************************************/
-(void)activateFriend:(NSString*)keyword
{
    if ( [keyword isEqualToString:FRIEND_KEYWORD] == true ){
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:@"Activated" forKey:@"FriendMode"];
        [ud setInteger:_appMode forKey:@"FriendModeAppMode" ];
        [ud synchronize];
        _friendMode = true;
    } else {
        [self deleteFriendMode];
        _friendMode = false;
    }
}

//======================================================================
//
//======================================================================
-(void)setAppModeFree
{
    [self setAddons:APP_FREE];
}
//======================================================================
//
//======================================================================
-(void)setAppModeLite
{
    [self setAddons:APP_LITE];
}
//======================================================================
//
//======================================================================
-(void)setAppModeStandAlone
{
    [self setAddons:APP_STANDALONE];
}
//======================================================================
//
//======================================================================
-(void)setAppModeNetwork
{
    [self setAddons:APP_NETWORK];
}
//======================================================================
//
//======================================================================
-(NSString*)getStrAppMode:(NSInteger)appMode
{
    NSString *str;
    switch (appMode){
        case APP_FREE:
        default:
            str = @"AIREES Free";
            break;
        case APP_LITE:
            str = @"AIREES Lite";
            break;
        case APP_STANDALONE:
            str = @"AIREES Stand Alone";
            break;
        case APP_NETWORK:
            str = @"AIREES Network";
            break;
    }
    return str;
}

//======================================================================
//
//======================================================================
/****************************************************************
 * 対応リストを返す
 ****************************************************************/
-(NSArray*)getAddonArray
{
    
    NSMutableArray *addonList = [NSMutableArray array];
    NSArray *item;
    item = [NSArray arrayWithObjects:@"アドオン",@"複数年分析",@"運営設定",@"売却分析",@"データベース",@"外部データ",nil];
    [addonList addObject:item];
    
    item = [NSArray arrayWithObjects:@"Free",   @"×",       @"×",      @"×",     @"×",        @"×",                   nil];
    [addonList addObject:item];
    
    item = [NSArray arrayWithObjects:@"Lite",   @"◯",       @"◯",      @"×",     @"×",        @"×",                   nil];
    [addonList addObject:item];

    item = [NSArray arrayWithObjects:@"S.A.",   @"◯",       @"◯",      @"◯",     @"◯",        @"×",                   nil];
    [addonList addObject:item];
    
    item = [NSArray arrayWithObjects:@"Network",@"◯",       @"◯",      @"◯",     @"◯",        @"◯",                   nil];
    [addonList addObject:item];
    
    return addonList;
}

//======================================================================
//
//======================================================================
/****************************************************************
 * 購入可能なProductIDを返す
 ****************************************************************/
-(NSArray*)getProductIds:(NSInteger)appMode
{
    NSArray *arr;
    
    switch (appMode){
        case APP_FREE:
        default:
            arr = [NSArray arrayWithObjects:@"upgrade_FreeToLite",@"upgrade_FreeToSA",@"upgrade_FreeToNet",nil];
            break;
        case APP_LITE:
            arr = [NSArray arrayWithObjects:@"upgrade_LiteToSA",@"upgrade_LiteToNet",nil];
            break;
        case APP_STANDALONE:
            arr = [NSArray arrayWithObjects:@"upgrade_SAToNet",nil];
            break;
        case APP_NETWORK:
            arr = [NSArray arrayWithObjects:@"",nil];
            break;
    }
    return arr;
}
//======================================================================
//
//======================================================================
/****************************************************************
 * 取得したプロダクトを登録する
 ****************************************************************/
-(void)addProduct:(SKProduct*)addProduct
{
    NSMutableArray *tmpArr;
    tmpArr = [NSMutableArray array];
    
    NSArray *arrPid = [self getProductIds:_appMode];
    for( NSString* tgtPid in arrPid ){
        bool findflg = false;
        for ( SKProduct *orgProducts in _products ){
            if ( [tgtPid isEqualToString:orgProducts.productIdentifier] == true ){
                //目的のProductIdが元々のリストにあった
                [tmpArr addObject:orgProducts];
                findflg = true;
                break;
            }
        }
        if ( findflg == false && [tgtPid isEqualToString:addProduct.productIdentifier] == true ){
            //目的のProductIdが元々のリストにはなかったが、追加Productと一致した
            [tmpArr addObject:addProduct];
        }
    }
    _products = tmpArr;
    return;
}
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//
//======================================================================
-(NSInteger)loadAppMode
{
    NSInteger tmpAppMode = [self loadFriendMode];
    if ( _friendMode == false ){
        for(int i=0; i<APP_NETWORK;i++ ){
            tmpAppMode = [self readProductId:tmpAppMode];
            if ( tmpAppMode == APP_NETWORK ){
                break;
            }
        }
    }
    return tmpAppMode;
}

//======================================================================
//
//======================================================================
-(NSInteger)readProductId:(NSInteger)appMode
{
    NSInteger tmpAppMode = appMode;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arr_pid;
    
    arr_pid = [self getProductIds:appMode];
    for( int i=0; i< [arr_pid count]; i++ ){
        NSString *pid = [arr_pid objectAtIndex:i];
        if ( [ud boolForKey:pid] == true ){
            tmpAppMode = appMode + i+1;
        }
    }
    return tmpAppMode;
}

//======================================================================
//
//======================================================================
-(void)deleteProductId:(NSInteger)appMode
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *arr_pid;
    
    arr_pid = [self getProductIds:appMode];
    for( int i=0; i< [arr_pid count]; i++ ){
        NSString *pid = [arr_pid objectAtIndex:i];
        [ud removeObjectForKey:pid];
    }
}
//======================================================================
//
//======================================================================
-(NSInteger)loadFriendMode
{
    NSInteger loadAppMode;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ( [ud objectForKey:@"FriendMode"] != nil ){
        _friendMode = true;
        loadAppMode = [ud integerForKey:@"FriendModeAppMode"];

    } else {
        _friendMode = false;
        loadAppMode = APP_FREE;
    }
    return loadAppMode;
}

//======================================================================
//
//======================================================================
-(void)deleteFriendMode
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"FriendMode"];
    [ud removeObjectForKey:@"FriendModeAppMode"];
    return;
}
//======================================================================
//
//======================================================================
-(void)setAddons:(NSInteger)appMode
{
    
    if ( appMode != _appMode){
        ViewMgr *viewMgr    = [ViewMgr sharedManager];
        viewMgr.reqViewInit = true;
        _products           = nil;
    }
    _appMode = appMode;
    
    switch (appMode){
        case APP_FREE:
            _multiYear      = false;
            _opeSetting     = false;
            _saleAnalysis   = false;
            _database       = false;
            _importExport   = false;
            _pdfOut         = false;
            break;
        case APP_LITE:
            _multiYear      = true;
            _opeSetting     = true;
            _saleAnalysis   = false;
            _database       = false;
            _importExport   = false;
            _pdfOut         = false;
            break;
        case APP_STANDALONE:
            _multiYear      = true;
            _opeSetting     = true;
            _saleAnalysis   = true;
            _database       = true;
            _importExport   = false;
            _pdfOut         = false;
            break;
        case APP_NETWORK:
            _multiYear      = true;
            _opeSetting     = true;
            _saleAnalysis   = true;
            _database       = true;
            _importExport   = true;
            _pdfOut         = true;
            break;
            
        default:
            break;
    }
    
    if ( _friendMode == true ){
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setInteger:_appMode forKey:@"FriendModeAppMode" ];
        [ud synchronize];
    }
    return;
}



//======================================================================
@end
//======================================================================
