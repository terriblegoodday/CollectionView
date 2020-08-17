//
//  CollectionViewController.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagesRepository;
@protocol ImagesRepositoryDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching, ImagesRepositoryDelegate>

@property NSMutableArray<NSString *> * imageCount;
@property (nonatomic, strong, readonly) id <ImagesRepository> repository;
@property (strong, nonatomic) UIRefreshControl * refreshControl;


- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout andRepository:(id<ImagesRepository>)repository;

@end

NS_ASSUME_NONNULL_END
