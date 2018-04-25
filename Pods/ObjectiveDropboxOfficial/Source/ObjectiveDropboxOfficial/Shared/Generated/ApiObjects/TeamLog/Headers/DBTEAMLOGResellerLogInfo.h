///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGResellerLogInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `ResellerLogInfo` struct.
///
/// Reseller information.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGResellerLogInfo : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Reseller name.
@property (nonatomic, readonly, copy) NSString *resellerName;

/// Reseller email.
@property (nonatomic, readonly, copy) NSString *resellerEmail;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param resellerName Reseller name.
/// @param resellerEmail Reseller email.
///
/// @return An initialized instance.
///
- (instancetype)initWithResellerName:(NSString *)resellerName resellerEmail:(NSString *)resellerEmail;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `ResellerLogInfo` struct.
///
@interface DBTEAMLOGResellerLogInfoSerializer : NSObject

///
/// Serializes `DBTEAMLOGResellerLogInfo` instances.
///
/// @param instance An instance of the `DBTEAMLOGResellerLogInfo` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGResellerLogInfo` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGResellerLogInfo *)instance;

///
/// Deserializes `DBTEAMLOGResellerLogInfo` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGResellerLogInfo` API object.
///
/// @return An instantiation of the `DBTEAMLOGResellerLogInfo` object.
///
+ (DBTEAMLOGResellerLogInfo *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
