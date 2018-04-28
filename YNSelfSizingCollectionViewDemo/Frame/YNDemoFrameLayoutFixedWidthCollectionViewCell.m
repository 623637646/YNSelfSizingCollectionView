//
//  YNDemoFrameLayoutFixedWidthCollectionViewCell.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/4/28.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNDemoFrameLayoutFixedWidthCollectionViewCell.h"
#import "YNSelfSizingCollectionView.h"

@interface YNDemoFrameLayoutFixedWidthCollectionViewCell()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNDemoFrameLayoutFixedWidthCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:30];
        label.translatesAutoresizingMaskIntoConstraints = NO;
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

-(YNSelfSizingCollectionViewCellLayoutType)layoutType{
    return YNSelfSizingCollectionViewCellLayoutTypeFrameLayout;
}

-(YNSelfSizingCollectionViewCellType)selfSizingType{
    return YNSelfSizingCollectionViewCellTypeFixedWidth;
}

-(CGFloat)fixedWidth{
    return (int)(self.collectionView.bounds.size.width / 4.f);
}

-(UIView*)alignView{
    return self.label;
}

-(CGFloat)alignOffset{
    return 20;
}
@end
