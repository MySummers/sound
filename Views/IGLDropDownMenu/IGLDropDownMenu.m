//
//  IGLDropDownMenu.m
//  IGLDropDownMenuDemo
//
//  Created by Galvin Li on 8/30/14.
//  Copyright (c) 2014 Galvin Li. All rights reserved.
//

#import "IGLDropDownMenu.h"

@interface IGLDropDownMenu ()

@property (nonatomic, strong) IGLDropDownItem *menuButton;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CGRect oldFrame;

@end

@implementation IGLDropDownMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self resetParams];
        self.menuButton = [[IGLDropDownItem alloc] init];
    }
    return self;
}

- (void)setExpanding:(BOOL)expanding
{
    _expanding = expanding;
    
    [self updateView];
}

- (CGFloat)alphaOnFold
{
    if (_alphaOnFold != -1) {
        return _alphaOnFold;
    }
    if ([self isSlidingInType]) {
        return 0.0;
    }
    return 1.0;
}

- (void)resetParams
{
    self.frame = self.oldFrame;
    self.offsetX = 0;
    
    self.animationDuration = 0.3;
    self.animationOption = UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState;
    self.itemAnimationDelay = 0.0;
    self.rotate = IGLDropDownMenuRotateNone;
    self.type = IGLDropDownMenuTypeNormal;
    self.slidingInOffset = -1;
    self.gutterY = 0;
    self.alphaOnFold = -1;
    self.flipWhenToggleView = NO;
    _expanding = NO;
    
    self.selectedIndex = -1;
}

- (void)reloadView
{
    if (self.isExpanding) {
        self.frame = self.oldFrame;
    } else {
        self.oldFrame = self.frame;
    }
    self.itemSize = self.frame.size;
    // clear all subviews
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    if (self.rotate == IGLDropDownMenuRotateLeft) {
        self.offsetX = self.dropDownItems.count * self.dropDownItems.count * self.itemSize.height / 28;
    }
    
    [self setFrame:CGRectMake(self.frame.origin.x - self.offsetX, self.frame.origin.y, self.frame.size.width + self.gutterY, self.frame.size.height)];
    
    for (int i = (int)self.dropDownItems.count - 1; i >= 0; i--) {
        IGLDropDownItem *item = self.dropDownItems[i];
        item.index = i;
        item.paddingLeft = self.paddingLeft;
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self setUpFoldItem:item];
        [self addSubview:item];
    }
    
    self.menuButton.iconImage = self.menuIconImage;
    self.menuButton.text = self.menuText;
    self.menuButton.paddingLeft = self.paddingLeft;
    self.menuButton.layer.anchorPoint = CGPointMake(0.5, 0);
    [self.menuButton setFrame:CGRectMake(self.offsetX + 0, 0, self.itemSize.width, self.itemSize.height)];
    [self.menuButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.menuButton];
    
    [self updateSelfFrame];
    
}

- (BOOL)isSlidingInType
{
    switch (self.type) {
        case IGLDropDownMenuTypeNormal:
        case IGLDropDownMenuTypeStack:
            return NO;
        case IGLDropDownMenuTypeSlidingInBoth:
        case IGLDropDownMenuTypeSlidingInFromLeft:
        case IGLDropDownMenuTypeSlidingInFromRight:
            return YES;
        default:
            return NO;
    }
}

- (void)updateSelfFrame
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat height = CGRectGetHeight(self.menuButton.frame);
    CGFloat width = CGRectGetWidth(self.menuButton.frame);
    if (self.isExpanding) {
        for (IGLDropDownItem *item in self.dropDownItems) {
            if (item.alpha > 0) {
                height = MAX(height, CGRectGetMaxY(item.frame));
                width = MAX(width, CGRectGetMaxX(item.frame));
            }
        }
    }
    [self setFrame:CGRectMake(x, y, width, height)];
}

- (void)toggleView
{
    self.expanding = !self.isExpanding;
}

- (void)updateView
{
    if (self.shouldFlipWhenToggleView) {
        [self flipMainButton];
    }
    
    if (self.isExpanding) {
        [self expandView];
    } else {
        [self foldView];
    }
    
}

- (void)expandView
{
    // expand the view
    
    for (int i = (int)self.dropDownItems.count - 1; i >= 0; i--) {
        IGLDropDownItem *item = self.dropDownItems[i];
        CGFloat delay = 0;
        // item expand after the main button flip up
        if (self.shouldFlipWhenToggleView) {
            delay += 0.1;
        }
        if ([self isSlidingInType]) {
            // first item move first
            delay += self.itemAnimationDelay * i;
        } else {
            // last item move first
            delay += self.itemAnimationDelay * (self.dropDownItems.count - i - 1);
        }
        [UIView animateWithDuration:self.animationDuration delay:delay options:self.animationOption animations:^{
            [self setUpExpandItem:item];
        } completion:^(BOOL finished) {
            [self updateSelfFrame];
        }];
    }
    
}

