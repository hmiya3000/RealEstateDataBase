//
//  PDFViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/11/02.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "PDFViewCtrl.h"
#import <CoreText/CoreText.h>
#import <DropboxSDK/DropboxSDK.h>
#import "PDFView.h"

@interface PDFViewCtrl ()
{
}
@end

@implementation PDFViewCtrl

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self) {
        self.title  = @"PDF";
    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *retButton =
    [[UIBarButtonItem alloc] initWithTitle:@"戻る"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(retButtonTapped:)];
    self.navigationItem.leftBarButtonItem = retButton;

    
    [self pdfMake2];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *dbFilePath = [documentsDirectory stringByAppendingPathComponent:@"sample.pdf"];

    
    NSURL* url;
    
//    url = [[NSBundle mainBundle] URLForResource:@"sample2.pdf" withExtension:nil];
    url = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",dbFilePath]];
//    url = [NSURL URLWithString:@"http://www.google.com"];
    
    // メールアプリを起動
//    url = [NSURL URLWithString:@"mailto:murapong@example.com"];
    [[UIApplication sharedApplication] openURL:url];
    
#if 0
    
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)url);
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y += 100;
    PDFView *myview = [[PDFView alloc] initWithFrame:rect ];
    myview.page = CGPDFDocumentGetPage(pdf, 1);
    [self.view addSubview:myview];
#endif
}
- (void)viewWillAppear:(BOOL)animated
{
    // 親クラスの呼び出し
    [super viewWillAppear:animated];
    
    // ページの更新
    [self _renewPages];
}

//--------------------------------------------------------------//
#pragma mark -- Image --
//--------------------------------------------------------------//

- (void)_renewPages
{
    CGRect          rect;
    CGPDFPageRef    page;
    
    // 現在のインデックスを保存
    NSInteger oldIndex = _index;
    
    // PDFのページ数を取得
    NSInteger pageNumber;
    pageNumber = CGPDFDocumentGetNumberOfPages(_document);
    
    // コンテントオフセットを取得
    CGPoint offset;
    offset = _mainScrollView.contentOffset;
    if (offset.x == 0) {
        // 前のページへ移動
        _index--;
    }
    if (offset.x >= _mainScrollView.contentSize.width - CGRectGetWidth(_mainScrollView.frame)) {
        // 次のページへ移動
        _index++;
    }
    
    // インデックスの値をチェック
    if (_index < 1) {
        _index = 1;
    }
    if (_index > pageNumber) {
        _index = pageNumber;
    }
    
    if (_index == oldIndex) {
        return;
    }
    
    //
    // 左側のPDF viewを更新
    //
    
    // 最初のページのとき
    if (_index == 1) {
        // 左側のPDF viewは表示しない
        rect = CGRectZero;
        
        page = NULL;
    }
    // 最初のページ以外のとき
    else {
        // 左側のPDF viewのframe
        rect.origin = CGPointZero;
        rect.size = self.view.frame.size;
        
        // 左側のPDF viewの画像の読み込み
        page = CGPDFDocumentGetPage(_document, _index - 1);
    }
    
    // 左側のPDF viewの設定
    _pdfView0.frame = rect;
    _pdfView0.page = page;
    
    //
    // 中央のPDF view、サブスクロールビューを更新
    //
    
    // 中央のPDF viewの画像の読み込み
    page = CGPDFDocumentGetPage(_document, _index);
    
    // サブスクロールビューのframe
    rect.origin.x = CGRectGetMaxX(_pdfView0.frame) > 0 ?
    CGRectGetMaxX(_pdfView0.frame) + 20.0f : 0;
    rect.origin.y = 0;
    rect.size = self.view.frame.size;
    
    // サブスクロールビューの設定
    _subScrollView.frame = rect;
    
    // サブスクロールビューのスケールをリセットする
    _subScrollView.zoomScale = 1.0f;
    _pdfView1.transform = CGAffineTransformIdentity;
    
    // 中央のPDF viewの設定
    rect.origin = CGPointZero;
    rect.size = self.view.frame.size;
    _pdfView1.frame = rect;
    _pdfView1.page = page;
    
    // サブスクロールビューのコンテントサイズを設定する
    _subScrollView.contentSize = rect.size;
    
    // サブスクロールビューのスケールを設定する
    _subScrollView.minimumZoomScale = 1.0f;
    _subScrollView.maximumZoomScale = 2.0f;
    _subScrollView.zoomScale = 1.0f;
    
    //
    // 右側のPDF viewを更新
    //
    
    // 最後のページのとき
    if (_index >= pageNumber) {
        rect = CGRectZero;
        
        page = NULL;
    }
    // 最後のページ以外のとき
    else {
        // 右側のPDF viewのframe
        rect.origin.x = CGRectGetMaxX(_subScrollView.frame) + 20.0f;
        rect.origin.y = 0;
        rect.size = self.view.frame.size;
        
        // 右側のPDF viewの画像の読み込み
        page = CGPDFDocumentGetPage(_document, _index + 1);
    }
    
    // 右側のPDF viewの設定
    _pdfView2.frame = rect;
    _pdfView2.page = page;
    
    //
    // メインスクロールビューの更新
    //
    
    // コンテントサイズとオフセットの設定
    CGSize  size;
    size.width = CGRectGetMaxX(_pdfView2.frame) > 0 ?
    CGRectGetMaxX(_pdfView2.frame) + 20.0f :
    CGRectGetMaxX(_subScrollView.frame) + 20.0f;
    size.height = 0;
    _mainScrollView.contentSize = size;
    _mainScrollView.contentOffset = _subScrollView.frame.origin;
}

