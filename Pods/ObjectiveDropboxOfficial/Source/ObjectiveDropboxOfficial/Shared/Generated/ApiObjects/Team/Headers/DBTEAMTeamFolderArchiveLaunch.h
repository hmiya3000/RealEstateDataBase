///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMTeamFolderArchiveLaunch;
@class DBTEAMTeamFolderMetadata;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `TeamFolderArchiveLaunch` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMTeamFolderArchiveLaunch : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBTEAMTeamFolderArchiveLaunchTag` enum type represents the possible tag
/// states with which the `DBTEAMTeamFolderArchiveLaunch` union can exist.
typedef NS_ENUM(NSInteger, DBTEAMTeamFolderArchiveLaunchTag) {
  /// This response indicates that the processing is asynchronous. The string
  /// is an id that can be used to obtain the status of the asynchronous job.
  DBTEAMTeamFolderArchiveLaunchAsyncJobId,

  /// (no description).
  DBTEAMTeamFolderArchiveLaunchComplete,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBTEAMTeamFolderArchiveLaunchTag tag;

/// This response indicates that the processing is asynchronous. The string is
/// an id that can be used to obtain the status of the asynchronous job. @note
/// Ensure the `isAsyncJobId` method returns true before accessing, otherwise a
/// runtime exception will be raised.
@property (nonatomic, readonly, copy) NSString *asyncJobId;

/// (no description). @note Ensure the `isComplete` method returns true before
/// accessing, otherwise a runtime exception will be raised.
@property (nonatomic, readonly) DBTEAMTeamFolderMetadata *complete;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "async_job_id".
///
/// Description of the "async_job_id" tag state: This response indicates that
/// the processing is asynchronous. The string is an id that can be used to
/// obtain the status of the asynchronous job.
///
/// @param asyncJobId This response indicates that the processing is
/// asynchronous. The string is an id that can be used to obtain the status of
/// the asynchronous job.
///
/// @return An initialized instance.
///
- (instancetype)initWithAsyncJobId:(NSString *)asyncJobId;

///
/// Initializes union class with tag state of "complete".
///
/// @param complete (no description).
///
/// @return An initialized instance.
///
- (instancetype)initWithComplete:(DBTEAMTeamFolderMetadata *)complete;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "async_job_id".
///
/// @note Call this method and ensure it returns true before accessing the
/// `asyncJobId` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value "async_job_id".
///
- (BOOL)isAsyncJobId;

///
/// Retrieves whether the union's current tag state has value "complete".
///
/// @note Call this method and ensure it returns true before accessing the
/// `complete` property, otherwise a runtime exception will be thrown.
///
/// @return Whether the union's current tag state has value "complete".
///
- (BOOL)isComplete;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBTEAMTeamFolderArchiveLaunch` union.
///
@interface DBTEAMTeamFolderArchiveLaunchSerializer : NSObject

///
/// Serializes `DBTEAMTeamFolderArchiveLaunch` instances.
///
/// @param instance An instance of the `DBTEAMTeamFolderArchiveLaunch` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMTeamFolderArchiveLaunch` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMTeamFolderArchiveLaunch *)instance;

///
/// Deserializes `DBTEAMTeamFolderArchiveLaunch` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMTeamFolderArchiveLaunch` API object.
///
/// @return An instantiation of the `DBTEAMTeamFolderArchiveLaunch` object.
///
+ (DBTEAMTeamFolderArchiveLaunch *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END