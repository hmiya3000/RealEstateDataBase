//
//  InputViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/15.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputViewCtrl.h"
#import "ViewMgr.h"

@interface InputViewCtrl ()

@end

@implementation InputViewCtrl
//======================================================================
@synthesize masterVC    = _masterVC;
//======================================================================
#define BTAG_CANCEL     100
//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self){
        
        self.title = @"物件名";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"キャンセル"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(clickButton:)];
        self.navigationItem.rightBarButtonItem.tag  = BTAG_CANCEL;
        _b_cancel = false;
        
        
        self.view.backgroundColor = [UIUtil color_LightYellow];
    }
    return self;
}

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    _modelRE = [ModelRE sharedManager];
    NSString *model = [UIDevice currentDevice].model;
    if ([model hasPrefix:@"iPad"]){
        CGRect frame = self.view.frame;
        if ( frame.size.width == 768 ){
            frame.size.width = frame.size.width - 320;
        } else {
            frame.size.width = frame.size.width - 380;
        }
        [self.view setFrame:frame];
    }
    
    
    /****************************************/
//    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:_scrollView];
    /****************************************/
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    [self registerForKeyboardNotifications];
}
//======================================================================
// 回転していいかの判別
//======================================================================
-(BOOL)shouldAutorotate
{
    return YES;
}

//======================================================================
// 回転処理の許可
//======================================================================
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

//======================================================================
// 回転時に処理したい内容
//======================================================================
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            NSLog(@"aaa");
//            [_scrollView setContentOffset:CGPointZero animated:YES];
            break;
        default:
            break;
    }    
}

/****************************************************************
 * Returnでキーボードを閉じる
 ****************************************************************/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//======================================================================
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
//    NSLog(@"タップされました．");
}

//======================================================================
//
//======================================================================
-(void) viewWillAppear:(BOOL)animated
{
    ViewMgr *viewMgr        = [ViewMgr sharedManager];
    [viewMgr setOpenInputView:true];
    
    
    // Viewが現れるときにMasterViewを更新する
    [self.masterVC viewWillAppear:YES];
    [super viewWillAppear:animated];
    
}

//======================================================================
//
//======================================================================
-(void) viewWillDisappear:(BOOL)animated
{
    //「戻る」の時のイベントを捕まえられないので、
    //消える時にクリアする。続けて入力ビューを開く場合には再設定されるのでこれでよい
    ViewMgr *viewMgr        = [ViewMgr sharedManager];
    [viewMgr setOpenInputView:false];
    
    
    // Viewが消えるときにMasterViewを更新する
    [self.masterVC viewWillAppear:YES];
    [super viewWillDisappear:animated];
}

//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_CANCEL ){
        _b_cancel = true;
    }
    return;
}

//======================================================================
//
//======================================================================
-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//======================================================================
//
//======================================================================
-(void)keyboardWasShown:(NSNotification*)aNotification
{
#if 0
    CGPoint scrollPoint = CGPointMake(0.0,20.0);
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [_scrollView setContentOffset:scrollPoint animated:YES];
            break;
        default:
            break;
    }
#endif
    return;
}
//======================================================================
//
//======================================================================
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
#if 0
    [_scrollView setContentOffset:CGPointZero animated:YES];
#endif
    return;
}

//======================================================================
//
//======================================================================
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