/****************************************************************
 *
 ****************************************************************/
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



/****************************************************************/
- (void) pdfMake2
{
    // 画像の準備
    UIImage *image = [UIImage imageNamed:@"haruka.png"];
    
    // PDFファイルをDocumentsディレクトリに作成する
    NSString *filename = @"sample";
    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString *fullname = [filename stringByAppendingString:@".pdf"];
    NSString *pdfFilename = [path stringByAppendingPathComponent:fullname];
    
    // PDFコンテキストを作成する
    UIGraphicsBeginPDFContextToFile(pdfFilename, CGRectZero, nil);
    
    // 新しいページを開始する
    CGSize size = self.view.bounds.size;
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, size.width, size.height), nil);
    
    // 文字列を描画する
    NSString* title = @"姉さん！PDFです！PDF！！";
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [self drawString:title rect:rect color:[UIColor redColor].CGColor fontSize:24.0f ul:true];
    
    // 画像を描画する
    CGPoint point = CGPointMake(0, 200);
    [image drawAtPoint:point];
    
    // PDFコンテキストを閉じる
    UIGraphicsEndPDFContext();
    
    
}

- (void)drawString:(NSString *)string rect:(CGRect)rect color:(CGColorRef)color fontSize:(float)fontSize ul:(BOOL)ul
{
    // 文字色やサイズを設定する
    CTFontRef font = CTFontCreateUIFontForLanguage(kCTFontSystemFontType, fontSize, NULL);
    NSNumber *underline = (ul) ? [NSNumber numberWithInt:kCTUnderlineStyleSingle] : [NSNumber numberWithInt:kCTUnderlineStyleNone];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         (__bridge id)font, (id)kCTFontAttributeName,
                         color, (id)kCTForegroundColorAttributeName,
                         underline, (id)kCTUnderlineStyleAttributeName, nil];
    
    // 描画領域の準備
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string attributes:dic];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, rect);
    
    // レンダリングするフレームを取得
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // グラフィックコンテキストを取得
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // コンテキストの保存
    CGContextSaveGState(currentContext);
    
    // テキスト行列を既知の状態にする
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // CoreTextは左下隅から上に向かって描画されるらしいので、反転処理を行う
    CGContextTranslateCTM(currentContext, 0, self.view.bounds.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    // フレームを描画する
    CTFrameDraw(frameRef, currentContext);
    
    // コンテキストの復元
    CGContextRestoreGState(currentContext);
    
    // 解放処理
    CFRelease(frameRef);
    CFRelease(framesetter);
}

//--------------------------------------------------------------//
#pragma mark -- UIScrollViewDelegate --
//--------------------------------------------------------------//

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView
                  willDecelerate:(BOOL)decelerate
{
    // メインスクロールビューの場合
    if (scrollView == _mainScrollView) {
        if (!decelerate) {
            // ページの更新
            [self _renewPages];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    // メインスクロールビューの場合
    if (scrollView == _mainScrollView) {
        // ページの更新
        [self _renewPages];
    }
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    // サブスクロールビューの場合
    if (scrollView == _subScrollView) {
        // 中央のPDF viewを使う
        return _pdfView1;
    }
    
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
