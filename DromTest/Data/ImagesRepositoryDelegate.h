//
//  PhotosRepositoryDelegate.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImagesRepositoryDelegate <NSObject>

@required
- (void)imageDidUpdateAt:(NSIndexPath *)indexPath;
- (void)repositoryDidReset;
- (void)imageDidAddAt:(NSIndexPath *)indexPath;
- (void)imageDidStartDownloading:(NSIndexPath *)indexPath;
- (void)imageWasRemovedAt:(NSIndexPath *)indexPath;
- (void)imageFailedToDownloadAt:(NSIndexPath *)indexPath;

@end
