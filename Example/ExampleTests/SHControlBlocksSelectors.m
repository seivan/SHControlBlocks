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
-(void)testSH_addControlEvents_withBlock:(SHControlEventBlock)theBlock; {
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
  
  [self.button SH_removeAllControlEventsBlocks];
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
  STAssertFalse(didAssert, nil);
  

}
-(void)testSH_removeBlocksForControlEvents; {
  __block BOOL didAssert = NO;
  [self.button SH_addControlEvents:UIControlEventTouchUpInside withBlock:^(UIControl *sender) {
    didAssert = YES;
  }];
  
  [self.button SH_removeBlocksForControlEvents:UIControlEventTouchUpInside];
  [self.button sendActionsForControlEvents:UIControlEventTouchUpInside];
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
  STAssertFalse(didAssertFirstBlock, nil);
  STAssertFalse(didAssertSecondBlock, nil);

}


#pragma mark - Helpers
-(void)testSH_blocksForControlEvents; {
  
}

-(void)testSH_controlEventsForBlock; {
  
}



#pragma mark - Properties


#pragma mark - Getters
-(void)testSH_isTouchUpInsideEnabled; {
  
}

-(void)testSH_controlBlocks; {
  
}


@end
