//
//  InputViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/15.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputViewCtrl.h"

@interface InputViewCtrl ()

@end

@implementation InputViewCtrl
@synthesize masterVC    = _masterVC;

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        _modelRE = [ModelRE sharedManager];
        self.title = @"物件名";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"決定"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(clickButton:)];
        
        
        
        self.view.backgroundColor = [UIUtil color_LightYellow];
    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
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
/****************************************************************
 * 回転していいかの判別
 ****************************************************************/
- (BOOL)shouldAutorotate
{
    return YES;
}

/****************************************************************
 * 回転処理の許可
 ****************************************************************/
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

/****************************************************************
 * 回転時に処理したい内容
 ****************************************************************/
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/****************************************************************
 * ビューがタップされたとき
 ****************************************************************/
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
//    NSLog(@"タップされました．");
}

/****************************************************************
 *
 ****************************************************************/
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        [self.masterVC viewWillAppear:YES];
    } else {
    }
    [super viewWillDisappear:animated];
}

/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

/****************************************************************
 *
 ****************************************************************/
- (void)keyboardWasShown:(NSNotification*)aNotification
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
/****************************************************************
 *
 ****************************************************************/
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
#if 0
    [_scrollView setContentOffset:CGPointZero animated:YES];
#endif
    return;
}

/****************************************************************
 *
 ****************************************************************/
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
