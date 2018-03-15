//
//  YNSelfSizingCollectionView.h
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNSelfSizingCollectionViewCell.h"

@interface YNSelfSizingCollectionView : UICollectionView


- (CGSize)sizeForCellWithIdentifier:(NSString *)identifier
                          indexPath:(NSIndexPath *)indexPath
                      configuration:(void (^)(__kindof YNSelfSizingCollectionViewCell *))configuration;

- (void)invalidateCache;
@end
