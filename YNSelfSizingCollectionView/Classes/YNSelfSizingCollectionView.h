//
//  YNSelfSizingCollectionView.h
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNSelfSizingCollectionView : UICollectionView
/**
 *  caculate cell size
 *
 *  @param identifier    cell's reuse identifier
 *  @param indexPath     indexPath
 *  @param configuration fill cell with you feed data
 *
 *  @return the caculated cell's height
 */
- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(__kindof UICollectionViewCell *))configuration;

/**
 *  caculate cell size with a fixed width
 *
 *  @param identifier    cell's reuse identifier
 *  @param indexPath     indexPath
 *  @param fixedWidth    your expect width
 *  @param configuration fill cell with you feed data
 *
 *  @return the caculated cell's height
 */

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                             indexPath:(NSIndexPath *)indexPath
                            fixedWidth:(CGFloat)fixedWidth
                         configuration:(void (^)(__kindof UICollectionViewCell *cell))configuration;

/**
 *  caculate cell size with fixed height
 *
 *  @param identifier    cell's reuse identifier
 *  @param indexPath     indexPath
 *  @param fixedHeight    your expect height
 *  @param configuration fill cell with you feed data
 *
 *  @return the caculated cell's height
 */

- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                             indexPath:(NSIndexPath *)indexPath
                           fixedHeight:(CGFloat)fixedHeight
                         configuration:(void (^)(__kindof UICollectionViewCell *cell))configuration;

// invalidate Cache
-(void)invalidateCache;
@end
