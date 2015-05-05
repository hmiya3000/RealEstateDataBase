//
//  ViewMgr.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/04.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "ViewMgr.h"

@implementation ViewMgr
{
}
/****************************************************************/
static ViewMgr* sharedViewMgr = nil;
/****************************************************************/
@synthesize stage           = _stage;
@synthesize reqViewInit     = _reqViewInit;
/****************************************************************/
/****************************************************************
 *
 ****************************************************************/
+ (ViewMgr*)sharedManager
{
    @synchronized(self){
        if (sharedViewMgr == nil ){
            sharedViewMgr = [[self alloc ]init ];
        }
    }
    return sharedViewMgr;
}
/****************************************************************
 *
 ****************************************************************/
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if ( sharedViewMgr == nil){
            sharedViewMgr  = [super allocWithZone:zone];
            return sharedViewMgr;
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
        _stage          = STAGE_TOP;
        _reqViewInit    = false;
    }
    return self;
}
/****************************************************************
 *
 ****************************************************************/
- (void) setStage:(NSInteger)stage
{
    if ( stage == STAGE_DATALIST ){
        _reqViewInit = false;
    }
    _stage = stage;
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (BOOL) isReturnDataList
{
    if ( _stage != STAGE_DATALIST && _reqViewInit == true ){
        return true;
    } else {
        return false;
    }
}
/****************************************************************/
@end
/****************************************************************/
