//
//  CollectionViewModel.h
//  DromTest
//
//  Created by Eduard Dzhumagaliev on 8/14/20.
//  Copyright © 2020 Eduard Dzhumagaliev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (strong, nonatomic) NSArray<NSURL *> * urlsToLoad;

@end

NS_ASSUME_NONNULL_END
