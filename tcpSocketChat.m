/*
 *  Copyright (c) 2016, DENSO International America, INC.
 *  All rights reserved.
 *  Code Written by Assam Alzookery.
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither the name of Autoware nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 *  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 *  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 *  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "tcpSocketChat.h"

@interface tcpSocketChat()
@property (nonatomic,strong)GCDAsyncSocket* asyncSocket;
@property (nonatomic, strong) NSString* HOST;
@property (nonatomic)NSInteger PORT;

@end

@implementation tcpSocketChat
@synthesize delegate = _delegate;
@synthesize asyncSocket = _asyncSocket;


-(id)initWithDelegate:(id)delegateObject AndSocketHost:(NSString*)host AndPort:(NSInteger)port
{
    self = [super init];
    if (self)
    {
        _HOST = host;
        _PORT = port;
        _delegate = delegateObject;
       _asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        NSError* err;
        if ([self.asyncSocket connectToHost:_HOST onPort:_PORT error:&err]) {
            
        }else{
            NSLog(@"ERROR %@",[err description]);
        }
    }
    
    return self;
}


-(void)sendMessage:(NSString *)str
{
   [self.asyncSocket writeData:[str dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    
}
-(void)disconnect
{
   [self.asyncSocket disconnect];
}

-(void)reconnect {
    
    NSError* err;
    if ([self isDisconnected]) {
        if ([self.asyncSocket connectToHost:_HOST onPort:_PORT error:&err]) {
           
        }else{
            NSLog(@"ERROR %@",[err description]);
        }
    }
}
#pragma mark - AsyncDelegate
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port: (uint16_t)port{
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
   if ([self.delegate respondsToSelector:@selector(receivedMessage:)])
   {
        NSString* str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        [self.delegate receivedMessage:str];
    }
    [self.asyncSocket readDataWithTimeout:-1 tag:0];
}
#pragma mark - Diagnostics
-(BOOL)isDisconnected {
      return [self.asyncSocket isDisconnected];
}
-(BOOL) isConnected {
    return [self.asyncSocket isConnected]; 
}


@end
