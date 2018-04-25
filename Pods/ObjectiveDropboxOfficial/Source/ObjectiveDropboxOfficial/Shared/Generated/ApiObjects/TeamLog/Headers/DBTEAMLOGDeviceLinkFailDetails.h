///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGDeviceLinkFailDetails;
@class DBTEAMLOGDeviceType;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `DeviceLinkFailDetails` struct.
///
/// Failed to link a device.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGDeviceLinkFailDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// IP address. Might be missing due to historical data gap.
@property (nonatomic, readonly, copy, nullable) NSString *ipAddress;

/// A description of the device used while user approval blocked.
@property (nonatomic, readonly) DBTEAMLOGDeviceType *deviceType;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param deviceType A description of the device used while user approval
/// blocked.
/// @param ipAddress IP address. Might be missing due to historical data gap.
///
/// @return An initialized instance.
///
- (instancetype)initWithDeviceType:(DBTEAMLOGDeviceType *)deviceType ipAddress:(nullable NSString *)ipAddress;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param deviceType A description of the device used while user approval
/// blocked.
///
/// @return An initialized instance.
///
- (instancetype)initWithDeviceType:(DBTEAMLOGDeviceType *)deviceType;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DeviceLinkFailDetails` struct.
///
@interface DBTEAMLOGDeviceLinkFailDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGDeviceLinkFailDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGDeviceLinkFailDetails` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGDeviceLinkFailDetails` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGDeviceLinkFailDetails *)instance;

///
/// Deserializes `DBTEAMLOGDeviceLinkFailDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGDeviceLinkFailDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGDeviceLinkFailDetails` object.
///
+ (DBTEAMLOGDeviceLinkFailDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END