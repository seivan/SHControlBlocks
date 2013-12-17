//
//  SHActionSheetBlocksCallbacksScenarion.m
//  Example
//
//  Created by Seivan Heidari on 7/31/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHControlBlocksSuper.h"


@interface SHControlBlocksSelectors : SHControlBlocksSuper

@end

@implementation SHControlBlocksSelectors

#pragma mark - Add block
-(void)testSH_addControlEvents_withBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchUpInside withBlock:^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    
    didAssert = YES;
  }];
  
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  XCTAssertTrue(didAssert);
  
  
}

-(void)testSH_addControlEventTouchUpInsideWithBlock_theBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    XCTAssertEqualObjects(self.button, sender);
    didAssert = YES;
  }];
  
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  XCTAssertTrue(didAssert);
  
}


#pragma mark - Remove block
-(void)testSH_removeControlEventTouchUpInside; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    XCTFail();
    didAssert = YES;
  }];
  
  [self.button SH_removeControlEventTouchUpInside];
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  XCTAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].count == 0);
  XCTAssertFalse(didAssert);
  
  
}

-(void)testSH_removeBlocksForControlEvents; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchUpInside withBlock:^(UIControl *sender) {
    didAssert = YES;
  }];
  
  [self.button SH_removeBlocksForControlEvents:UIControlEventTouchUpInside];
  XCTAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].count == 0);

  XCTAssertFalse(didAssert);

  
}
-(void)testSH_removeControlEventsForBlock; {
  __block BOOL didAssert = NO;
  self.block = ^(UIControl * theSender ){
    didAssert = YES;
  };
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];

  [self.button SH_removeControlEventsForBlock:self.block];
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  XCTAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].count == 0);

  XCTAssertFalse(didAssert);

  
}
-(void)testSH_removeAllControlEventsBlocks; {
  __block BOOL didAssertFirstBlock  = NO;
  __block BOOL didAssertSecondBlock = NO;
  self.block = ^(UIControl * theSender ){
    didAssertFirstBlock = YES;
  };

  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  [self.button SH_addControlEvents:UIControlEventTouchDragInside withBlock:^(UIControl *sender) {
    didAssertSecondBlock = NO;
  }];
  
  [self.button SH_removeAllControlEventsBlocks];
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  XCTAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].count == 0);

  XCTAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchDragInside].count == 0);

  XCTAssertFalse(didAssertFirstBlock);
  XCTAssertFalse(didAssertSecondBlock);

}


#pragma mark - Helpers
-(void)testSH_blocksForControlEvents; {
  UIControlEvents event = UIControlEventTouchDragExit;
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  [self.button SH_addControlEvents:event withBlock:self.block];
  
  NSSet * blockSet = [NSSet setWithArray:@[self.block]];
  XCTAssertEqualObjects(blockSet,
                 [self.button SH_blocksForControlEvents:event]);
  
  XCTAssertEqualObjects(blockSet,
                       [self.button SH_blocksForControlEvents:UIControlEventTouchUpInside]);
  
}

-(void)testSH_controlEventsForBlock; {
  UIControlEvents event = UIControlEventTouchDragExit;
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  [self.button SH_addControlEvents:event withBlock:self.block];

  NSSet * eventSet = [self.button SH_controlEventsForBlock:self.block];
  XCTAssertEqual(eventSet.count, 2U);
  
  XCTAssertTrue([eventSet containsObject:@(UIControlEventTouchUpInside)]);
  XCTAssertTrue([eventSet containsObject:@(event)]);
}


#pragma mark - Properties


#pragma mark - Getters
-(void)testSH_isTouchUpInsideEnabled; {
  XCTAssertFalse(self.button.SH_isTouchUpInsideEnabled);
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  XCTAssertTrue(self.button.SH_isTouchUpInsideEnabled);
  [self.button SH_removeControlEventTouchUpInside];
  XCTAssertFalse(self.button.SH_isTouchUpInsideEnabled);
}

-(void)testSH_controlBlocks; {
  XCTAssertTrue(self.button.SH_controlBlocks.count == 0);
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  [self.button SH_addControlEvents:UIControlEventTouchDragExit withBlock:self.block];
  
  XCTAssertEqual(self.button.SH_controlBlocks.count, 2U);
  XCTAssertEqualObjects(self.button.SH_controlBlocks[@(UIControlEventTouchDragExit)],
                       [NSSet setWithArray:@[self.block]]);

  XCTAssertEqualObjects(self.button.SH_controlBlocks[@(UIControlEventTouchUpInside)],
                       [NSSet setWithArray:@[self.block]]);
  
  [self.button SH_removeAllControlEventsBlocks];
  XCTAssertTrue(self.button.SH_controlBlocks.count == 0);
  
}


@end
