//
//  AddonMgr.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/02.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddonMgr : NSObject
{
    bool                        _multiYear;
    bool                        _opeSetting;
    bool                        _database;
    bool                        _saleAnalysis;
    bool                        _importExport;
    bool                        _pdfOut;
    NSInteger                   _appMode;
}
/****************************************************************/
@property   (nonatomic,readwrite)   bool        multiYear;
@property   (nonatomic,readwrite)   bool        opeSetting;
@property   (nonatomic,readwrite)   bool        database;
@property   (nonatomic,readwrite)   bool        saleAnalysys;
@property   (nonatomic,readwrite)   bool        importExport;
@property   (nonatomic,readwrite)   bool        pdfOut;
@property   (nonatomic,readonly)    NSInteger   appMode;
/****************************************************************/
+ (AddonMgr*)sharedManager;
- (NSString*) getStrAppMode:(NSInteger)appMode;
- (void) setAppModeFree;
- (void) setAppModeLite;
- (void) setAppModeStandAlone;
- (void) setAppModeNetwork;
- (NSArray*) getAddonArray;
/****************************************************************/
#define APP_FREE                0
#define APP_LITE                1
#define APP_STANDALONE          2
#define APP_NETWORK             3


/****************************************************************/
@end
/****************************************************************/
