//
//  SHActionSheetBlocksCallbacksScenarion.m
//  Example
//
//  Created by Seivan Heidari on 7/31/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHControlBlocksSuper.h"


@interface SHControlBlocksCallbacksIntegration : SHControlBlocksSuper

@end

@implementation SHControlBlocksCallbacksIntegration

#pragma mark - Add block
-(void)testSH_addControlEvents_withBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchUpInside withBlock:^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssert = YES;
  }];
  
  [tester tapViewWithAccessibilityLabel:self.titleButton];
  STAssertTrue(didAssert, nil);
  
  
}

-(void)testSH_addControlEventTouchUpInsideWithBlock_theBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssert = YES;
  }];
  
  [tester tapViewWithAccessibilityLabel:self.titleButton];
  STAssertTrue(didAssert, nil);
  
}


-(void)testSample; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchDragExit withBlock:^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    STAssertEqualObjects(self.button, sender, nil);
    didAssert = YES;
  }];
  
  [tester swipeViewWithAccessibilityLabel:self.titleButton inDirection:KIFSwipeDirectionLeft];
  STAssertTrue(didAssert, nil);
}


@end
