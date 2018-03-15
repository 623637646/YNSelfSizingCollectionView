//
//  YNDemoFixedWidthCollectionViewCell.m
//  YNSelfSizingCollectionViewDemo
//
//  Created by wangya on 2018/1/26.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNDemoFixedWidthCollectionViewCell.h"

@interface YNDemoFixedWidthCollectionViewCell()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNDemoFixedWidthCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:30];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:label];
        [self.contentView addConstraints:({
            NSMutableArray<NSLayoutConstraint *> *constraint = [[NSMutableArray<NSLayoutConstraint *> alloc] init];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20]];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20]];
            [constraint addObject:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
            
            constraint;
        })];
        self.label = label;
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    self.label.text = title;
    [self setNeedsUpdateConstraints];
}

-(YNSelfSizingCollectionViewCellType) type{
    return YNSelfSizingCollectionViewCellTypeFixedWidth;
}

-(CGFloat)fixedWidth{
    return [UIScreen mainScreen].bounds.size.width / 4.f;
}

-(UIView*)alignView{
    return self.label;
}

-(CGFloat)alignOffset{
    return 20;
}
@end
