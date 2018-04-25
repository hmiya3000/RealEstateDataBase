//
//  InputAddressViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/27.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputAddressViewCtrl.h"
#import "MapUtil.h"

@interface InputAddressViewCtrl ()
{
    UILabel                 *_l_title;
    UITextView              *_tv_address;
    UIButton                *_btn_addr2map;
    UIButton                *_btn_map2addr;
    UIButton                *_btn_now;
    UIButton                *_btn_pinclr;
    
    UIButton                *_btn_enter;
    UIButton                *_btn_cancel;
    
    MapUtil                 *_mapUtil;

    NSString                *_addrOfMap;
    MKMapView               *_mapView;
    MKPointAnnotation       *_pin;
    CLLocationCoordinate2D  _loc2d;
    CLLocationCoordinate2D  _locAdd2d;
}

@end

@implementation InputAddressViewCtrl

#define TTAG_ADDRESS        1
#define BTAG_ADDR2MAP       2
#define BTAG_MAP2ADDR       3
#define BTAG_PINCLR         4
#define BTAG_NOW            5

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"住所";
    /****************************************/
    _mapUtil = [[MapUtil alloc] init];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _tv_address                = [[UITextView alloc]init];
    _tv_address.editable       = true;
    _tv_address.scrollEnabled  = true;
    _tv_address.backgroundColor = [UIColor whiteColor];
    _tv_address.text           = _modelRE.estate.land.address;
    [_tv_address   setTag:TTAG_ADDRESS];
    [_tv_address   setDelegate:(id)self];
    [_scrollView addSubview:_tv_address];
    /****************************************/
    _btn_addr2map   = [UIUtil makeButton:@"住所へ移動" tag:BTAG_ADDR2MAP];
    [_btn_addr2map  addTarget:self action:@selector(clickMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView    addSubview:_btn_addr2map];
    //----------------------------------------
    _btn_map2addr   = [UIUtil makeButton:@"住所読出し" tag:BTAG_MAP2ADDR];
    [_btn_map2addr  addTarget:self action:@selector(clickMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView    addSubview:_btn_map2addr];
    //----------------------------------------
    _btn_pinclr     = [UIUtil makeButton:@"クリア" tag:BTAG_PINCLR];
    [_btn_pinclr       addTarget:self action:@selector(clickMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView    addSubview:_btn_pinclr];
    //----------------------------------------
#if 0
    _btn_now        = [UIUtil makeButton:@"現在地" tag:BTAG_NOW];
    [_btn_now       addTarget:self action:@selector(clickMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView    addSubview:_btn_now];
#endif
    /****************************************/

    _mapView    = [[MKMapView alloc]init];
    _mapView.delegate = self;
    _mapView.zoomEnabled    = YES;
    _mapView.scrollEnabled  = YES;

    // 表示タイプを航空写真と地図のハイブリッドに設定
    _mapView.mapType = MKMapTypeStandard;
    
    // view に追加
    [_scrollView addSubview:_mapView];
    
    //--------------------------------------
    _pin = [[MKPointAnnotation alloc] init];
    _loc2d.latitude     = _modelRE.estate.land.latitude;
    _loc2d.longitude    = _modelRE.estate.land.longitude;

    if ( [MapUtil isSetLoc:_loc2d] == false ){
        //緯度経度未定
        [_btn_pinclr setTitle:@"ここに設定" forState:UIControlStateNormal];
        [self addr2map];
    } else {
        //緯度経度確定
        [_btn_pinclr setTitle:@"クリア" forState:UIControlStateNormal];
        _pin.coordinate     = _loc2d;
        [self location2map:_loc2d];
        [_mapView addAnnotation:_pin];
    }
    
    
    //--------------------------------------
    //タップ
    UITapGestureRecognizer *tapGesture;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(view_Tapped:)];
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    
    //--------------------------------------
    //長押し
    UILongPressGestureRecognizer *longPressGesture;
    longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                     action:@selector(handleLongPressGesture:)];
    [_mapView addGestureRecognizer:longPressGesture];
}

//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self rewriteProperty];
    [self viewMake];
}
//======================================================================
// ビューのレイアウト作成
//======================================================================
-(void)viewMake
{
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
    if ( _pos.isPortrait == true ){
        _tv_address.frame   = CGRectMake(pos_x, pos_y, _pos.len30, dy*1.2);
        pos_y = pos_y + dy*1.2;
        [UIUtil setButton:_btn_addr2map x:pos_x+0*dx y:pos_y length:_pos.len10];
        [UIUtil setButton:_btn_map2addr x:pos_x+1*dx y:pos_y length:_pos.len10];
        [UIUtil setButton:_btn_pinclr   x:pos_x+2*dx y:pos_y length:_pos.len10];
        pos_y = pos_y + dy*1;
        _mapView.frame      = CGRectMake(pos_x, pos_y, _pos.len30, _pos.y_btm - pos_y );
        
    }else {
        _tv_address.frame   = CGRectMake(pos_x, pos_y, _pos.len30, dy*1.2);
        pos_y = pos_y + dy*1.2;
        [UIUtil setButton:_btn_addr2map x:pos_x+0*dx y:pos_y length:_pos.len10];
        [UIUtil setButton:_btn_map2addr x:pos_x+1*dx y:pos_y length:_pos.len10];
        [UIUtil setButton:_btn_pinclr   x:pos_x+2*dx y:pos_y length:_pos.len10];
        pos_y = pos_y + dy*1;
        _mapView.frame      = CGRectMake(pos_x, pos_y, _pos.len30,  _pos.y_btm - pos_y );
    }
    return;
}

