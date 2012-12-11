//
//  DNSliderView.h
//  DNSliderView
//
//  Created by Xu Jun on 11/30/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DNSliderViewDelegate;

@interface DNSliderView : NSView

@property (nonatomic, assign) IBOutlet id <DNSliderViewDelegate> delegate;

@end

@protocol DNSliderViewDelegate <NSObject>

- (void)sliderStartSlide:(DNSliderView *)slideView;
- (void)sliderDidSlide:(DNSliderView *)slideView;

@end
