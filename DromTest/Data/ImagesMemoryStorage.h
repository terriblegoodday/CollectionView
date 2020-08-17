//
//  PhotosMemory.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImagesRepository;

// This class is for testing purposes purely
@interface ImagesMemoryStorage: NSObject <ImagesRepository>

@property (strong, nonatomic, readonly) NSMutableArray<UIImage *> * photos;
@property (strong, nonatomic, readonly) NSMutableArray<UIImage *> * defaultPhotos;

@end

NS_ASSUME_NONNULL_END