- (void)foldView
{
    // fold the view
    
    for (int i = (int)self.dropDownItems.count - 1; i >= 0; i--) {
        IGLDropDownItem *item = self.dropDownItems[i];
        CGFloat delay = 0;
        // item fold after the main button flip up
        if (self.shouldFlipWhenToggleView) {
            delay += 0.1;
        }
        if ([self isSlidingInType]) {
            // last item move first
            delay += self.itemAnimationDelay * (self.dropDownItems.count - i - 1);
        } else {
            // first item move first
            delay += self.itemAnimationDelay * i;
        }
        [UIView animateWithDuration:self.animationDuration delay:delay options:self.animationOption animations:^{
            [self setUpFoldItem:item];
        } completion:^(BOOL finished) {
            [self updateSelfFrame];
        }];
    }
}

- (void)setUpExpandItem:(IGLDropDownItem*)item
{
    // set alpha for slidingIn
    item.alpha = 1.0;
    
    // set frame (MUST before rotation reset)
    [item setFrame:[self frameOnExpandForItemAtIndex:item.index]];
    
    // set rotate
    item.transform = [self transformOnExpandForItemAtIndex:item.index];
}

- (void)setUpFoldItem:(IGLDropDownItem*)item
{
    // reset rotate
    item.transform = CGAffineTransformMakeRotation(0);
    
    // set frame (MUST after rotation reset)
    [item setFrame:[self frameOnFoldForItemAtIndex:item.index]];
    
    // set alpha for slidingIn
    item.alpha = self.alphaOnFold;
}

- (void)flipMainButton
{
    CABasicAnimation *topAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    topAnimation.autoreverses = YES;
    topAnimation.duration = 0.2;
    topAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DPerspect(CATransform3DMakeRotation(M_PI_2/3*2, 1, 0, 0), CGPointMake(0, 0), 400)];
    [self.menuButton.layer addAnimation:topAnimation forKey:nil];
}

- (CGRect)frameOnFoldForItemAtIndex:(NSInteger)index
{
    CGFloat x = self.offsetX;
    CGFloat y = 0;
    CGFloat width = self.itemSize.width;
    CGFloat height = self.itemSize.height;
    
    NSInteger count = index >= 2 ? 2 : index;
    CGFloat slidingInOffect = self.slidingInOffset != -1 ? self.slidingInOffset : self.itemSize.width / 3;
    
    switch (self.type) {
        case IGLDropDownMenuTypeNormal:
            // just take the default value
            break;
        case IGLDropDownMenuTypeStack:
            x += count * 2;
            y = (count + 1) * 3;
            width -= count * 4;
            break;
        case IGLDropDownMenuTypeSlidingInBoth:
            if (index % 2 != 0) {
                slidingInOffect = -slidingInOffect;
            }
            x = slidingInOffect;
            y = (index + 1) * (height + self.gutterY);
            break;
        case IGLDropDownMenuTypeSlidingInFromLeft:
            x = -slidingInOffect;
            y = (index + 1) * (height + self.gutterY);
            break;
        case IGLDropDownMenuTypeSlidingInFromRight:
            x = slidingInOffect;
            y = (index + 1) * (height + self.gutterY);
            break;
        default:
            break;
    }
    
    return CGRectMake(x, y, width, height);
}

- (CGRect)frameOnExpandForItemAtIndex:(NSInteger)index
{
    CGFloat x = 0;
    CGFloat y = (index + 1) * (self.itemSize.height + self.gutterY);
    CGFloat width = self.itemSize.width;
    CGFloat height = self.itemSize.height;
    
    switch (self.rotate) {
        case IGLDropDownMenuRotateNone:
            // just take the default value
            break;
        case IGLDropDownMenuRotateLeft:
            x = self.offsetX + -index * index * self.itemSize.height / 20.0;
            break;
        case IGLDropDownMenuRotateRight:
            x = index * index * self.itemSize.height / 20.0;
            break;
        case IGLDropDownMenuRotateRandom:
            x = floor([self random0to1] * 11 - 5);
            break;
        default:
            break;
    }
    
    return CGRectMake(x, y, width, height);
}

- (CGAffineTransform)transformOnExpandForItemAtIndex:(NSInteger)index
{
    CGFloat angle = 0;
    switch (self.rotate) {
        case IGLDropDownMenuRotateNone:
            // just take the default value
            break;
        case IGLDropDownMenuRotateLeft:
            angle = 5.0 * index / 180.0 * M_PI;
            break;
        case IGLDropDownMenuRotateRight:
            angle = -5.0 * index / 180.0 * M_PI;
            break;
        case IGLDropDownMenuRotateRandom:
            angle = floor([self random0to1] * 11 - 5) / 180.0 * M_PI;
            break;
        default:
            break;
    }
    return CGAffineTransformMakeRotation(angle);
}

#pragma mark - button action

- (void)itemClicked:(IGLDropDownItem*)sender
{
    if (self.isExpanding) {
        self.menuButton.iconImage = sender.iconImage;
//        self.expanding = NO;
        self.selectedIndex = sender.index;
        if ([self.delegate respondsToSelector:@selector(selectedItemAtIndex:)]) {
            [self.delegate selectedItemAtIndex:self.selectedIndex];
        }
    }
}

#pragma mark -

- (float)random0to1
{
    return [self randomFloatBetween:0.0 andLargerFloat:1.0];
}

- (float)randomFloatBetween:(float)num1 andLargerFloat:(float)num2
{
    int startVal = num1*10000;
    int endVal = num2*10000;
    
    int randomValue = startVal +(arc4random()%(endVal - startVal));
    float a = randomValue;
    
    return(a /10000.0);
}

CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
