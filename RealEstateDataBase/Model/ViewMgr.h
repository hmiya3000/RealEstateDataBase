//
//  ViewMgr.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/04.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewMgr : NSObject
{
    NSInteger           _stage;
    BOOL                _reqViewInit;
    BOOL                _openInputView;
}
//======================================================================
@property   (nonatomic,readwrite)   NSInteger       stage;
@property   (nonatomic,readwrite)   BOOL            reqViewInit;
@property   (nonatomic,readwrite)   BOOL            openInputView;
//======================================================================
+(ViewMgr*)sharedManager;
-(void) SetOpenInputView:(BOOL) open;
-(BOOL) isReturnDataList;
-(BOOL) isOpenInputView;
//======================================================================
#define STAGE_TOP       1
#define STAGE_DATALIST  2
#define STAGE_ANALYSIS  3
//======================================================================
@end
//======================================================================
