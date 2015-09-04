//
//  ModelSale.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/17.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelRE.h"
#import "Graph.h"

/****************************************************************/
@interface ModelSale : NSObject
/****************************************************************/
+ (void) setGraphDataPrice:(Graph*)gData ModelRE:(ModelRE*)modelRE;
+ (void) setGraphDataCapGain:(Graph*)gData ModelRE:(ModelRE*)modelRE;
/****************************************************************/
@end
/****************************************************************/
