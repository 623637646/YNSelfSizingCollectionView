//
//  YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/4/28.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell.h"
#import "YNSelfSizingCollectionView.h"

@interface YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNDemoFrameLayoutFixedWidthAndHeightCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:30];
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = CGRectMake(20, 20, self.bounds.size.width - 40, 0);
    [self.label sizeToFit];
}

-(void)setTitle:(NSString *)title{
    self.label.text = title;
    [self setNeedsLayout];
}

+(YNSelfSizingCollectionViewCellLayoutType)layoutType{
    return YNSelfSizingCollectionViewCellLayoutTypeFrameLayout;
}

+(YNSelfSizingCollectionViewCellType)selfSizingType{
    return YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight;
}

+(CGFloat)fixedWidthWithCollectionView:(UICollectionView*)collectionView{
    return (int)(collectionView.bounds.size.width / 4.f);
}

+(CGFloat)fixedHeightWithCollectionView:(UICollectionView*)collectionView{
    return collectionView.bounds.size.width / 4.f;
}

@end
