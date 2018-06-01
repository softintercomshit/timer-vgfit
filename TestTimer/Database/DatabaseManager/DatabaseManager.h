//
//  DatabaseManager.h
//  VKStreamer
//
//  Created by Radoo on 14/04/15.
//  Copyright (c) 2015 Radoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabatasWorkouts.h"
#import "RoundsWorkouts.h"
#import "StopwatchWorkouts.h"
@interface DatabaseManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedInstance;
- (void)resetDatabase;


#pragma mark - Tabata timer methods
- (BOOL) insertTabataWorkout:(NSDictionary *)workout;
- (NSArray *) getTabataWorkouts;
- (BOOL) deleteTabataWorkout:(TabatasWorkouts *)workout;

#pragma mark - Rounds timer methods
-(BOOL) insertRoundsWorkout:(NSDictionary *)workout;
-(NSArray *) getRoundsWorkouts;
-(BOOL) deleteRoundsWorkout:(RoundsWorkouts *)workout;

#pragma mark - Stopwatch timer methods
-(BOOL) insertStopwatchWorkout:(NSDictionary *)workout;
-(NSArray *)getStopwatchWorkouts;
-(BOOL) deleteStopwatchWorkout:(StopwatchWorkouts *)workout;
- (void) saveContext;


/*
#pragma mark - Favorite Songs Methods
- (BOOL) saveToFavoritesSong:(VKSong *) song;
- (BOOL) deleteFromFavoritesSong:(VKSong *) song;
- (NSArray *) getFavoriteSongs;
- (NSArray *) getFavoriteSongsIDs;

#pragma mark - YT URL Fix Methods
- (BOOL) fixVideoDataForSong:(VKSong *)song;
- (NSMutableDictionary *) getFixedVideos;

#pragma mark - Videos Fetching Methods
- (YTVideo *) videoForVKSong:(VKSong *) song;
- (BOOL) saveVideo:(YTVideo *) video forSongID:(NSNumber *) songID;

#pragma mark - Video Links Methods
- (YTLink *) linksForVKSong:(VKSong *) song;
- (BOOL) saveLinks:(YTLink *) links forVKSong:(VKSong *) song;
*/
 
@end
