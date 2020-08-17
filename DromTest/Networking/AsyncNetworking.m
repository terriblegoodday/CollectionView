//
//  AsyncNetworking.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/15/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import "AsyncNetworking.h"

@interface AsyncNetworking ()

@property (nonatomic, strong) NSURL * url;

@end

@interface AsyncNetworkingRequest ()

@property (nonatomic, strong) NSURL * url;

@end

@implementation AsyncNetworkingRequest

- (AsyncNetworkingRequest *)initWith:(NSURL *)url {
    self = [self init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (void)start {
    [self.delegate loadingInProgress];
    [[NSURLSession.sharedSession dataTaskWithURL:_url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self->_delegate didFailWith:error];
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self->_delegate didReceiveWith:data];
            });
        }
    }] resume];
}

@end

@implementation AsyncNetworking

- (AsyncNetworkingRequest *)constructRequestWith:(NSURL *)url {
    AsyncNetworkingRequest * request = [[AsyncNetworkingRequest alloc] initWith:url];
    return request;
}

@end
