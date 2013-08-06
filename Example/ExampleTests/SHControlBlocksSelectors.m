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
    STAssertEqualObjects(self.button, sender, nil);
    didAssert = YES;
  }];
  
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  STAssertTrue(didAssert, nil);
  
  
}

-(void)testSH_addControlEventTouchUpInsideWithBlock_theBlock; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    STAssertEqualObjects(self.button, sender, nil);
    didAssert = YES;
  }];
  
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  STAssertTrue(didAssert, nil);
  
}


#pragma mark - Remove block
-(void)testSH_removeControlEventTouchUpInside; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEventTouchUpInsideWithBlock:^(UIControl *sender) {
    STFail(nil);
    didAssert = YES;
  }];
  
  [self.button SH_removeControlEventTouchUpInside];
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  STAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].SH_isEmpty, nil);
  STAssertFalse(didAssert, nil);
  
  
}

-(void)testSH_removeBlocksForControlEvents; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchUpInside withBlock:^(UIControl *sender) {
    didAssert = YES;
  }];
  
  [self.button SH_removeBlocksForControlEvents:UIControlEventTouchUpInside];
  STAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].SH_isEmpty, nil);

  STAssertFalse(didAssert, nil);

  
}
-(void)testSH_removeControlEventsForBlock; {
  __block BOOL didAssert = NO;
  self.block = ^(UIControl * theSender ){
    didAssert = YES;
  };
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];

  [self.button SH_removeControlEventsForBlock:self.block];
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  STAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].SH_isEmpty, nil);

  STAssertFalse(didAssert, nil);

  
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
  STAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchUpInside].SH_isEmpty, nil);

  STAssertTrue([self.button SH_blocksForControlEvents:UIControlEventTouchDragInside].SH_isEmpty, nil);

  STAssertFalse(didAssertFirstBlock, nil);
  STAssertFalse(didAssertSecondBlock, nil);

}


#pragma mark - Helpers
-(void)testSH_blocksForControlEvents; {
  UIControlEvents event = UIControlEventTouchDragExit;
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  [self.button SH_addControlEvents:event withBlock:self.block];
  
  NSSet * blockSet = @[self.block].SH_toSet;
  STAssertEqualObjects(blockSet,
                 [self.button SH_blocksForControlEvents:event], nil);
  
  STAssertEqualObjects(blockSet,
                       [self.button SH_blocksForControlEvents:UIControlEventTouchUpInside], nil);
  
}

-(void)testSH_controlEventsForBlock; {
  UIControlEvents event = UIControlEventTouchDragExit;
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  [self.button SH_addControlEvents:event withBlock:self.block];

  NSSet * eventSet = [self.button SH_controlEventsForBlock:self.block];
  STAssertEquals(eventSet.count, 2U, nil);
  
  STAssertTrue([eventSet containsObject:@(UIControlEventTouchUpInside)], nil);
  STAssertTrue([eventSet containsObject:@(event)], nil);
}


#pragma mark - Properties


#pragma mark - Getters
-(void)testSH_isTouchUpInsideEnabled; {
  STAssertFalse(self.button.SH_isTouchUpInsideEnabled, nil);
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  STAssertTrue(self.button.SH_isTouchUpInsideEnabled, nil);
  [self.button SH_removeControlEventTouchUpInside];
  STAssertFalse(self.button.SH_isTouchUpInsideEnabled, nil);
}

-(void)testSH_controlBlocks; {
  STAssertTrue(self.button.SH_controlBlocks.SH_isEmpty, nil);
  [self.button SH_addControlEventTouchUpInsideWithBlock:self.block];
  [self.button SH_addControlEvents:UIControlEventTouchDragExit withBlock:self.block];
  
  STAssertEquals(self.button.SH_controlBlocks.count, 2U, nil);
  STAssertEqualObjects(self.button.SH_controlBlocks[@(UIControlEventTouchDragExit)],
                       @[self.block].SH_toSet, nil);

  STAssertEqualObjects(self.button.SH_controlBlocks[@(UIControlEventTouchUpInside)],
                       @[self.block].SH_toSet, nil);
  
  [self.button SH_removeAllControlEventsBlocks];
  STAssertTrue(self.button.SH_controlBlocks.SH_isEmpty, nil);
  
}


@end
