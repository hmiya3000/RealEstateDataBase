//
//  InputLandAssessmentViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/27.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputLandAssessmentViewCtrl.h"
#import "MapUtil.h"

@interface InputLandAssessmentViewCtrl ()
{
    NSInteger               _value;
    
    UILabel                 *_l_bg;
    UITextField             *_t_lAssess;
    UILabel                 *_l_lAssess;
    UILabel                 *_l_address;
    UITextView              *_tv_tips;
    
    UIWebView               *_wv;

    MapUtil                 *_mapUtil;
    CLLocationCoordinate2D  _loc2d;
    
}
@end

@implementation InputLandAssessmentViewCtrl


#define TTAG_LASSESS          1

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"路線価";
    
    _value          = _modelRE.estate.land.assessment;
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_bg           = [UIUtil makeLabel:@""];
    [_scrollView addSubview:_l_bg];
    /****************************************/
    _t_lAssess        = [UIUtil makeTextFieldDec:@"99" tgt:self];
    [_t_lAssess       setTag:TTAG_LASSESS];
    [_t_lAssess       setDelegate:(id)self];
    [_scrollView addSubview:_t_lAssess];
    /*--------------------------------------*/
    _l_lAssess        = [UIUtil makeLabel:@"千円/㎡"];
    [_scrollView addSubview:_l_lAssess];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = [NSString stringWithFormat:@"路線価は積算評価の計算に使われます"];
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _l_address                = [UIUtil makeLabel:_modelRE.estate.land.address];
    [_l_address setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_address];
    /****************************************/
    _wv = [[UIWebView alloc] init];
    _wv.delegate = self;
    _wv.scalesPageToFit = YES;
    [_scrollView addSubview:_wv];
    /****************************************/
    
    _loc2d.latitude     = _modelRE.estate.land.latitude;
    _loc2d.longitude    = _modelRE.estate.land.longitude;
    _mapUtil = [[MapUtil alloc] init];
    if ( [MapUtil isSetLoc:_loc2d] == true ){
        //緯度経度から都道府県の取得
        [_mapUtil locateToAddress:self selector:@selector(callbackMap2AddrWithResult:error:) locate2d:_loc2d];
    } else {
        //大体の住所から緯度経度を取得、その後、都道府県を取得
        [_mapUtil addressToLocate:self selector:@selector(callbackAddr2MapWithResult:error:) address:_modelRE.estate.land.address];
    }
    
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
}
//===============================================================
// 緯度経度の取得のコールバック。緯度経度から都道府県の取得を実行
//===============================================================
-(void)callbackAddr2MapWithResult:(NSDictionary *)resultDictionary error:(NSError *)error
{
    _loc2d =  [resultDictionary[@"locate"] MKCoordinateValue];
    [_mapUtil locateToAddress:self selector:@selector(callbackMap2AddrWithResult:error:) locate2d:_loc2d];
}
//===============================================================
//都道府県の取得のコールバック
//===============================================================
 -(void)callbackMap2AddrWithResult:(NSDictionary *)resultDictionary error:(NSError *)error
{
    NSLog(@"callbackForWorkWithResult:error: is called.");
    NSLog(@"resultDictonary = %@", resultDictionary);
    NSLog(@"error = %@", error);

    NSString *url = @"http://www.rosenka.nta.go.jp/main_h29/";
    NSInteger code = [MapUtil prefectureToCode:resultDictionary[@"administrativeArea"]];
    switch(code){
        case CODE_HOKKAIDO:     url = [url stringByAppendingString:@"sapporo/hokkaido/"];   break;
            //------------
        case CODE_AOMORI:       url = [url stringByAppendingString:@"sendai/aomori/"];      break;
        case CODE_IWATE:        url = [url stringByAppendingString:@"sendai/iwate/"];       break;
        case CODE_MIYAGI:       url = [url stringByAppendingString:@"sendai/miyagi/"];      break;
        case CODE_AKITA:        url = [url stringByAppendingString:@"sendai/akita/"];       break;
        case CODE_YAMAGATA:     url = [url stringByAppendingString:@"sendai/yamagata/"];    break;
        case CODE_FUKUSHIMA:    url = [url stringByAppendingString:@"sendai/fukusima/"];    break;
        //------------
        case CODE_IBARAKI:      url = [url stringByAppendingString:@"kanto/ibaraki/"];      break;
        case CODE_TOCHIGI:      url = [url stringByAppendingString:@"kanto/tochigi/"];      break;
        case CODE_GUNMA:        url = [url stringByAppendingString:@"kanto/gunma/"];        break;
        case CODE_SAITAMA:      url = [url stringByAppendingString:@"kanto/saitama/"];      break;
        case CODE_CHIBA:        url = [url stringByAppendingString:@"tokyo/chiba/"];        break;
        case CODE_TOKYO:        url = [url stringByAppendingString:@"tokyo/tokyo/"];        break;
        case CODE_KANAGAWA:     url = [url stringByAppendingString:@"tokyo/kanagawa/"];     break;
        //------------
        case CODE_NIIGATA:      url = [url stringByAppendingString:@"kanto/niigata/"];      break;
        case CODE_TOYAMA:       url = [url stringByAppendingString:@"kanazawa/toyama/"];    break;
        case CODE_ISHIKAWA:     url = [url stringByAppendingString:@"kanazawa/isikawa/"];   break;
        case CODE_FUKUI:        url = [url stringByAppendingString:@"kanazawa/fukui/"];     break;
        case CODE_YAMANASHI:    url = [url stringByAppendingString:@"tokyo/yamanasi/"];     break;
        case CODE_NAGANO:       url = [url stringByAppendingString:@"kanto/nagano/"];       break;
        case CODE_GIFU:         url = [url stringByAppendingString:@"nagoya/gifu/"];        break;
        case CODE_SHIZUOKA:     url = [url stringByAppendingString:@"nagoya/sizuoka/"];     break;
        case CODE_AICHI:        url = [url stringByAppendingString:@"nagoya/aichi/"];       break;
        case CODE_MIE:          url = [url stringByAppendingString:@"nagoya/mie/"];         break;
        //------------
        case CODE_SHIGA:        url = [url stringByAppendingString:@"osaka/shiga/"];        break;
        case CODE_KYOTO:        url = [url stringByAppendingString:@"osaka/kyoto/"];        break;
        case CODE_OSAKA:        url = [url stringByAppendingString:@"osaka/osaka/"];        break;
        case CODE_HYOGO:        url = [url stringByAppendingString:@"osaka/hyogo/"];        break;
        case CODE_NARA:         url = [url stringByAppendingString:@"osaka/nara/"];         break;
        case CODE_WAKAYAMA:     url = [url stringByAppendingString:@"osaka/wakayama/"];     break;
        //------------
        case CODE_TOTTORI:      url = [url stringByAppendingString:@"hirosima/tottori/"];   break;
        case CODE_SHIMANE:      url = [url stringByAppendingString:@"hirosima/simane/"];    break;
        case CODE_OKAYAMA:      url = [url stringByAppendingString:@"hirosima/okayama/"];   break;
        case CODE_HIROSHIMA:    url = [url stringByAppendingString:@"hirosima/hirosima/"];  break;
        case CODE_YAMAGUCHI:    url = [url stringByAppendingString:@"hirosima/yamaguti/"];  break;
        //------------
        case CODE_TOKUSHIMA:    url = [url stringByAppendingString:@"takamatu/tokusima/"];  break;
        case CODE_KAGAWA:       url = [url stringByAppendingString:@"takamatu/kagawa/"];    break;
        case CODE_EHIME:        url = [url stringByAppendingString:@"takamatu/ehime/"];     break;
        case CODE_KOCHI:        url = [url stringByAppendingString:@"takamatu/koti/"];      break;
        //------------
        case CODE_FUKUOKA:      url = [url stringByAppendingString:@"fukuoka/fukuoka/"];    break;
        case CODE_SAGA:         url = [url stringByAppendingString:@"fukuoka/saga/"];       break;
        case CODE_NAGASAKI:     url = [url stringByAppendingString:@"fukuoka/nagasaki/"];   break;
        case CODE_KUMAMOTO:     url = [url stringByAppendingString:@"kumamoto/kumamoto/"];  break;
        case CODE_OITA:         url = [url stringByAppendingString:@"kumamoto/oita/"];      break;
        case CODE_MIYAZAKI:     url = [url stringByAppendingString:@"kumamoto/miyazaki/"];  break;
        case CODE_KAGOSHIMA:    url = [url stringByAppendingString:@"kumamoto/kagosima/"];  break;
        case CODE_OKINAWA:      url = [url stringByAppendingString:@"okinawa/okinawa/"];    break;
            //------------
        case CODE_UNKNOWN:
        default:
            break;
    }
    if (code != CODE_UNKNOWN){
        url = [url stringByAppendingString:@"pref_frm.htm"];
    }else{
        url = @"http://www.rosenka.nta.go.jp/index.htm";
    }
    NSURL *url2 = [NSURL URLWithString:url];
    NSURLRequest *req = [NSURLRequest requestWithURL:url2];
    [_wv loadRequest:req];
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
#if 0
    CGRect rect = CGRectMake(_pos.frame.origin.x,
                      _pos.frame.origin.y,
                      _pos.frame.size.width,
                      _pos.frame.size.height);
    _scrollView = [UIUtil makeScrollView:rect xpage:2 ypage:1 tgt:self];
    _scrollView.pagingEnabled = YES;
#endif
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0.2*dy;
    if ( _pos.isPortrait == true ){
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:pos_x         y:pos_y         viewWidth:_pos.len30 viewHeight:dy*1.05 color:[UIUtil color_Ivory]];
        [UIUtil setTextField:_t_lAssess         x:pos_x+0.1*dx  y:pos_y+dy*0.1  length:_pos.len15];
        [UIUtil setLabel:_l_lAssess             x:pos_x+2*dx    y:pos_y+dy*0.1  length:_pos.len10];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy);
        
        /****************************************/
        pos_y = pos_y + dy;
        [UIUtil setLabel:_l_address             x:pos_x         y:pos_y length:_pos.len30];
        /****************************************/
        pos_y = pos_y + dy;
