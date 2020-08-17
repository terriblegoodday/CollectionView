//
//  PhotosRepository.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@protocol ImagesRepositoryDelegate;
@protocol ImagesRepository <NSObject>
@property (weak) id <ImagesRepositoryDelegate> delegate;

@required
- (UIImage *)getImageAt:(NSIndexPath *)indexPath;
- (NSUInteger)getImagesCount;
- (void)downloadImageAt:(NSIndexPath *)indexPath;
- (BOOL)isPhotoDownloadedAt:(NSIndexPath *)indexPath;
- (void)removeImageAt:(NSIndexPath *)indexPath;
- (void)addImageWithUrl:(NSString *)url;
- (void)refresh;

@end
