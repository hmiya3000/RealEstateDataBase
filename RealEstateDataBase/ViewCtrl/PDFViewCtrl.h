//
//  PDFViewCtrl.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/11/02.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDFView;

@interface PDFViewCtrl : UIViewController
{
    CGPDFDocumentRef    _document;
    int                 _index;
    
    IBOutlet UIScrollView*  _mainScrollView;
    
    IBOutlet UIView*        _innerView;
    IBOutlet PDFView*       _pdfView0;
    IBOutlet UIScrollView*  _subScrollView;
    IBOutlet PDFView*       _pdfView1;
    IBOutlet PDFView*       _pdfView2;
}
@end
