//
//  Graph.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/15.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawTool.h"

/****************************************************************/
@interface Graph : DrawTool
{
    NSString    *_title;
    NSArray     *_GraphDataAll;
}
/****************************************************************/
- (void)setGraphtMinMax_xmin:(CGFloat)xmin ymin:(CGFloat)ymin xmax:(CGFloat)xmax ymax:(CGFloat)ymax;
/****************************************************************/
@property   (nonatomic,readwrite)   NSString    *title;
@property   (nonatomic,readwrite)   NSArray     *GraphDataAll;
/****************************************************************/
#define LINE_GRAPH  @1
#define BAR_GPAPH   @2
/****************************************************************/
@end
/****************************************************************/
