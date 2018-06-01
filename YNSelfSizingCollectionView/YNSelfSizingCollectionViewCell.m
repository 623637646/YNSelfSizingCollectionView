//
//  YNSelfSizingCollectionViewCell.m
//
//  Created by wangya on 2018/1/29.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNSelfSizingCollectionViewCell.h"
#import "YNSelfSizingCollectionView.h"

@interface YNSelfSizingCollectionViewCell()
@property (nonatomic, copy) NSArray *contentViewConstraints;
@end

@implementation YNSelfSizingCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;
        if ([self.class layoutType] == YNSelfSizingCollectionViewCellLayoutTypeAutoLayout) {
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
            [self addConstraint:left];
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
            [self addConstraint:top];

        }
    }
    return self;
}

-(void)updateConstraints{
    if ([self.class layoutType] == YNSelfSizingCollectionViewCellLayoutTypeAutoLayout) {
        if (self.contentViewConstraints) {
            [self.contentView removeConstraints:self.contentViewConstraints];
            self.contentViewConstraints = nil;
        }
        NSArray *contentViewConstraints = [self generateConstraints];
        [self.contentView addConstraints:contentViewConstraints];
        self.contentViewConstraints = contentViewConstraints;
    }
    [super updateConstraints];
}

-(CGSize)sizeThatFits:(CGSize)size{
    if ([self isTestCell] && [self.class layoutType] == YNSelfSizingCollectionViewCellLayoutTypeFrameLayout) {
        switch ([self.class selfSizingType]) {
            case YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight:{
                return CGSizeMake([self.class fixedWidthWithCollectionView:self.collectionView], [self.class fixedHeightWithCollectionView:self.collectionView]);
                break;
            }
            case YNSelfSizingCollectionViewCellTypeFixedWidth:{
                self.frame = CGRectMake(0, 0, [self.class fixedWidthWithCollectionView:self.collectionView], 0);
                [self setNeedsLayout];
                [self layoutIfNeeded];
                return CGSizeMake([self.class fixedWidthWithCollectionView:self.collectionView], [self alignView].frame.size.height + [self alignView].frame.origin.y + [self alignOffset]);
                break;
            }
            case YNSelfSizingCollectionViewCellTypeFixedHeight:{
                self.frame = CGRectMake(0, 0, 0, [self.class fixedHeightWithCollectionView:self.collectionView]);
                [self setNeedsLayout];
                [self layoutIfNeeded];
                return CGSizeMake([self alignView].frame.size.width + [self alignView].frame.origin.x + [self alignOffset], [self.class fixedHeightWithCollectionView:self.collectionView]);
                break;
            }
            default:{
                NSAssert(NO, @"type invalid");
                break;
            }
        }
    }else{
        return [super sizeThatFits:size];
    }
}

#pragma public

+(YNSelfSizingCollectionViewCellLayoutType)layoutType{
    return YNSelfSizingCollectionViewCellLayoutTypeFrameLayout;
}

+(YNSelfSizingCollectionViewCellType)selfSizingType{
    return YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight;
}

+(CGFloat)fixedWidthWithCollectionView:(UICollectionView*)collectionView{
    return 0;
}

+(CGFloat)fixedHeightWithCollectionView:(UICollectionView*)collectionView{
    return 0;
}

-(UIView*)alignView{
    return nil;
}

-(CGFloat)alignOffset{
    return 0;
}

#pragma private
-(NSArray*)generateConstraints{
    NSMutableArray *array = [NSMutableArray array];
    switch ([self.class selfSizingType]) {
        case YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight:{
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self.class fixedWidthWithCollectionView:self.collectionView]];
            [array addObject:width];
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self.class fixedHeightWithCollectionView:self.collectionView]];
            [array addObject:height];
            break;
        }
        case YNSelfSizingCollectionViewCellTypeFixedWidth:{
            // width
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self.class fixedWidthWithCollectionView:self.collectionView]];
            [array addObject:width];
            
            if (![self alignView]) {
                NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self alignOffset]];
                [array addObject:height];
            }else{
                NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self alignView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:[self alignOffset]];
                [array addObject:bottom];
            }
            break;
        }
        case YNSelfSizingCollectionViewCellTypeFixedHeight:{
            // height
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self.class fixedHeightWithCollectionView:self.collectionView]];
            [array addObject:height];
            
            if (![self alignView]) {
                NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self alignOffset]];
                [array addObject:width];
            }else{
                NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:[self alignView] attribute:NSLayoutAttributeRight multiplier:1.0 constant:[self alignOffset]];
                [array addObject:right];
            }
            break;
        }
        default:{
            NSAssert(NO, @"type invalid");
            break;
        }
    }
    return array;
}

@end

