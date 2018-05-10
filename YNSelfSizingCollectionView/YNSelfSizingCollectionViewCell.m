//
//  YNSelfSizingCollectionViewCell.m
//
//  Created by wangya on 2018/1/29.
//  Copyright © 2018年 Yanni. All rights reserved.
//

#import "YNSelfSizingCollectionViewCell.h"

@interface YNSelfSizingCollectionViewCell()
@property (nonatomic, copy) NSArray *contentViewConstraints;
@end

@implementation YNSelfSizingCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;
        if ([self layoutType] == YNSelfSizingCollectionViewCellLayoutTypeAutoLayout) {
            self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        }
    }
    return self;
}

-(void)updateConstraints{
    if ([self layoutType] == YNSelfSizingCollectionViewCellLayoutTypeAutoLayout) {
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
    if ([self isTestCell] && [self layoutType] == YNSelfSizingCollectionViewCellLayoutTypeFrameLayout) {
        switch ([self selfSizingType]) {
            case YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight:{
                return CGSizeMake([self fixedWidth], [self fixedHeight]);
                break;
            }
            case YNSelfSizingCollectionViewCellTypeFixedWidth:{
                self.frame = CGRectMake(0, 0, [self fixedWidth], 0);
                [self setNeedsLayout];
                [self layoutIfNeeded];
                return CGSizeMake([self fixedWidth], [self alignView].frame.size.height + [self alignView].frame.origin.y + [self alignOffset]);
                break;
            }
            case YNSelfSizingCollectionViewCellTypeFixedHeight:{
                self.frame = CGRectMake(0, 0, 0, [self fixedHeight]);
                [self setNeedsLayout];
                [self layoutIfNeeded];
                return CGSizeMake([self alignView].frame.size.width + [self alignView].frame.origin.x + [self alignOffset], [self fixedHeight]);
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

-(YNSelfSizingCollectionViewCellType)selfSizingType{
    return YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight;
}

-(YNSelfSizingCollectionViewCellLayoutType)layoutType{
    return YNSelfSizingCollectionViewCellLayoutTypeFrameLayout;
}

-(CGFloat)fixedWidth{
    return 0;
}

-(CGFloat)fixedHeight{
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
    switch ([self selfSizingType]) {
        case YNSelfSizingCollectionViewCellTypeFixedWidthAndHeight:{
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self fixedWidth]];
            [array addObject:width];
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self fixedHeight]];
            [array addObject:height];
            break;
        }
        case YNSelfSizingCollectionViewCellTypeFixedWidth:{
            // width
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self fixedWidth]];
            [array addObject:width];
            
            if (![self alignView]) {
                NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:0];
                [array addObject:height];
            }else{
                NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[self alignView] attribute:NSLayoutAttributeBottom multiplier:1.0 constant:[self alignOffset]];
                [array addObject:bottom];
            }
            break;
        }
        case YNSelfSizingCollectionViewCellTypeFixedHeight:{
            // height
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:[self fixedHeight]];
            [array addObject:height];
            
            if (![self alignView]) {
                NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:0];
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