//======================================================================
//
//======================================================================
-(void)rewriteProperty
{
    return;
}

//======================================================================
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    [_tv_address resignFirstResponder];
    //    NSLog(@"タップされました．");
}

//======================================================================
//
//======================================================================
-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {  // 長押し検出開始時のみ動作
        
        CGPoint touchedPoint = [gesture locationInView:_mapView];
        CLLocationCoordinate2D touchCoordinate = [_mapView convertPoint:touchedPoint toCoordinateFromView:_mapView];
        
        [self setAnnotation:touchCoordinate mapMove:NO animated:NO];
        _loc2d = touchCoordinate;
        [_btn_pinclr setTitle:@"クリア" forState:UIControlStateNormal];
    }
    return;
}
//======================================================================
//
//======================================================================
-(void)setAnnotation:(CLLocationCoordinate2D) point mapMove:(BOOL)mapMove
            animated:(BOOL)animated
{
    // ピンを全て削除
    [_mapView removeAnnotations: _mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    
    _pin.coordinate = point;
    [_mapView addAnnotation:_pin];
    
}
//======================================================================
//
//======================================================================
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id )annotation
{
    static NSString* Identifier = @"PinAnnotationIdentifier";
    MKPinAnnotationView* pinView;
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:Identifier];
    
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:Identifier];
        pinView.animatesDrop = YES;
        return pinView;
    }
    pinView.annotation = annotation;
    return pinView;
}
//======================================================================
// 回転時に処理したい内容
//======================================================================
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    [self viewMake];
    return;
}
//======================================================================
// Viewが消える直前
//======================================================================
-(void) viewWillDisappear:(BOOL)animated
{
    if ( _b_cancel == false ){
        _modelRE.estate.land.address    = _tv_address.text;
        _modelRE.estate.land.latitude   = _loc2d.latitude;
        _modelRE.estate.land.longitude  = _loc2d.longitude;
        [_modelRE valToFile];
    }
    [super viewWillDisappear:animated];
}
//======================================================================
//
//======================================================================
-(BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    [self addr2map];
    return YES;
}
//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    [super clickButton:sender];
    [self.navigationController popViewControllerAnimated:YES];
    return;
}
//======================================================================
//
//======================================================================
-(void)clickMapButton:(UIButton*)sender
{
    switch (sender.tag) {
        case BTAG_MAP2ADDR:
            if ( [MapUtil isSetLoc:_loc2d] == true ){
                [self map2addr];
            }
            break;
        case BTAG_ADDR2MAP:
            if ( [MapUtil isSetLoc:_loc2d] == true ){
                [self location2map:_loc2d];
            } else {
                [self addr2map];
            }
            break;
        case BTAG_PINCLR:
            if ( [MapUtil isSetLoc:_loc2d] == true ){
                //確定だったので未定状態に戻す
                [_btn_pinclr setTitle:@"ここに設定" forState:UIControlStateNormal];
                _loc2d.latitude     = 0;
                _loc2d.longitude    = 0;
                [_mapView removeAnnotations: _mapView.annotations];
                [self addr2map];
            } else {
                //未定だったのでここに確定
                [_btn_pinclr setTitle:@"クリア" forState:UIControlStateNormal];
                _loc2d = _locAdd2d;
                _pin.coordinate = _loc2d;
                [_mapView removeOverlays:_mapView.overlays];
                [_mapView addAnnotation:_pin];
            }
            break;
        case BTAG_NOW:
            [self toMapApp];
            break;
            
        default:
            break;
    }
    return;
}
//======================================================================
//
//======================================================================
-(void)map2addr
{
    [_mapUtil locateToAddress:self selector:@selector(callbackMap2AddrWithResult:error:) locate2d:_loc2d];

}
//======================================================================
//
//======================================================================
-(void)callbackMap2AddrWithResult:(NSDictionary *)resultDictionary error:(NSError *)error
{
    NSString *address = resultDictionary[@"address"];
    _addrOfMap = address;
    UIAlertController *al_address;
    al_address = [UIAlertController alertControllerWithTitle:@"住所の更新"
                                                     message:[NSString stringWithFormat:@"%@ に更新しますか",_addrOfMap]
                                              preferredStyle:UIAlertControllerStyleAlert];
    [al_address addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _tv_address.text = address;
    }]];
    [al_address addAction:[UIAlertAction actionWithTitle:@"そのまま" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //何もしない
    }]];
    [self presentViewController:al_address animated:YES completion:nil];
}
//======================================================================
//
//======================================================================
-(void)location2map:(CLLocationCoordinate2D)loc2d
{
    MKCoordinateRegion region = _mapView.region;
    region.center = loc2d;
    region.span.latitudeDelta   = 0.01;
    region.span.longitudeDelta  = 0.01;
    [_mapView setRegion:region animated:NO];
    return;
}

