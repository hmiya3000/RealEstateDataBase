///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGTeamName;
@class DBTEAMLOGTeamProfileChangeNameDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `TeamProfileChangeNameDetails` struct.
///
/// Changed the team name.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGTeamProfileChangeNameDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Previous teams name. Might be missing due to historical data gap.
@property (nonatomic, readonly, nullable) DBTEAMLOGTeamName *previousValue;

/// New team name.
@property (nonatomic, readonly) DBTEAMLOGTeamName *dNewValue;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param dNewValue New team name.
/// @param previousValue Previous teams name. Might be missing due to historical
/// data gap.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGTeamName *)dNewValue
                    previousValue:(nullable DBTEAMLOGTeamName *)previousValue;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param dNewValue New team name.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGTeamName *)dNewValue;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `TeamProfileChangeNameDetails` struct.
///
@interface DBTEAMLOGTeamProfileChangeNameDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGTeamProfileChangeNameDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGTeamProfileChangeNameDetails`
/// API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGTeamProfileChangeNameDetails` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMLOGTeamProfileChangeNameDetails *)instance;

///
/// Deserializes `DBTEAMLOGTeamProfileChangeNameDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGTeamProfileChangeNameDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGTeamProfileChangeNameDetails`
/// object.
///
+ (DBTEAMLOGTeamProfileChangeNameDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
