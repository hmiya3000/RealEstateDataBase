//
//  CalcKey.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/29.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawTool.h"

@interface CalcKey : DrawTool
{
    NSString    *_text;
}
-(void)keyDown;
-(void)keyUp;
@property   (nonatomic) NSString    *text;
@end
