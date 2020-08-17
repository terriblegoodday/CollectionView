//
//  PhotosNetwork.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/15/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import "ImagesNetworkStorage.h"
#import "WebImage.h"
#import "ImagesRepository.h"
#import "ImagesRepositoryDelegate.h"

static int const kMutableArrayCapacity = 100;

@interface ImagesNetworkStorage ()

@property (nonatomic, strong) id <WebImageNetworking> networking;
@property (nonatomic, strong) NSMutableArray<WebImage *> * images;
@property (nonatomic, strong) NSMutableArray<WebImage *> * defaultImages;

@end

@implementation ImagesNetworkStorage

@synthesize delegate;

- (NSIndexPath *)addItemToPhotos:(NSString *)url {
    NSURL * plainUrl = [NSURL URLWithString:url];
    WebImage * photo = [[WebImage alloc] initWithUrl:plainUrl andNetworking:_networking];
    photo.delegate = self;
    [self.images addObject:photo];
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[self.images indexOfObject:photo] inSection:0];
    return indexPath;
}

- (void)addInitialImages {
    [self addItemToPhotos:@"http://terriblegoodday.github.io/assets/drom-test-networking/0.png"];
    [self addItemToPhotos:@"http://terriblegoodday.github.io/assets/drom-test-networking/1.jpg"];
    [self addItemToPhotos:@"http://terriblegoodday.github.io/assets/drom-test-networking/2.png"];
    [self addItemToPhotos:@"http://terriblegoodday.github.io/assets/drom-test-networking/3.png"];
    [self addItemToPhotos:@"http://terriblegoodday.github.io/assets/drom-test-networking/4.png"];
    [self addItemToPhotos:@"http://terriblegoodday.github.io/assets/drom-test-networking/5.png"];
    
    // Some highres images to test performance
    // CollectionView occasionally stops showing activity view because the image is set to the
    // ImageView but the drawing process's not completed
    // Also the system's built-in cache is intelligent enough not to waste space on too much high-res images
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/mercedes/HERO_v2_back-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/mercedes/HERO_module-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/mercedes/HERO_little_snake_b__-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/mercedes/Screen_Shot_2020-07-15_at_12.59.01_AM_-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/mercedes/db_pedro_garage_(2)-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/ark/ARK-1_(FRONT)-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/lot2046/toothbrush_hero-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/lot2046/lotman_hero-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/snap/HERO_kids_see_ghosts-1600.png"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/yeezy/3-1600.png"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/yeezy/aa-rd_1-0000lost__---00---_-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/yeezy/d1_0001-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/yeezy/IMG_1193-1600.JPG"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/yeezy/IMG_4967-1600.jpeg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/kkw/1___0001_-1600.jpg"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/airbnb-samara/IMG_7864-1600.JPG"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/airbnb-samara/IMG_8626-1600.JPG"];
//    [self addItemToPhotos:@"https://2046lab.com/thumbs/airbnb-samara/Screen_Shot_2020-02-19_at_9.53.23_PM-1600.png"];
//    [self addItemToPhotos:@"https://images.unsplash.com/photo-1597176874083-193e47324499?ixlib=rb-1.2.1&auto=format"];
}

- (ImagesNetworkStorage *)initWithNetworking:(id<WebImageNetworking>)networking {
    self = [super init];
    if (self) {
        self.networking = networking;
        self.images = [[NSMutableArray alloc] initWithCapacity:kMutableArrayCapacity];
        [self addInitialImages];
        self.defaultImages = [self.images mutableCopy];
    }
    return self;
}

- (void)clearCachedData {
    for (WebImage * photo in self.images) {
        [photo clearCachedData];
    }
    for (WebImage * defaultPhoto in self.defaultImages) {
        [defaultPhoto clearCachedData];
    }
    
    [NSURLCache.sharedURLCache removeAllCachedResponses];
}

- (UIImage *)getImageAt:(NSIndexPath *)indexPath {
    return self.images[indexPath.row].image;
}

- (NSUInteger)getImagesCount {
    return [self.images count];
}

- (void)downloadImageAt:(NSIndexPath *)indexPath {
    if (self.images[indexPath.row].status != kInProgress) {
        [self.images[indexPath.row] beginLoading];
    };
}

- (BOOL)isPhotoDownloadedAt:(NSIndexPath *)indexPath {
    return (self.images[indexPath.row].status == kSuccess);
}

- (void)removeImageAt:(NSIndexPath *)indexPath {
    [self.images removeObjectAtIndex:indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->delegate imageWasRemovedAt:indexPath];
    });
}

- (void)addImageWithUrl:(NSString *)url {
    NSIndexPath * indexPath = [self addItemToPhotos:url];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->delegate imageDidAddAt:indexPath];
    });
}

- (void)refresh {
    sleep(1);
//    Uncomment this line to clear cache on refresh
//    [self clearCachedData];
    _images = [self.defaultImages mutableCopy];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->delegate repositoryDidReset];
    });
}

#pragma mark <WebPhotoNetworkingDelegate>

- (void)failedToLoadImage:(nonnull WebImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[self.images indexOfObject:image] inSection:0];
        [self->delegate imageFailedToDownloadAt:indexPath];
    });
}

- (void)didLoadImage:(nonnull WebImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[self.images indexOfObject:image] inSection:0];
        [self->delegate imageDidUpdateAt:indexPath];
    });
}

- (void)imageIsLoading:(nonnull WebImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:[self.images indexOfObject:image] inSection:0];
        [self->delegate imageDidStartDownloading:indexPath];
    });
}

@end
