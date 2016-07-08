//
//  ViewControllerClient.m
//  AD-HMI
//
//  Created by assam alzookery on 4/13/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import "ViewControllerClient.h"
#import "GCDAsyncSocket.h"
@import Foundation;

@interface ViewControllerClient()

@property (nonatomic,strong) tcpSocketChat *chatSocket;
@end

@implementation ViewControllerClient
@synthesize chatBox = _chatBox;
@synthesize logView = _logView;
@synthesize chatSocket =_chatSocket;

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    self.chatSocket = nil;
    
}

- (void)open {
    
    NSLog(@"Opening streams.");
    
    outputStream = (__bridge NSOutputStream *)writeStream;
    inputStream = (__bridge NSInputStream *)readStream;
    
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [outputStream open];
    [inputStream open];
    
   // _connectedLabel.text = @"Connected";
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //register for keyboard notification
   // [[NSNotificationCenter defaultCenter] addObserver:self
                        //                     selector:@selector(keyboardWillShow)
                       //                         name:UIKeyboardWillShowNotification object:nil];
    
   // [[NSNotificationCenter defaultCenter]addObserver:self
           //                                 selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification
             //                                 object:nil];
    
    //clinet IP and port
    NSString *ipAddressText = @"192.168.211.62";
    NSString *portText = @"111";
    
    NSLog(@"Setting up connection to %@ : %i", ipAddressText, [portText intValue]);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) ipAddressText, [portText intValue], &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    
    [self open];
    
    
   // _chatSocket = [[tcpSocketChat alloc]initWithDelegate:self AndSocketHost:@"192.168.211.62" AndPort:123];
    //_chatSocket = [[tcpSocketChat alloc] initWithDelegate:self AndSocketHost:@"192.168.211.62" AndPort:123];

    
    
}
-(void)checkConnection{
    if ([_chatSocket isDisconnected])
    {
        [_chatSocket reconnect];
    }
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu \n ", streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            _connectedLabel.text = @"Connected";
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == inputStream)
            {
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([inputStream hasBytesAvailable])
                {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output)
                        {
                            NSLog(@"server said: %@ \n ", output);
                            [self messageReceived:output];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"Stream has space available now");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"%@\n",[theStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            _connectedLabel.text = @"Disconnected";
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}

- (void)close {
    NSLog(@"Closing streams.");
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    inputStream = nil;
    outputStream = nil;
    
    _connectedLabel.text = @"Disconnected";
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)connectToServer:(id)sender {
    
    messages = [[NSMutableArray alloc] init];
      [self open];
}

- (IBAction)disconnect:(id)sender {

    NSString *response  = @"Lest start \n  ";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
    // NSString * input = _chatBox.text;
    //_logView.text = response;
    
   // if ([[_chatBox text]length ] > 0) {
   //     NSString *requestStr = [_chatBox text];
   //     NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
   // }

}


-(void)messageReceived:(NSString *)message{
    
    
    [messages addObject:message];
    
  // _logView.text = message;
    NSLog(@"%@", message);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.chatSocket sendMessage:textField.text];
    
    self.logView.text = [self.logView.text stringByAppendingFormat:@"ME >> %@\n",textField.text];
    
    textField.text = @"";
    
    [self.logView scrollRangeToVisible:NSMakeRange([self.logView.text length], 0)];
    return YES;
   
}

#pragma mark - tcpSocketDelegate
-(void)receivedMessage:(NSString *)data
{
    self.logView.text = [self.logView.text stringByAppendingFormat:@"%@",data];
    [self.logView scrollRangeToVisible:NSMakeRange([self.logView.text length], 0)];
}



@end
