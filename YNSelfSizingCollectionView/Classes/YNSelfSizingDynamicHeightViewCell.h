//
//  YNSelfSizingDynamicHeightViewCell.h
//  YNSelfSizingCollectionView
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNSelfSizingDynamicHeightViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *dynamicHeightAlignView;
@property (nonatomic, assign) CGFloat dynamicHeightAlignOffset;
@end
