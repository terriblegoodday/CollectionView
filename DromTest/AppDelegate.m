//
//  AppDelegate.m
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import "ImagesRepositoryDelegate.h"
#import "ImagesRepository.h"

#import "AppDelegate.h"
#import "CollectionViewController.h"
#import "SwipeRightFlowLayout.h"
#import "ImagesMemoryStorage.h"
#import "ImagesNetworkStorage.h"
#import "AsyncNetworking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)setupCache {
    NSURLCache.sharedURLCache.diskCapacity = 1024 * 1024;
    NSURLSession.sharedSession.configuration.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
}

- (CollectionViewController *)setupCollectionView {
    UICollectionViewFlowLayout * flowLayout = [SwipeRightFlowLayout new];
    //    PhotosMemory * photosMemory = [PhotosMemory new];
    ImagesNetworkStorage * photosNetwork = [[ImagesNetworkStorage alloc] initWithNetworking:[AsyncNetworking new]];
    CollectionViewController * rootViewController = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout andRepository:photosNetwork];
    return rootViewController;
}

- (void)setupNavigationController {
    CollectionViewController * rootViewController = [self setupCollectionView];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
}

- (void)setupMainWindow {
    CGRect windowFrame = UIScreen.mainScreen.bounds;
    UIWindow *theWindow = [[UIWindow alloc] initWithFrame:windowFrame];
    self.window = theWindow;
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupCache];
    [self setupNavigationController];
    [self setupMainWindow];
    return YES;
}

@end
