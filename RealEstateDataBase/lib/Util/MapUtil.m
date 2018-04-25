//
//  MapUtil.m
//  RealEstateDataBase
//
//  Created by hmiya on 2017/04/10.
//  Copyright © 2017年 Beetre. All rights reserved.
//

#import "MapUtil.h"

@implementation MapUtil

//======================================================================
// 正ジオコーディング(住所->緯度軽度)
//======================================================================
-(void)addressToLocate:(id)callbackInstance selector:(SEL)callbackSelector address:(NSString*)address
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address inRegion:nil completionHandler:^(NSArray *placemarks, NSError *error){
        if(error){
            // エラーが発生している
            NSLog(@"エラー %@", error);
        } else {
            // 取得成功
            CLPlacemark *place = [placemarks firstObject];
            NSMutableDictionary *dictonary =  [NSMutableDictionary dictionary];
            dictonary[@"locate"]    = [NSValue valueWithMKCoordinate:place.location.coordinate];
            NSError *error = nil;
            if (callbackInstance && callbackSelector) {
                NSMethodSignature *sig = [callbackInstance methodSignatureForSelector:callbackSelector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
                [invocation setSelector:callbackSelector];
                [invocation setTarget:callbackInstance];
                // コールバックの引数に値を指定する場合には、index >=2を指定する。
                [invocation setArgument:&dictonary atIndex:2];
                [invocation setArgument:&error atIndex:3];
                [invocation invoke];
            }
        }
    }];
}
//======================================================================
// 逆ジオコーディング(緯度経度->住所)
//======================================================================
-(void)locateToAddress:(id)callbackInstance selector:(SEL)callbackSelector locate2d:(CLLocationCoordinate2D)loc2d;
{
    __block  NSString *address = @"";
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:loc2d.latitude
                                                      longitude:loc2d.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error) {
            NSLog(@"リバースジオコーディング失敗");
        } else {
            if(0 < [placemarks count]) {
                NSMutableDictionary *dictonary =  [NSMutableDictionary dictionary];
                for(CLPlacemark *placemark in placemarks) {
#if 0
                    NSLog(@"addressDictionary: [%@]", [placemark.addressDictionary description]);
                    NSLog(@"name: [%@]", placemark.name);
                    
                    NSLog(@"postalCode: [%@]", placemark.postalCode);
                    
                    NSLog(@"country: [%@]", placemark.country);
                    NSLog(@"administrativeArea: [%@]", placemark.administrativeArea);
                    NSLog(@"subAdministrativeArea: [%@]", placemark.subAdministrativeArea);
                    NSLog(@"locality: [%@]", placemark.locality);
                    NSLog(@"subLocality: [%@]", placemark.subLocality);
                    NSLog(@"thoroughfare: [%@]", placemark.thoroughfare);
                    NSLog(@"subThoroughfare: [%@]", placemark.subThoroughfare);
                    
                    NSLog(@"ISOcountryCode: [%@]", placemark.ISOcountryCode);
                    NSLog(@"inlandWater: [%@]", placemark.inlandWater);
                    NSLog(@"ocean: [%@]", placemark.ocean);
                    NSLog(@"areasOfInterest: [%@]", placemark.areasOfInterest);
                    NSLog(@"----------");
                    NSLog(@"address:%@%@%@%@%@", placemark.country, placemark.administrativeArea, placemark.locality, placemark.thoroughfare, placemark.subThoroughfare);
#endif
                    address = @"";
                    if ( placemark.country != nil ){
                        dictonary[@"country"]               = placemark.country;
                    }
                    if ( placemark.administrativeArea != nil ){
                        dictonary[@"administrativeArea"]    = placemark.administrativeArea;
                    }
                    if ( placemark.locality != nil ){
                        address = [address stringByAppendingString:placemark.locality];
                        dictonary[@"locality"]              = placemark.locality;
                    }
                    if ( placemark.thoroughfare != nil ){
                        address = [address stringByAppendingString:placemark.thoroughfare];
                        dictonary[@"thoroughfare"]          = placemark.thoroughfare;
                    }
                    if ( placemark.subThoroughfare != nil ){
                        address = [address stringByAppendingString:placemark.subThoroughfare];
                        dictonary[@"subThoroughfare"]       = placemark.subThoroughfare;
                    }
                }
                dictonary[@"address"]               = [NSString stringWithFormat:@"%@", address];
                //--------------------------------
                NSError *error = nil;
                if (callbackInstance && callbackSelector) {
                    
                    
                    NSMethodSignature *sig = [callbackInstance methodSignatureForSelector:callbackSelector];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
                    [invocation setSelector:callbackSelector];
                    [invocation setTarget:callbackInstance];
                    // コールバックの引数に値を指定する場合には、index >=2を指定する。
                    [invocation setArgument:&dictonary atIndex:2];
                    [invocation setArgument:&error atIndex:3];
                    [invocation invoke];
                }
            }
        }
    }];
    
    return;
}
//======================================================================
//
//======================================================================
+(NSInteger) prefectureToCode:(NSString*)prefecture
{
    NSInteger code = CODE_UNKNOWN;
    if ( [prefecture isEqualToString:@"北海道"] == true ){
        code = CODE_HOKKAIDO;
        //----------------------------
    } else if ( [prefecture isEqualToString:@"青森県"] == true ){
        code = CODE_AOMORI;
    } else if ( [prefecture isEqualToString:@"岩手県"] == true ){
        code = CODE_IWATE;
    } else if ( [prefecture isEqualToString:@"宮城県"] == true ){
        code = CODE_MIYAGI;
    } else if ( [prefecture isEqualToString:@"秋田県"] == true ){
        code = CODE_AKITA;
    } else if ( [prefecture isEqualToString:@"山形県"] == true ){
        code = CODE_YAMAGATA;
    } else if ( [prefecture isEqualToString:@"福島県"] == true ){
        code = CODE_FUKUSHIMA;
        //----------------------------
    } else if ( [prefecture isEqualToString:@"茨城県"] == true ){
        code = CODE_IBARAKI;
    } else if ( [prefecture isEqualToString:@"栃木県"] == true ){
        code = CODE_TOCHIGI;
    } else if ( [prefecture isEqualToString:@"群馬県"] == true ){
        code = CODE_GUNMA;
    } else if ( [prefecture isEqualToString:@"埼玉県"] == true ){
        code = CODE_SAITAMA;
    } else if ( [prefecture isEqualToString:@"千葉県"] == true ){
        code = CODE_CHIBA;
    } else if ( [prefecture isEqualToString:@"東京都"] == true ){
        code = CODE_TOKYO;
    } else if ( [prefecture isEqualToString:@"神奈川県"] == true ){
        code = CODE_KANAGAWA;
        //----------------------------
    } else if ( [prefecture isEqualToString:@"新潟県"] == true ){
        code = CODE_NIIGATA;
    } else if ( [prefecture isEqualToString:@"富山県"] == true ){
        code = CODE_TOYAMA;
    } else if ( [prefecture isEqualToString:@"石川県"] == true ){
        code = CODE_ISHIKAWA;
    } else if ( [prefecture isEqualToString:@"福井県"] == true ){
        code = CODE_FUKUI;
    } else if ( [prefecture isEqualToString:@"山梨県"] == true ){
        code = CODE_YAMANASHI;
    } else if ( [prefecture isEqualToString:@"長野県"] == true ){
        code = CODE_NAGANO;
    } else if ( [prefecture isEqualToString:@"岐阜県"] == true ){
        code = CODE_GIFU;
    } else if ( [prefecture isEqualToString:@"静岡県"] == true ){
        code = CODE_SHIZUOKA;
    } else if ( [prefecture isEqualToString:@"愛知県"] == true ){
        code = CODE_AICHI;
    } else if ( [prefecture isEqualToString:@"三重県"] == true ){
        code = CODE_MIE;
        //----------------------------
    } else if ( [prefecture isEqualToString:@"滋賀県"] == true ){
        code = CODE_SHIGA;
    } else if ( [prefecture isEqualToString:@"京都府"] == true ){
        code = CODE_KYOTO;
    } else if ( [prefecture isEqualToString:@"大阪府"] == true ){
        code = CODE_OSAKA;
    } else if ( [prefecture isEqualToString:@"兵庫県"] == true ){
        code = CODE_HYOGO;
    } else if ( [prefecture isEqualToString:@"奈良県"] == true ){
        code = CODE_NARA;
    } else if ( [prefecture isEqualToString:@"和歌山県"] == true ){
        code = CODE_WAKAYAMA;
        //----------------------------
    } else if ( [prefecture isEqualToString:@"鳥取県"] == true ){
        code = CODE_TOTTORI;
    } else if ( [prefecture isEqualToString:@"島根県"] == true ){
        code = CODE_SHIMANE;
    } else if ( [prefecture isEqualToString:@"岡山県"] == true ){
        code = CODE_OKAYAMA;
    } else if ( [prefecture isEqualToString:@"広島県"] == true ){
        code = CODE_HIROSHIMA;
    } else if ( [prefecture isEqualToString:@"山口県"] == true ){
        code = CODE_YAMAGUCHI;
        //----------------------------
    } else if ( [prefecture isEqualToString:@"徳島県"] == true ){
        code = CODE_TOKUSHIMA;
    } else if ( [prefecture isEqualToString:@"香川県"] == true ){
        code = CODE_KAGAWA;
    } else if ( [prefecture isEqualToString:@"愛媛県"] == true ){
        code = CODE_EHIME;
    } else if ( [prefecture isEqualToString:@"高知県"] == true ){
        code = CODE_KOCHI;
        //----------------------------
    } else if ( [prefecture isEqualToString:@"福岡県"] == true ){
        code = CODE_FUKUOKA;
    } else if ( [prefecture isEqualToString:@"佐賀県"] == true ){
        code = CODE_SAGA;
    } else if ( [prefecture isEqualToString:@"長崎県"] == true ){
        code = CODE_NAGASAKI;
    } else if ( [prefecture isEqualToString:@"熊本県"] == true ){
        code = CODE_KUMAMOTO;
    } else if ( [prefecture isEqualToString:@"大分県"] == true ){
        code = CODE_OITA;
    } else if ( [prefecture isEqualToString:@"宮崎県"] == true ){
        code = CODE_MIYAZAKI;
    } else if ( [prefecture isEqualToString:@"鹿児島県"] == true ){
        code = CODE_KAGOSHIMA;
    } else if ( [prefecture isEqualToString:@"沖縄県"] == true ){
        code = CODE_OKINAWA;
    } else {
        code = CODE_UNKNOWN;
    }
    return code;
}
//======================================================================
//
//======================================================================
+(bool)isSetLoc:(CLLocationCoordinate2D)loc2d
{
    if( loc2d.latitude == 0 || loc2d.longitude == 0 ){
        return false;
    } else {
        return true;
    }
}

//======================================================================
@end
//======================================================================
