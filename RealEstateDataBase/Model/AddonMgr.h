//
//  AddonMgr.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/02.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

//======================================================================
@interface AddonMgr : NSObject
{
    bool                        _multiYear;
    bool                        _opeSetting;
    bool                        _database;
    bool                        _saleAnalysis;
    bool                        _importExport;
    bool                        _pdfOut;
    NSInteger                   _appMode;
    NSArray                     *_products;
    bool                        _friendMode;
}
//======================================================================
@property   (nonatomic,readwrite)   bool        multiYear;
@property   (nonatomic,readwrite)   bool        opeSetting;
@property   (nonatomic,readwrite)   bool        database;
@property   (nonatomic,readwrite)   bool        saleAnalysys;
@property   (nonatomic,readwrite)   bool        importExport;
@property   (nonatomic,readwrite)   bool        pdfOut;
@property   (nonatomic,readonly)    NSInteger   appMode;
@property   (nonatomic,readwrite)   NSArray     *products;
@property   (nonatomic,readonly)    bool        friendMode;
//======================================================================
+ (AddonMgr*)sharedManager;
-(NSString*) getStrAppMode:(NSInteger)appMode;
-(void) saveProductId:(NSString *)productId;
-(void) loadAddons;
-(void) initializeAddons;
-(void) activateFriend:(NSString*)keyword;
-(void) setAppModeFree;
-(void) setAppModeLite;
-(void) setAppModeStandAlone;
-(void) setAppModeNetwork;
- (NSArray*) getAddonArray;
- (NSArray*) getProductIds:(NSInteger)appMode;
-(void) addProduct:(SKProduct*)product;

//======================================================================
#define APP_FREE                0
#define APP_LITE                1
#define APP_STANDALONE          2
#define APP_NETWORK             3
//======================================================================
@end
//======================================================================
