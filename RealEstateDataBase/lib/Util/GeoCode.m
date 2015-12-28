//
//  GeoCode.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/12/26.
//  Copyright © 2015年 Beetre. All rights reserved.
//

#import "GeoCode.h"

@implementation GeoCode

+ (CLLocationCoordinate2D)AddressToLocation2D:(NSString*)address
{
    // 緯度・軽度を設定
    __block  CLLocationCoordinate2D location;
    
    location.latitude   = 35.68154;
    location.longitude  = 139.752498;
    
    // 正ジオコーディング
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address inRegion:nil completionHandler:^(NSArray *placemarks, NSError *error){
        if(error){
            // エラーが発生している
            NSLog(@"エラー %@", error);
        } else {
            // 取得成功
            CLPlacemark *place = [placemarks firstObject];
            location = place.location.coordinate;
            
        }
    }];
    return location;

}

+ (NSString*)Location2DToAddress:(CLLocationCoordinate2D)location2D
{
    __block  NSString *address = @"";
    // リバースジオコーディング
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:location2D.latitude
                                                      longitude:location2D.longitude];
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error) {
            NSLog(@"リバースジオコーディング失敗");
        } else {
            if(0 < [placemarks count]) {
                for(CLPlacemark *placemark in placemarks) {
                    NSLog(@"addressDictionary: [%@]", [placemark.addressDictionary description]);
                    NSLog(@"name: [%@]", placemark.name);
                    NSLog(@"thoroughfare: [%@]", placemark.thoroughfare);
                    NSLog(@"subThoroughfare: [%@]", placemark.subThoroughfare);
                    NSLog(@"locality: [%@]", placemark.locality);
                    NSLog(@"subLocality: [%@]", placemark.subLocality);
                    NSLog(@"administrativeArea: [%@]", placemark.administrativeArea);
                    NSLog(@"subAdministrativeArea: [%@]", placemark.subAdministrativeArea);
                    NSLog(@"postalCode: [%@]", placemark.postalCode);
                    NSLog(@"ISOcountryCode: [%@]", placemark.ISOcountryCode);
                    NSLog(@"country: [%@]", placemark.country);
                    NSLog(@"inlandWater: [%@]", placemark.inlandWater);
                    NSLog(@"ocean: [%@]", placemark.ocean);
                    NSLog(@"areasOfInterest: [%@]", placemark.areasOfInterest);
                    NSLog(@"----------");
                    NSLog(@"address:%@%@%@%@%@", placemark.country, placemark.administrativeArea, placemark.locality, placemark.thoroughfare, placemark.subThoroughfare);
                    address = [NSString stringWithFormat:@"%@%@%@%@%@",
                               placemark.country,
                               placemark.administrativeArea,
                               placemark.locality,
                               placemark.thoroughfare,
                               placemark.subThoroughfare];
                    
                    
                }
            }
        }
    }];
    
    return address;
}


@end
