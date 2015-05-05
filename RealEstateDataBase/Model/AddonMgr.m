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
/****************************************************************/
static AddonMgr* sharedAddonMgr = nil;
/****************************************************************/
@synthesize multiYear           = _multiYear;
@synthesize opeSetting          = _opeSetting;
@synthesize database            = _database;
@synthesize saleAnalysys        = _saleAnalysis;
@synthesize importExport        = _importExport;
@synthesize pdfOut              = _pdfOut;
@synthesize appMode             = _appMode;
/****************************************************************/
/****************************************************************
 *
 ****************************************************************/
+ (AddonMgr*)sharedManager
{
    @synchronized(self){
        if (sharedAddonMgr == nil ){
            sharedAddonMgr = [[self alloc ]init ];
        }
    }
    return sharedAddonMgr;
}
/****************************************************************
 *
 ****************************************************************/
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
/****************************************************************
 *
 ****************************************************************/
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
/****************************************************************
 * 初期化
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self) {
        _appMode = APP_FREE;
        [self setAddons:_appMode];
    }
    return self;
}
/****************************************************************
 *
 ****************************************************************/
- (void) setAddons:(NSInteger)appMode
{
    if ( appMode != _appMode){
        ViewMgr *viewMgr = [ViewMgr sharedManager];
        viewMgr.reqViewInit = true;
    }
    _appMode = appMode;

    switch (appMode) {
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
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void) setAppModeFree
{
    [self setAddons:APP_FREE];
}
/****************************************************************
 *
 ****************************************************************/
- (void) setAppModeLite
{
    [self setAddons:APP_LITE];
}
/****************************************************************
 *
 ****************************************************************/
- (void) setAppModeStandAlone
{
    [self setAddons:APP_STANDALONE];
}
/****************************************************************
 *
 ****************************************************************/
- (void) setAppModeNetwork
{
    [self setAddons:APP_NETWORK];
}
/****************************************************************
 *
 ****************************************************************/
- (NSString*) getStrAppMode:(NSInteger)appMode
{
    NSString *str;
    switch (appMode) {
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
/****************************************************************/
@end
/****************************************************************/
