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
    XCTAssertEqualObjects(self.button, sender);
    didAssert = YES;
  }];
  
  [tester tapViewWithAccessibilityLabel:self.titleButton];
  XCTAssertTrue(didAssert);
  
  
}

-(void)testSH_addControlEventTouchUpInsideWithBlock_theBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    didAssert = YES;
  }];
  
  [tester tapViewWithAccessibilityLabel:self.titleButton];
  XCTAssertTrue(didAssert);
  
}


-(void)testSample; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchDragExit withBlock:^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    XCTAssertEqualObjects(self.button, sender);
    didAssert = YES;
  }];
  
  [tester swipeViewWithAccessibilityLabel:self.titleButton inDirection:KIFSwipeDirectionLeft];
  XCTAssertTrue(didAssert);
}


@end
