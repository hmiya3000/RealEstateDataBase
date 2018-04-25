///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMPOLICIESSharedFolderJoinPolicy;
@class DBTEAMPOLICIESSharedFolderMemberPolicy;
@class DBTEAMPOLICIESSharedLinkCreatePolicy;
@class DBTEAMPOLICIESTeamSharingPolicies;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `TeamSharingPolicies` struct.
///
/// Policies governing sharing within and outside of the team.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMPOLICIESTeamSharingPolicies : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Who can join folders shared by team members.
@property (nonatomic, readonly) DBTEAMPOLICIESSharedFolderMemberPolicy *sharedFolderMemberPolicy;

/// Which shared folders team members can join.
@property (nonatomic, readonly) DBTEAMPOLICIESSharedFolderJoinPolicy *sharedFolderJoinPolicy;

/// Who can view shared links owned by team members.
@property (nonatomic, readonly) DBTEAMPOLICIESSharedLinkCreatePolicy *sharedLinkCreatePolicy;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param sharedFolderMemberPolicy Who can join folders shared by team members.
/// @param sharedFolderJoinPolicy Which shared folders team members can join.
/// @param sharedLinkCreatePolicy Who can view shared links owned by team
/// members.
///
/// @return An initialized instance.
///
- (instancetype)initWithSharedFolderMemberPolicy:(DBTEAMPOLICIESSharedFolderMemberPolicy *)sharedFolderMemberPolicy
                          sharedFolderJoinPolicy:(DBTEAMPOLICIESSharedFolderJoinPolicy *)sharedFolderJoinPolicy
                          sharedLinkCreatePolicy:(DBTEAMPOLICIESSharedLinkCreatePolicy *)sharedLinkCreatePolicy;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `TeamSharingPolicies` struct.
///
@interface DBTEAMPOLICIESTeamSharingPoliciesSerializer : NSObject

///
/// Serializes `DBTEAMPOLICIESTeamSharingPolicies` instances.
///
/// @param instance An instance of the `DBTEAMPOLICIESTeamSharingPolicies` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMPOLICIESTeamSharingPolicies` API object.
///
+ (nullable NSDictionary *)serialize:(DBTEAMPOLICIESTeamSharingPolicies *)instance;

///
/// Deserializes `DBTEAMPOLICIESTeamSharingPolicies` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMPOLICIESTeamSharingPolicies` API object.
///
/// @return An instantiation of the `DBTEAMPOLICIESTeamSharingPolicies` object.
///
+ (DBTEAMPOLICIESTeamSharingPolicies *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
