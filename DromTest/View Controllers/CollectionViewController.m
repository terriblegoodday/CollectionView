//
//  CollectionViewController.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//


#import "ImagesRepositoryDelegate.h"

#import "CollectionViewController.h"
#import "AsyncImageViewCell.h"
#import "ImagesRepository.h"

@interface CollectionViewController ()

@property (atomic) BOOL isUIAvailable;

@end

@implementation CollectionViewController

- (void)setupCollectionView {
    if (@available (iOS 10.0, *)) {
        self.collectionView.prefetchDataSource = self;
    }
    
    if (@available (iOS 13.0, *)) {
        self.collectionView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshThePhotos) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    [self.collectionView registerClass:[AsyncImageViewCell class] forCellWithReuseIdentifier:@"asyncImageViewCell"];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.multipleTouchEnabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isUIAvailable = YES;
    self.navigationItem.title = @"🚗";

    [self setupCollectionView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionViewLayout invalidateLayout];
}

- (void)refreshThePhotos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.repository refresh];
    });
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout andRepository:(id)repository {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _repository = repository;
        _repository.delegate = self;
    }
    return self;
}

- (void)animateCellDeletion:(UICollectionViewCell *)cell {
    CGFloat endx = CGRectGetWidth(self.collectionView.frame);
    CATransform3D endTransform = CATransform3DMakeTranslation(endx, 0, 0);
    cell.layer.transform = endTransform;
    cell.alpha = 0.0;
}

- (void)deleteTheRowAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2f animations:^{
        [self animateCellDeletion:cell];
    } completion:^(BOOL finished) {
        // Just in case rogue reused cell shows up and starts wreaking havoc
        cell.alpha = 0.0;
        self.isUIAvailable = YES;
        [self.repository removeImageAt:indexPath];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.repository getImagesCount];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AsyncImageViewCell * cell = (AsyncImageViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"asyncImageViewCell" forIndexPath:indexPath];
    if ([self.repository isPhotoDownloadedAt:indexPath]) {
        [cell didFinishLoadingImageWith:[self.repository getImageAt:indexPath]];
    } else {
        [self.repository downloadImageAt:indexPath];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isUIAvailable && [self.repository isPhotoDownloadedAt:indexPath]) {
        self.isUIAvailable = NO;
        [self deleteTheRowAtIndexPath:indexPath];
    }
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIDeviceOrientation * currentOrientation = (UIDeviceOrientation *)[UIDevice.currentDevice orientation];
    if (currentOrientation == (UIDeviceOrientation *)UIDeviceOrientationPortrait) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetWidth(collectionView.frame)) - 20);
    } else {
        return CGSizeMake((CGRectGetWidth(collectionView.frame) - 10) * 0.5, (CGRectGetWidth(collectionView.frame) - 10) * 0.5);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
}

#pragma mark <PhotosRepositoryDelegate>

- (void)imageDidAddAt:(NSIndexPath *)indexPath {
    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
}

- (void)imageFailedToDownloadAt:(NSIndexPath *)indexPath {
//    #warning not implemented
}

- (void)imageWasRemovedAt:(NSIndexPath *)indexPath {
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    if ([self.collectionView numberOfItemsInSection:0] == 1) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
}

- (void)imageDidStartDownloading:(NSIndexPath *)indexPath {
    AsyncImageViewCell * cell = (AsyncImageViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell willStartLoadingImage];
}

- (void)imageDidUpdateAt:(NSIndexPath *)indexPath {
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (void)repositoryDidReset {
    [self.refreshControl endRefreshing];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSourcePrefetch>

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    for (NSIndexPath * indexPath in indexPaths) {
        if (![self.repository isPhotoDownloadedAt:indexPath]) {
            [self.repository downloadImageAt:indexPath];
        }
    }
}

@end

