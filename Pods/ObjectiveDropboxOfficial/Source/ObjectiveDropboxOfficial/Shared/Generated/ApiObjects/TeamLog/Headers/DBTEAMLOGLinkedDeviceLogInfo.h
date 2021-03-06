///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGLinkedDeviceLogInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `LinkedDeviceLogInfo` struct.
///
/// Linked Device's logged information.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGLinkedDeviceLogInfo : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Device type.
@property (nonatomic, readonly, copy) NSString *deviceType;

/// Device display name.
@property (nonatomic, readonly, copy, nullable) NSString *displayName;

/// The IP address of the last activity from this device.
@property (nonatomic, readonly, copy, nullable) NSString *ipAddress;

/// Last activity.
@property (nonatomic, readonly, copy, nullable) NSString *lastActivity;

/// Device platform name.
@property (nonatomic, readonly, copy, nullable) NSString *platform;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param deviceType Device type.
/// @param displayName Device display name.
/// @param ipAddress The IP address of the last activity from this device.
/// @param lastActivity Last activity.
/// @param platform Device platform name.
///
/// @return An initialized instance.
///
- (instancetype)initWithDeviceType:(NSString *)deviceType
                       displayName:(nullable NSString *)displayName
                         ipAddress:(nullable NSString *)ipAddress
                      lastActivity:(nullable NSString *)lastActivity
                          platform:(nullable NSString *)platform;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param deviceType Device type.
///
/// @return An initialized instance.
///
- (instancetype)initWithDeviceType:(NSString *)deviceType;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `LinkedDeviceLogInfo` struct.
///
@interface DBTEAMLOGLinkedDeviceLogInfoSerializer : NSObject

///
/// Serializes `DBTEAMLOGLinkedDeviceLogInfo` instances.
///
/// @param instance An instance of the `DBTEAMLOGLinkedDeviceLogInfo` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGLinkedDeviceLogInfo` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGLinkedDeviceLogInfo *)instance;

///
/// Deserializes `DBTEAMLOGLinkedDeviceLogInfo` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGLinkedDeviceLogInfo` API object.
///
/// @return An instantiation of the `DBTEAMLOGLinkedDeviceLogInfo` object.
///
+ (DBTEAMLOGLinkedDeviceLogInfo *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
