///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGMemberAccessLevelResult;
@class DBSHARINGRemoveFileMemberError;
@class DBSHARINGSharingFileAccessError;
@class DBSHARINGSharingUserError;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `RemoveFileMemberError` union.
///
/// Errors for `removeFileMember2`.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGRemoveFileMemberError : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBSHARINGRemoveFileMemberErrorTag` enum type represents the possible
/// tag states with which the `DBSHARINGRemoveFileMemberError` union can exist.
typedef NS_ENUM(NSInteger, DBSHARINGRemoveFileMemberErrorTag) {
  /// (no description).
  DBSHARINGRemoveFileMemberErrorUserError,

  /// (no description).
  DBSHARINGRemoveFileMemberErrorAccessError,

  /// This member does not have explicit access to the file and therefore
  /// cannot be removed. The return value is the access that a user might have
  /// to the file from a parent folder.
  DBSHARINGRemoveFileMemberErrorNoExplicitAccess,

  /// (no description).
  DBSHARINGRemoveFileMemberErrorOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBSHARINGRemoveFileMemberErrorTag tag;

/// (no description). @note Ensure the `isUserError` method returns true before
/// accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBSHARINGSharingUserError *userError;

/// (no description). @note Ensure the `isAccessError` method returns true
/// before accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBSHARINGSharingFileAccessError *accessError;

/// This member does not have explicit access to the file and therefore cannot
/// be removed. The return value is the access that a user might have to the
/// file from a parent folder. @note Ensure the `isNoExplicitAccess` method
/// returns true before accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBSHARINGMemberAccessLevelResult *noExplicitAccess;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "user_error".
///
/// @param userError (no description).
///
/// @return An initialized instance.
///
- (instancetype)initWithUserError:(DBSHARINGSharingUserError *)userError;

///
/// Initializes union class with tag state of "access_error".
///
/// @param accessError (no description).
///
/// @return An initialized instance.
///
- (instancetype)initWithAccessError:(DBSHARINGSharingFileAccessError *)accessError;

///
/// Initializes union class with tag state of "no_explicit_access".
///
/// Description of the "no_explicit_access" tag state: This member does not have
/// explicit access to the file and therefore cannot be removed. The return
/// value is the access that a user might have to the file from a parent folder.
///
/// @param noExplicitAccess This member does not have explicit access to the
/// file and therefore cannot be removed. The return value is the access that a
/// user might have to the file from a parent folder.
///
/// @return An initialized instance.
///
- (instancetype)initWithNoExplicitAccess:(DBSHARINGMemberAccessLevelResult *)noExplicitAccess;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "user_error".
///
/// @note Call this method and ensure it returns true before accessing the
/// `userError` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value "user_error".
///
- (BOOL)isUserError;

///
/// Retrieves whether the union's current tag state has value "access_error".
///
/// @note Call this method and ensure it returns true before accessing the
/// `accessError` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value "access_error".
///
- (BOOL)isAccessError;

///
/// Retrieves whether the union's current tag state has value
/// "no_explicit_access".
///
/// @note Call this method and ensure it returns true before accessing the
/// `noExplicitAccess` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value
/// "no_explicit_access".
///
- (BOOL)isNoExplicitAccess;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBSHARINGRemoveFileMemberError` union.
///
@interface DBSHARINGRemoveFileMemberErrorSerializer : NSObject

///
/// Serializes `DBSHARINGRemoveFileMemberError` instances.
///
/// @param instance An instance of the `DBSHARINGRemoveFileMemberError` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGRemoveFileMemberError` API object.
///
+ (nullable NSDictionary *)serialize:(DBSHARINGRemoveFileMemberError *)instance;

///
/// Deserializes `DBSHARINGRemoveFileMemberError` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGRemoveFileMemberError` API object.
///
/// @return An instantiation of the `DBSHARINGRemoveFileMemberError` object.
///
+ (DBSHARINGRemoveFileMemberError *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
