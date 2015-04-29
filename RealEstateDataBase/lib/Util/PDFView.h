//
//  PDFView.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/11/03.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFView : UIView
{
    CGPDFPageRef    _page;
}

// プロパティ
@property (nonatomic) CGPDFPageRef page;

@end