//======================================================================
//
//======================================================================
-(void)addr2map
{
    [_mapUtil addressToLocate:self selector:@selector(callbackAddr2MapWithResult:error:) address:_tv_address.text];
}
//======================================================================
//
//======================================================================
-(void)callbackAddr2MapWithResult:(NSDictionary *)resultDictionary error:(NSError *)error
{
    _locAdd2d =  [resultDictionary[@"locate"] MKCoordinateValue];
    //--------------------------------
    // ピンの周りに円を表示
    MKCircle* circle = [MKCircle circleWithCenterCoordinate:_locAdd2d radius:100];  // 半径100m
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView addOverlay:circle];
    [self location2map:_locAdd2d];
}
//======================================================================
//
//======================================================================
- (MKCircleRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircle* circle = overlay;
    MKCircleRenderer* circleOverlayView =   [[MKCircleRenderer alloc] initWithCircle:circle];

    circleOverlayView.strokeColor = [UIColor  colorWithRed:0 green:0 blue:0 alpha:0.5];
    circleOverlayView.lineWidth = 2.;
    circleOverlayView.fillColor = [UIColor  colorWithRed:1.0 green:1.0 blue:0.88 alpha:0];

    return circleOverlayView;
}
//======================================================================
//
//======================================================================
-(void)toMapApp
{
    NSString *url = [NSString stringWithFormat:@"googlemaps://?q=%f,%f", _loc2d.latitude, _loc2d.longitude];
//    NSString *url = [NSString stringWithFormat:@"googlemaps://?q=%f,%f(%@)", _loc2d.latitude, _loc2d.longitude, _modelRE.estate.name];
    NSURL *URL = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    } else {
#if 0
        Class itemClass = [MKMapItem class];
        if (itemClass) {
            /// MKPlacemark を作る
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_loc2d.latitude, _loc2d.longitude);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:self.place.addressDictionary];
            
            /// MKPlacemark から MKMapItem を作る
            MKMapItem *item = [[MKMapItem alloc] initWithPlacemark:placemark];
            item.name = self.place.name;
            
            /// Apple Map.app に渡すオプションを準備
            /// Span を指定して Map 表示時の拡大率を調整
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250);
            MKCoordinateSpan span = region.span;
            
            /// Apple Map.app を開く
            BOOL result = [item openInMapsWithLaunchOptions:@{
                                                              MKLaunchOptionsMapSpanKey : [NSValue valueWithMKCoordinateSpan:span],
                                                              MKLaunchOptionsMapCenterKey : [NSValue valueWithMKCoordinate:coordinate]
                                                              }];
            
            if (result == NO) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Apple Map.app を開けませんでした"
                                                               delegate:nil
                                                      cancelButtonTitle:@"閉じる"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } else {
            NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f&q=%@", _loc2d.latitude, _loc2d.longitude, self.place.escapedName];
            NSURL *URL = [NSURL URLWithString:url];
            [[UIApplication sharedApplication] openURL:URL];
        }
        
#else
#if 1
        UIAlertController *_as_clear;
        _as_clear = [UIAlertController alertControllerWithTitle:nil
                                                        message:@"Google Map.app がインストールされていません"
                                                 preferredStyle:UIAlertControllerStyleAlert];
        [_as_clear addAction:[UIAlertAction actionWithTitle:@"閉じる"  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //何もしない
        }]];
#else
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Google Map.app がインストールされていません"
                                                       delegate:nil
                                              cancelButtonTitle:@"閉じる"
                                              otherButtonTitles:nil];
        [alert show];
#endif
#endif
    }
    return;
}
//======================================================================
@end
//======================================================================
