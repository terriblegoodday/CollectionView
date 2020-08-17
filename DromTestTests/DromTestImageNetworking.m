//
//  DromTestPhotosNetworking.m
//  DromTestTests
//
//  Created by Eduard Dzhumagaliev on 8/15/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ImagesNetworkStorage.h"
#import "ImagesRepositoryDelegate.h"
#import "AsyncNetworking.h"

@interface DromTestImageNetworking : XCTestCase <ImagesRepositoryDelegate>

@property (nonatomic, strong) ImagesNetworkStorage * photosRepository;
@property (nonatomic, strong) XCTestExpectation * didLoad;
@property (nonatomic, strong) XCTestExpectation * didFinishWithError;

@end

@implementation DromTestImageNetworking

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    AsyncNetworking * networking = [AsyncNetworking new];
    self.photosRepository = [[ImagesNetworkStorage alloc] initWithNetworking:networking];
    self.photosRepository.delegate = self;
    self.didLoad = [[XCTestExpectation alloc] initWithDescription:@"[photosnetwork] did load the repository"];
    self.didFinishWithError = [[XCTestExpectation alloc] initWithDescription:@"[photosnetwork] did finish with error]"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPhotoAdd {
    [self.photosRepository downloadImageAt:[NSIndexPath indexPathForItem:0 inSection:0]];
    [self waitForExpectations:@[self.didLoad] timeout:10.0];
}

- (void)testPhotoDownloadError {
    [self.photosRepository addImageWithUrl:@"4342"];
    [self.photosRepository downloadImageAt:[NSIndexPath indexPathForItem:6 inSection:0]];
    [self waitForExpectations:@[self.didFinishWithError] timeout:10.0];
}

- (void)imageWasRemovedAt:(NSIndexPath *)indexPath {
    printf("✅ [photosnetwork] Photo did remove at\n");
}

- (void)imageDidAddAt:(NSIndexPath *)indexPath {
    printf("✅ [photosnetwork] Photo did add at \n");
}

- (void)imageDidStartDownloading:(NSIndexPath *)indexPath {
    printf("✅ [photosnetwork] Photo did start downloading at \n");
}

- (void)imageDidUpdateAt:(NSIndexPath *)indexPath {
    printf("✅ [photosnetwork] Photo did update at \n");
    [self.didLoad fulfill];
}

- (void)imageFailedToDownloadAt:(NSIndexPath *)indexPath {
    printf("✅ [photosnetwork] Photo did fail to download at \n");
    [self.didFinishWithError fulfill];
}

- (void)repositoryDidReset {
    printf("✅ [photosnetwork] Repository did reset \n");
}


@end