//        pos_x   = pos_x + _pos.x_page;
//        CGFloat webHeight = 11;
        _wv.frame = CGRectMake(pos_x, pos_y, _pos.len30, _pos.frame.size.height - pos_y);


    }else {
        /****************************************/
        [UIUtil setRectLabel:_l_bg              x:pos_x         y:pos_y         viewWidth:_pos.len15 viewHeight:dy*1.05 color:[UIUtil color_Ivory]];
        [UIUtil setTextField:_t_lAssess         x:pos_x+0.1*dx  y:pos_y+dy*0.1  length:_pos.len15/2];
        [UIUtil setLabel:_l_lAssess             x:pos_x+dx      y:pos_y+dy*0.1  length:_pos.len10/2];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len15, dy*2);
        
        /****************************************/
        pos_y = 0.2*dy;
        [UIUtil setLabel:_l_address             x:_pos.x_center         y:pos_y length:_pos.len30];
        /****************************************/
        pos_y = pos_y + dy;
//        pos_x   = pos_x + _pos.x_page;
//        CGFloat webHeight = 11;
        _wv.frame = CGRectMake(pos_x, pos_y, _pos.len30, _pos.frame.size.height - pos_y);
    }
    
    return;
}

//======================================================================
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [super view_Tapped:sender];
    //    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
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
        _modelRE.estate.land.assessment = _value;
        [_modelRE valToFile];
    }
    [super viewWillDisappear:animated];
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
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
    [self readTextFieldData];
}

//======================================================================
//
//======================================================================
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self readTextFieldData];
    return YES;
}

//======================================================================
//
//======================================================================
-(void) readTextFieldData
{
    /*--------------------------------------*/
    NSInteger tmp_value;
    tmp_value    = [_t_lAssess.text integerValue];
    if ( tmp_value <= 100000 && tmp_value > 0 ){
        _value  = tmp_value;
    }
    /*--------------------------------------*/
    [self rewriteProperty];
}
//======================================================================
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{
    _t_lAssess.text     = [NSString stringWithFormat:@"%ld", (long)_value];
}

//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================

//======================================================================
@end
//======================================================================
