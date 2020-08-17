//
//  WebPhoto.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/15/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import "WebImage.h"

@interface WebImage ()

@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) id <WebImageNetworking> networking;

@end

@implementation WebImage

- (WebImage *)initWithUrl:(NSURL *)url andNetworking:(id<WebImageNetworking>)networking {
    self = [super init];
    if (self) {
        self.url = url;
        self.networking = networking;
        _status = kEmpty;
    }
    return self;
}

- (void)beginLoading {
    id <WebImageNetworkingRequest> request = [_networking constructRequestWith:self.url];
    request.delegate = self;
    _status = kInProgress;
    [request start];
}

- (void)didFailWith:(nullable NSError *)error {
    _status = kError;
    [self.delegate failedToLoadImage:self];
}

- (void)didReceiveWith:(nonnull NSData *)data {
    _status = kSuccess;
    self.image = [[UIImage alloc] initWithData:data];
    [self.delegate didLoadImage:self];
}

- (void)loadingInProgress {
    _status = kInProgress;
    [self.delegate imageIsLoading:self];
}

- (void)clearCachedData {
    _status = kEmpty;
    self.image = (UIImage *)[NSNull alloc];
}

@end
