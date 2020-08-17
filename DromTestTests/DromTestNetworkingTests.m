//
//  DromTestNetworkingTests.m
//  DromTestTests
//
//  Created by Eduard Dzhumagaliev on 8/15/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AsyncNetworking.h"

@interface DromTestNetworkingTests : XCTestCase <AsyncNetworkingDelegate>

@property (atomic, strong) XCTestExpectation * didReceiveWith;
@property (atomic, strong) XCTestExpectation * didReceiveError;

@end

@implementation DromTestNetworkingTests

- (void)setUp {
    self.didReceiveWith = [[XCTestExpectation alloc] initWithDescription:@"Did receive data from networking class"];
    self.didReceiveError = [[XCTestExpectation alloc] initWithDescription:@"Did receive error from networking class"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNetworking {
    NSURL * url = [NSURL URLWithString:@"http://terriblegoodday.github.io/assets/drom-test-networking/0.png"];
    
    AsyncNetworking * networking = [AsyncNetworking alloc];
    AsyncNetworkingRequest * request = [networking constructRequestWith:url];
    request.delegate = self;
    [request start];
    
    [self waitForExpectations:@[self.didReceiveWith] timeout:10.0];
}

- (void)didReceiveWith:(NSData *)data {
    printf("✅ Did receive data with\n");
    [self.didReceiveWith fulfill];
}

- (void)loadingInProgress {
    printf("✅ Loading in progress\n");
}

- (void)testNetworkingError {
    NSURL * url = [NSURL URLWithString:@"rfiuofjhdsiofh"];
    AsyncNetworking * networking = [AsyncNetworking alloc];
    AsyncNetworkingRequest * request = [networking constructRequestWith:url];
    request.delegate = self;
    [request start];
    
    [self waitForExpectations:@[self.didReceiveError] timeout:15.0];
}

- (void)didFailWith:(nullable NSError *)error {
    printf("✅ Did receive error\n");
    [self.didReceiveError fulfill];
}

@end
