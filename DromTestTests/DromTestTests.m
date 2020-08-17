//
//  DromTestTests.m
//  DromTestTests
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "ImagesRepository.h"
#include "ImagesMemoryStorage.h"
#include "ImagesRepositoryDelegate.h"

@interface DromTestTests : XCTestCase <ImagesRepositoryDelegate>

@end

@implementation DromTestTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPhotosInMemory {
    ImagesMemoryStorage * photosMemory = [ImagesMemoryStorage new];
    photosMemory.delegate = self;
    [photosMemory addImageWithUrl:@"0"];
    [photosMemory addImageWithUrl:@"1"];
    [photosMemory addImageWithUrl:@"2"];
    [photosMemory addImageWithUrl:@"3"];
    XCTAssert([photosMemory getImagesCount] == 10);
}

- (void)imageDidAddAt:(NSIndexPath *)indexPath {
    printf("✅ photoDidAddAt");
}

- (void)imageFailedToDownloadAt:(NSIndexPath *)indexPath {
    printf("✅ photoDidFailToDownloadAt");
}

- (void)imageWasRemovedAt:(NSIndexPath *)indexPath {
    printf("✅ photoDidRemoveAt");
}

- (void)imageDidStartDownloading:(NSIndexPath *)indexPath {
    printf("✅ photoDidStartDownloading");
}

- (void)imageDidUpdateAt:(NSIndexPath *)indexPath {
    printf("✅ photoDidUpdateAt");
}

- (void)repositoryDidReset {
    printf("✅ repositoryDidReset");
}

@end
