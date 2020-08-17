//
//  AsyncNetworking.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/15/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebImage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AsyncNetworkingDelegate <WebImageNetworkingDelegate>

- (void)didReceiveWith:(NSData *)data;
- (void)didFailWith:(nullable NSError *)error;
- (void)loadingInProgress;

@end

@interface AsyncNetworkingRequest : NSObject <WebImageNetworkingRequest>

@property (nonatomic, weak) id <AsyncNetworkingDelegate> delegate;

- (void)start;

@end

@interface AsyncNetworking : NSObject <WebImageNetworking>

- (AsyncNetworkingRequest *)constructRequestWith:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
