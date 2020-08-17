//
//  PhotosNetwork.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/15/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ImagesRepository.h"
#import "WebImageDelegate+WebImageNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ImagesRepository;
@protocol WebImageDelegate;
@protocol WebImageNetworking;

@interface ImagesNetworkStorage: NSObject <ImagesRepository, WebImageDelegate>

- (ImagesNetworkStorage *)initWithNetworking:(id <WebImageNetworking>)networking;

@end

NS_ASSUME_NONNULL_END
