//
//  DisclaimerViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2016/02/06.
//  Copyright © 2016年 Beetre. All rights reserved.
//

#import "DisclaimerViewCtrl.h"
#import "Pos.h"

@interface DisclaimerViewCtrl ()
{
    Pos                     *_pos;
    UIScrollView            *_scrollView;
    UIWebView               *_wv;
    
}

@end

@implementation DisclaimerViewCtrl

-(void)viewDidLoad {
    [super viewDidLoad];

    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _wv = [[UIWebView alloc] init];
    _wv.scalesPageToFit = YES;
    _wv.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _wv.delegate = self;
    

    NSString *path = [[NSBundle mainBundle] pathForResource:@"disclaimer" ofType:@"html"];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    NSString *htmlString = [[NSString alloc] initWithData:[readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];    
    [_wv loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:path]];


    [_scrollView addSubview:_wv];
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jString;
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        jString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='300%%'"];
    } else {
        jString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='150%%'"];
    }
    [_wv stringByEvaluatingJavaScriptFromString:jString];

}
//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewMake];
}
//======================================================================
// ビューのレイアウト作成
//======================================================================
-(void)viewMake{
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,lengthR,length30;
    _pos = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    length30    = _pos.len30;
    /****************************************/
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0.2*dy;
    pos_y = pos_y + dy;
    _wv.frame = CGRectMake(pos_x, pos_y, _pos.len30, _pos.frame.size.height - pos_y-dy*2);
    return;
}

/**
 * ビューがタップされたとき
 */
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    //    NSLog(@"タップされました．");
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
