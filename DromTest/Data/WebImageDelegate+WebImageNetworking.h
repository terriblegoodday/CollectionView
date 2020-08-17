//
//  WebImageDelegate.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/16/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#ifndef WebImageDelegate_h
#define WebImageDelegate_h

NS_ASSUME_NONNULL_BEGIN

@class WebImage;

@protocol WebImageDelegate

- (void)didLoadImage:(WebImage *)photo;
- (void)imageIsLoading:(WebImage *)photo;
- (void)failedToLoadImage:(WebImage *)photo;

@end

@protocol WebImageNetworkingDelegate

- (void)didReceiveWith:(NSData *)data;
- (void)didFailWith:(nullable NSError *)error;
- (void)loadingInProgress;

@end

@protocol WebImageNetworkingRequest

@property (nonatomic, weak) id <WebImageNetworkingDelegate> delegate;

- (void)start;

@end

@protocol WebImageNetworking

- (id <WebImageNetworkingRequest>)constructRequestWith:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END

#endif /* WebImageDelegate_h */
