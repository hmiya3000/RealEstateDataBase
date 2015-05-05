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
}
/****************************************************************/
@property   (nonatomic,readwrite)   NSInteger       stage;
@property   (nonatomic,readwrite)   BOOL            reqViewInit;
/****************************************************************/
+ (ViewMgr*)sharedManager;
- (BOOL) isReturnDataList;
/****************************************************************/
#define STAGE_TOP       1
#define STAGE_DATALIST  2
#define STAGE_ANALYSIS  3
/****************************************************************/
@end
/****************************************************************/
