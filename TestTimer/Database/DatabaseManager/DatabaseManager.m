//
//  DatabaseManager.m
//  VKStreamer
//
//  Created by Radoo on 14/04/15.
//  Copyright (c) 2015 Radoo. All rights reserved.
//

#import "DatabaseManager.h"
#import <CoreData/CoreData.h>

@implementation DatabaseManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Initializations

+ (id) sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self createFolders];
    }
    return self;
}

#pragma mark - Core Data stack
/**
 Returns the managed object context for the application. If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
    @synchronized(self)
    {
        if (_managedObjectContext != nil)
        {
            return _managedObjectContext;
        }
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil)
        {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
        return _managedObjectContext;
    }
}

/**
 Returns the managed object model for the application. If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *) managedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TimerModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application. If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    @synchronized(self)
    {
        if (_persistentStoreCoordinator != nil)
        {
            return _persistentStoreCoordinator;
        }
        
        NSURL *storeURL = [NSURL fileURLWithPath:[Utilities coreDataDatabasePath]];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption, nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
        return _persistentStoreCoordinator;
    }
}

- (void) saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}
- (void) removePersistentStore
{
    NSArray *stores = [self.persistentStoreCoordinator persistentStores];
    for (NSPersistentStore *store in stores)
    {
        [self.persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
}
- (void) resetDatabase
{
//    [self.managedObjectContext performBlock:^{
//        [self removePersistentStore];
//    }];
    [self.managedObjectContext lock];
    NSArray *stores = [self.persistentStoreCoordinator persistentStores];
    for (NSPersistentStore *store in stores)
    {
        [self.persistentStoreCoordinator removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    [self.managedObjectContext unlock];
//    [self.managedObjectContext performBlockAndWait:^{
//        [self removePersistentStore];
//    }];
    _managedObjectModel = nil;
    _managedObjectContext = nil;
    _persistentStoreCoordinator = nil;
}

#pragma mark - Directory Methods
- (NSString *) coreDataDatabasePath
{
    return [[[Utilities getDocumentsPath] stringByAppendingPathComponent:CORE_DATA_DATABASE_FOLDER_NAME] stringByAppendingPathComponent:CORE_DATA_DATABASE_NAME];
}

- (void) createFolders
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Create directory for database:
    NSString *databaseFolderPath = [[Utilities getDocumentsPath] stringByAppendingPathComponent:CORE_DATA_DATABASE_FOLDER_NAME];
    NSError *error;
    
    if (![fileManager createDirectoryAtPath:databaseFolderPath withIntermediateDirectories:YES attributes:nil error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}


#pragma mark - Workout Methods
- (BOOL) insertTabataWorkout:(NSDictionary *) workout
{
    //Save Data to Core Data Store:
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return NO;
    }
    TabatasWorkouts *entity =[NSEntityDescription insertNewObjectForEntityForName:@"TabatasWorkouts" inManagedObjectContext:context];
    entity.workoutName = workout[@"workoutName"];
    entity.prepareTime = workout[@"prepareTime"];
    entity.workTime = workout[@"workTime"];
    entity.restTime =workout[@"restTime"];
    entity.roundsTabata =workout[@"roundsTabata"];
    entity.cyclesTabata = workout[@"cyclesTabata"];
    entity.restBetweenCyclesTime = workout[@"restBetweenCyclesTime"];
    entity.workoutTimeStamp = workout[@"workoutTimeStamp"];
    entity.tabataID = workout[@"tabataID"];
    NSError *error = nil;
    [context save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;
}
- (NSArray *) getTabataWorkouts
{
    NSManagedObjectContext *context = [self managedObjectContext];;
    
    if (!context)
    {
        return nil;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"TabatasWorkouts"
                                                   inManagedObjectContext:context];
    [request setEntity:description];
    
    NSSortDescriptor* idDescriptor = [[NSSortDescriptor alloc]initWithKey:@"tabataID" ascending:YES];
    
    
    
    [request setSortDescriptors:@[idDescriptor]];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];

    if (error)
    {
        NSLog(@"Fetching error: %@",error.description);
    }
    return results;
}

- (BOOL) deleteTabataWorkout:(TabatasWorkouts *) workout
{
    if (!self.managedObjectContext)
    {
        return NO;
    }
    
    NSArray *results = [self getTabataWorkouts];
    for (NSInteger i=0; i<results.count; i++)
    {
        TabatasWorkouts *workoutRow = results[i];
        if ([workoutRow.workoutTimeStamp isEqualToString:workout.workoutTimeStamp])
        {
            [self.managedObjectContext deleteObject:workoutRow];
            break;
        }
    }
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;
}

- (BOOL)insertRoundsWorkout:(NSDictionary *)workout
{
    
    //Save Data to Core Data Store:
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return NO;
    }
    RoundsWorkouts *entity =[NSEntityDescription insertNewObjectForEntityForName:@"RoundsWorkouts" inManagedObjectContext:context];
    entity.workoutNameRounds = workout[@"workoutNameRounds"];
    entity.prepareTimeRounds = workout[@"prepareTimeRounds"];
    entity.workTimeRounds = workout[@"workTimeRounds"];
    entity.restTimeRounds = workout[@"restTimeRounds"];
    entity.roundsRounds = workout[@"roundsRounds"];
    entity.workoutTimeStampRounds = workout[@"workoutTimeStampRounds"];
    entity.roundsID = workout[@"roundsID"];
    NSError *error = nil;
    [context save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;

}
- (NSArray*)getRoundsWorkouts
{
    NSManagedObjectContext *context = [self managedObjectContext];;
    
    if (!context)
    {
        return nil;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"RoundsWorkouts"
                                                   inManagedObjectContext:context];
    [request setEntity:description];
//    NSPredicate *id =[NSPredicate alloc]ini
    NSSortDescriptor* idDescriptor = [[NSSortDescriptor alloc]initWithKey:@"roundsID" ascending:YES];
    NSLog(@"idDescriptor: %@",idDescriptor);
    
    
    [request setSortDescriptors:@[idDescriptor]];
    
    NSError *error = nil;
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if (error)
    {
        NSLog(@"Fetching error: %@",error.description);
    }
    return results;
}

-(BOOL)deleteRoundsWorkout:(RoundsWorkouts *)workout
{
    if (!self.managedObjectContext)
    {
        return NO;
    }
    
    NSArray *results = [self getRoundsWorkouts];
    for (NSInteger i=0; i<results.count; i++)
    {
        RoundsWorkouts *workoutRow = results[i];
        if ([workoutRow.workoutTimeStampRounds isEqualToString:workout.workoutTimeStampRounds])
        {
            [self.managedObjectContext deleteObject:workoutRow];
            break;
        }
    }
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;

}

-(BOOL)insertStopwatchWorkout:(NSDictionary *)workout
{
    //Save Data to Core Data Store:
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return NO;
    }
    StopwatchWorkouts *entity =[NSEntityDescription insertNewObjectForEntityForName:@"StopwatchWorkouts" inManagedObjectContext:context];
    entity.workoutNameStopwatch = workout[@"workoutNameStopwatch"];
    entity.prepareTimeStopwatch = workout[@"prepareTimeStopwatch"];
    entity.timeLap = workout[@"timeLap"];
    entity.workoutTimeStampStopwatch =workout[@"workoutTimeStampStopwatch"];
    entity.stopWatchID =workout[@"stopWatchID"];
    NSError *error = nil;
    [context save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;
}
-(NSArray*)getStopwatchWorkouts
{
    NSManagedObjectContext *context = [self managedObjectContext];;
    
    if (!context)
    {
        return nil;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"StopwatchWorkouts"
                                                   inManagedObjectContext:context];
    [request setEntity:description];
    
    NSSortDescriptor* idDescriptor = [[NSSortDescriptor alloc]initWithKey:@"stopWatchID" ascending:YES];
    NSLog(@"idDescriptor: %@",idDescriptor);
    
    
    [request setSortDescriptors:@[idDescriptor]];
    
    NSError *error = nil;
    NSMutableArray *results = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if (error)
    {
        NSLog(@"Fetching error: %@",error.description);
    }
    return results;
}
-(BOOL)deleteStopwatchWorkout:(StopwatchWorkouts *)workout
{
    if (!self.managedObjectContext)
    {
        return NO;
    }
    NSArray *results = [self getStopwatchWorkouts];
    for (NSInteger i=0; i<results.count; i++)
    {
        StopwatchWorkouts *workoutRow = results[i];
        if ([workoutRow.workoutTimeStampStopwatch isEqualToString:workout.workoutTimeStampStopwatch])
        {
            [self.managedObjectContext deleteObject:workoutRow];
            break;
        }
    }
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;
}

//
//- (NSArray *) getFavoriteSongs
//{
//    NSManagedObjectContext *context = [self managedObjectContext];
//    
//    if (!context)
//    {
//        return nil;
//    }
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"VKFavorites"];
//    NSString *currentUserID = [[DatabaseManager sharedInstance] currentUserID];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", currentUserID];
//    [request setPredicate:predicate];
//    
//    NSError *error = nil;
//    NSArray *results = [context executeFetchRequest:request error:&error];
//    
//    if (error)
//    {
//        NSLog(@"Fetching error: %@",error.description);
//    }
//    
//    return results;
//}


/*
#pragma mark - Favorite Songs Methods
- (BOOL) saveToFavoritesSong:(VKSong *) song
{
    //Save Data to Core Data Store:
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return NO;
    }
    
    VKFavorites *favoritesEntity = [NSEntityDescription insertNewObjectForEntityForName:@"VKFavorites" inManagedObjectContext:context];
    favoritesEntity.songID = song.id;
    favoritesEntity.ownerID = song.owner_id;
    favoritesEntity.userID = [[VKManager sharedInstance] currentUserID];
    
    NSError *error = nil;
    [context save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;
}

- (BOOL) deleteFromFavoritesSong:(VKSong *) song
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return NO;
    }
    
    NSArray *results = [self getFavoriteSongs];
    for (VKFavorites *favoriteSong in results)
    {
        if ([favoriteSong.songID isEqualToNumber:song.id] && [favoriteSong.ownerID isEqualToNumber:song.owner_id])
        {
            [context deleteObject:favoriteSong];
            break;
        }
    }
    
    NSError *error = nil;
    [context save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;
}

- (NSArray *) getFavoriteSongs
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return nil;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"VKFavorites"];
    NSString *currentUserID = [[VKManager sharedInstance] currentUserID];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", currentUserID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Fetching error: %@",error.description);
    }
    
    return results;
}

- (NSArray *) getFavoriteSongsIDs
{
    NSArray *results = [self getFavoriteSongs];
    NSMutableArray *formattedArray = [NSMutableArray new];
    
    for (VKFavorites *favoriteSong in results)
    {
        NSString *formattedString = [NSString stringWithFormat:@"%@_%@",[favoriteSong.ownerID stringValue],[favoriteSong.songID stringValue]];
        [formattedArray addObject:formattedString];
    }
    
    return formattedArray;
}

#pragma mark - YT URL Fix Methods
- (BOOL) fixVideoDataForSong:(VKSong *)song
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return NO;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"YTFixedURL"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"songID == %@", song.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Fetching error: %@",error.description);
    }
    
    if (results && results.count > 0)
    {
        YTFixedURL *obj = [results firstObject];
        obj.videoID = song.videoID;
        obj.videoURL = song.videoURL;
        obj.thumbnailURL = song.thumbnailURL;
    }
    else
    {
        YTFixedURL *addObj = [NSEntityDescription insertNewObjectForEntityForName:@"YTFixedURL" inManagedObjectContext:context];
        addObj.videoID = song.videoID;
        addObj.videoURL = song.videoURL;
        addObj.thumbnailURL = song.thumbnailURL;
        addObj.songID = song.id;
    }
    
    NSError *saveError = nil;
    [context save:&saveError];
    if (saveError)
    {
        NSLog(@"Error Saving Data: %@",[saveError description]);
        return NO;
    }
    
    return YES;
}

- (NSMutableDictionary *) getFixedVideos
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return nil;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"YTFixedURL"];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    for (YTFixedURL *fixedObj in results)
    {
        YTVideo *video = [[YTVideo alloc] init];
        video.videoId = fixedObj.videoID;
        video.videoURL = fixedObj.videoURL;
        resultDict[fixedObj.songID] = video;
    }
    
    if (error)
    {
        NSLog(@"Fetching error: %@",error.description);
    }
    
    return resultDict;
}

#pragma mark - Videos Fetching Methods
- (YTVideo *) videoForVKSong:(VKSong *) song
{
    if (!song.id)
    {
        return nil;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return nil;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"YTVideos"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vkSongID == %@", song.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Fetching error: %@",error.description);
    }
    
    if (results && results.count > 0)
    {
        YTVideos *obj = [results firstObject];
        YTVideo *result = [[YTVideo alloc] init];
        result.videoId = obj.videoID;
        result.videoTitle = obj.videoTitle;
        result.videoURL = obj.videoURL;
        result.thumbnailURL = obj.thumbnailURL;
        result.lowQualityThumbnailURL = obj.lowThumbnailURL;
        return result;
    }
    
    return nil;
}

- (BOOL) saveVideo:(YTVideo *) video forSongID:(NSNumber *) songID
{
    if (!songID || !video)
    {
        return NO;
    }
    
    //Save Data to Core Data Store:
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return NO;
    }
    
    YTVideos *entity = [NSEntityDescription insertNewObjectForEntityForName:@"YTVideos" inManagedObjectContext:context];
    entity.videoID = video.videoId;
    entity.videoTitle = video.videoTitle;
    entity.videoURL = video.videoURL;
    entity.thumbnailURL = video.thumbnailURL;
    entity.lowThumbnailURL = video.lowQualityThumbnailURL;
    entity.vkSongID = songID;
    
    NSError *error = nil;
    [context save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;
}

#pragma mark - Video Links Methods
- (YTLink *) linksForVKSong:(VKSong *) song
{
    if (!song.id)
    {
        return nil;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return nil;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"YTLinks"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vkSongID == %@", song.id];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"Fetching error: %@",error.description);
    }
    
    if (results && results.count > 0)
    {
        YTLinks *obj = [results firstObject];
        YTLink *result = [[YTLink alloc] init];
        result.lowQualityLink = obj.lowQualityURL;
        result.mediumQualityLink = obj.mediumQualityURL;
        result.highQualityLink = obj.highQualityURL;
        result.videoID = obj.videoID;
        return result;
    }
    
    return nil;
}

- (BOOL) saveLinks:(YTLink *) links forVKSong:(VKSong *) song
{
    if (!song || !links || [links linksAreEmpty])
    {
        return NO;
    }
    
    //Save Data to Core Data Store:
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (!context)
    {
        return NO;
    }
    
    YTLinks *entity = [NSEntityDescription insertNewObjectForEntityForName:@"YTLinks" inManagedObjectContext:context];
    entity.videoID = song.videoID;
    entity.vkSongID = song.id;
    entity.lowQualityURL = links.lowQualityLink;
    entity.mediumQualityURL = links.mediumQualityLink;
    entity.highQualityURL = links.highQualityLink;
    
    NSError *error = nil;
    [context save:&error];
    if (error)
    {
        NSLog(@"Error Saving Data: %@",[error description]);
        return NO;
    }
    
    return YES;
}*/

@end
