//
//  WebPhoto.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/15/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WebImageDelegate+WebImageNetworking.h"

@class UIImage;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WebImageStatus) {
    kInProgress,
    kError,
    kSuccess,
    kEmpty
};

@interface WebImage : NSObject <WebImageNetworkingDelegate>

@property (nonatomic, weak) id <WebImageDelegate> delegate;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, readonly) WebImageStatus status;
@property (nonatomic, strong) UIImage * image;

- (WebImage *)initWithUrl:(NSURL *)url andNetworking:(id <WebImageNetworking>)networking;
- (void)beginLoading;
- (void)clearCachedData;

@end

NS_ASSUME_NONNULL_END
