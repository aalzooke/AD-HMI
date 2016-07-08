//
//  IntersectionView.m
//  AD-HMI
//
//  Created by assam alzookery on 4/20/16.
//  Copyright © 2016 assam alzookery. All rights reserved.
//

#import "IntersectionView.h"
#import "ViewController.h"
#import "GCDAsyncSocket.h"
@import Foundation;

@interface IntersectionView ()
@property (nonatomic,strong) tcpSocketChat *chatSocket;

@end

@implementation IntersectionView
@synthesize chatSocket =_chatSocket;


- (void)viewDidLoad {
   [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    NSString *ipAddressText = @"192.168.211.62";
    NSString *portText = @"1234";
    
    NSLog(@"Setting up connection to %@ : %i", ipAddressText, [portText intValue]);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) ipAddressText, [portText intValue], &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    [self open];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
/*
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    self.chatSocket = nil;
}
*/
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

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"stream event %lu \n ", streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
            //    _connectedLabel.text = @"Connected";
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
                            //        [self messageReceived:output];
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
            //     _connectedLabel.text = @"Disconnected";
            NSLog(@"close stream");
            break;
        default:
            NSLog(@"Unknown event");
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)junction:(id)sender {
    NSString *response5  = @"Junction \n  ";
    NSData *data5 = [[NSData alloc] initWithData:[response5 dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data5 bytes] maxLength:[data5 length]];
}

- (IBAction)connect:(id)sender {
    
    NSString *ipAddressText1 = @"192.168.211.62";
    NSString *portText1 = @"123";
    
    NSLog(@"Setting up connection to %@ : %i", ipAddressText1, [portText1 intValue]);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) ipAddressText1, [portText1 intValue], &readStream, &writeStream);
    
    messages = [[NSMutableArray alloc] init];
    
    [self open];
}
@end
