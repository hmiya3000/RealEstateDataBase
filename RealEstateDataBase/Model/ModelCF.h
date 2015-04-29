//
//  ModelCF.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/04/04.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelRE.h"
#import "Graph.h"

/****************************************************************/
@interface ModelCF : NSObject
/****************************************************************/
+ (void) setGraphData:(Graph*)gData ModelRE:(ModelRE*)modelRE;
/****************************************************************/
@end
/****************************************************************/
