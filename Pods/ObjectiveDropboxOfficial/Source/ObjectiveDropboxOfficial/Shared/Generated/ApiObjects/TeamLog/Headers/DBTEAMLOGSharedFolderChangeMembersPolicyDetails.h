///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGMemberPolicy;
@class DBTEAMLOGSharedFolderChangeMembersPolicyDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SharedFolderChangeMembersPolicyDetails` struct.
///
/// Changed who can become a member of the shared folder.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGSharedFolderChangeMembersPolicyDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// New external invite policy.
@property (nonatomic, readonly) DBSHARINGMemberPolicy *dNewValue;

/// Previous external invite policy. Might be missing due to historical data
/// gap.
@property (nonatomic, readonly, nullable) DBSHARINGMemberPolicy *previousValue;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param dNewValue New external invite policy.
/// @param previousValue Previous external invite policy. Might be missing due
/// to historical data gap.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBSHARINGMemberPolicy *)dNewValue
                    previousValue:(nullable DBSHARINGMemberPolicy *)previousValue;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param dNewValue New external invite policy.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBSHARINGMemberPolicy *)dNewValue;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `SharedFolderChangeMembersPolicyDetails`
/// struct.
///
@interface DBTEAMLOGSharedFolderChangeMembersPolicyDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGSharedFolderChangeMembersPolicyDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGSharedFolderChangeMembersPolicyDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGSharedFolderChangeMembersPolicyDetails` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGSharedFolderChangeMembersPolicyDetails *)instance;

///
/// Deserializes `DBTEAMLOGSharedFolderChangeMembersPolicyDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGSharedFolderChangeMembersPolicyDetails` API object.
///
/// @return An instantiation of the
/// `DBTEAMLOGSharedFolderChangeMembersPolicyDetails` object.
///
+ (DBTEAMLOGSharedFolderChangeMembersPolicyDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
