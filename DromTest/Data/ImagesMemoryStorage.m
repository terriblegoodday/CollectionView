//
//  PhotosMemory.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import "ImagesRepositoryDelegate.h"
#import "ImagesRepository.h"
#import "ImagesMemoryStorage.h"

@implementation ImagesMemoryStorage

@synthesize delegate;

- (ImagesMemoryStorage *)init
{
    self = [super init];
    if (self) {
        _photos = [NSMutableArray arrayWithCapacity:6];
        [self _addImageToArray:@"0"];
        [self _addImageToArray:@"1"];
        [self _addImageToArray:@"2"];
        [self _addImageToArray:@"3"];
        [self _addImageToArray:@"4"];
        [self _addImageToArray:@"5"];
        _defaultPhotos = [_photos mutableCopy];
    }
    return self;
}

- (NSIndexPath *)_addImageToArray:(NSString *)url {
    UIImage * image = [UIImage imageNamed:url];
    [self.photos addObject:image];
    return [NSIndexPath indexPathForItem:[self.photos indexOfObject:image] inSection:0];
}

- (void)addImageWithUrl:(NSString *)url {
    NSIndexPath * imagePath = [self _addImageToArray:url];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->delegate imageDidAddAt:imagePath];
    });
}

- (void)downloadImageAt:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->delegate imageDidUpdateAt:indexPath];
    });
}

- (UIImage *)getImageAt:(NSIndexPath *)indexPath {
    if ([self.photos count] > indexPath.row) {
        return self.photos[indexPath.row];
    } else {
        @throw [NSError errorWithDomain:@"PhotosRepository (Memory)" code:7 userInfo:nil];
    }
}

- (void)refresh {
    sleep(1);
    _photos = [_defaultPhotos mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->delegate repositoryDidReset];
    });
}

- (void)removeImageAt:(NSIndexPath *)indexPath {
    [self.photos removeObjectAtIndex:indexPath.row];
}

- (BOOL)isPhotoDownloadedAt:(NSIndexPath *)indexPath {
    return ([self.photos count] > indexPath.row);
}

- (NSUInteger)getImagesCount {
    return [self.photos count];
}

@end
