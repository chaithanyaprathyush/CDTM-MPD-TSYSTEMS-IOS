//
//  ViewController.m
//  QIVICONTest
//
//  Created by Pascal Fritzen on 15.11.14.
//  Copyright (c) 2014 CDTM. All rights reserved.
//

#import "ViewController.h"
#import <qivicon/qivicon.h>
#import "QDAuthViewController.h"

@interface ViewController () <QCOAuthViewDelegate, QCPersistentTokenStorage, QCServiceGatewayEventListener>

@property (nonatomic, retain) QCConnectionFactory *connectionFactory;
@property (nonatomic, retain) QCBackendConnection *backendConnection;

@property (nonatomic, retain) QCOAuth2View *auth2View;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLayoutSubviews];

	self.heartImageView.alpha = 0.0f;
	self.countLabel.text = @"-";
	self.statusTextView.text = @"";
	self.loginButton.enabled = NO;

	[self performSelector:@selector(initializeQivicon) withObject:nil afterDelay:2.0f];
}

- (void)initializeQivicon
{
	dispatch_async(dispatch_queue_create("Setup QIVICON Connection", nil), ^{
					   [self log:@"Creating Connection Factory ..."];

					   self.connectionFactory = [[QCConnectionFactory alloc] initWithGlobalSettingsProvider:[QCSystemPropertiesGlobalSettingsProvider new]
																							   tokenStorage:self];
					   [self log:@"Done!"];

					   NSError *error;

        /*
					   [self log:@"Discovering local gateway IDs ..."];

					   NSArray *localGatewayIDs = [self.connectionFactory discoverLocalGatewayIDsWithError:&error];

					   if (error) {
						   [self log:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
					   } else {
						   [self log:[NSString stringWithFormat:@"Success: %@", localGatewayIDs]];
					   }
*/
					   [self log:@"Fetching backend connection ..."];

					   self.backendConnection = [self.connectionFactory backendConnection];

					   [self log:@"Done!"];

					   [self log:@"Authorizing Backend Connection ..."];

					   [self.backendConnection authorizeWithError:&error];

					   if (error) {
						   [self log:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
					   } else {
						   [self log:@"Success!"];

						   [self log:@"Fetching user gateways ..."];

						   NSArray *userGateways = [self.backendConnection userGatewaysWithError:&error];

						   if (error) {
							   [self log:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
						   } else {
							   [self log:[NSString stringWithFormat:@"Success: %@", userGateways]];
							   [self update];
						   }
					   }

					   dispatch_async(dispatch_get_main_queue(), ^{
										  self.statusTextView.hidden = YES;
										  self.loginButton.enabled = YES;
									  });
				   });
}

- (void)log:(NSString *)status
{
	dispatch_async(dispatch_get_main_queue(), ^{
					   self.statusTextView.text = [NSString stringWithFormat:@"%@\n%@", self.statusTextView.text, status];
					   NSLog(@"%@", status);
				   });
}

- (void)login
{
	NSError *error;

	[self.backendConnection authorizeWithError:&error];

	if (!self.backendConnection.isAuthorized) {
		self.auth2View = [[QCOAuth2View alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
												  connection:self.backendConnection
													delegate:self];
	}

	[self.view addSubview:self.auth2View];
}

#pragma mark - <QCOAuthViewDelegate>

- (void)oAuth2View:(QCOAuth2View *)view didFinishWithCode:(NSString *)code forConnection:(QCAuthorizedConnection *)connection
{
	NSLog(@"%@", NSStringFromSelector(_cmd));

	[self.auth2View removeFromSuperview];

	NSLog(@"is backendconnection: %i", connection == self.backendConnection);

	NSError *error;
	[self.backendConnection authorizeWithAuthCode:code error:&error];

	if (error) {
		NSLog(@"Error while authorizing backend connection: %@", error);
	}

	[self update];
}

- (void)update
{
	QCAuthorizedConnection *authorizedConnection = self.backendConnection;

    if (!authorizedConnection.isAuthorized) {
        NSLog(@"REMOTE CONNECTION IS NOT AUTHORIZED. MAKE SURE THIS DOES NEVER HAPPEN!!!!");
        return;
    }
    
    NSError *error;
    
    NSLog(@"all backend methods: %@", [authorizedConnection allMethodsWithError:&error]);

	if ([authorizedConnection isKindOfClass:[QCServiceGatewayConnection class]]) {
		NSLog(@"is QCServiceGatewayConnection");
	} else {
		NSArray *backendGateways = [self.backendConnection userGatewaysWithError:&error];
		NSLog(@"backendGateways: %@", backendGateways);

		if (backendGateways.count >= 1) {
			QCServiceGatewayConnection *serviceGatewayConnection = [self.connectionFactory remoteGatewayConnectionWithGWID:[backendGateways firstObject] error:&error];

            NSLog(@"all service gateway methods: %@", [serviceGatewayConnection allMethodsWithError:&error]);
            
			[serviceGatewayConnection authorizeWithError:&error];

			if (serviceGatewayConnection.isAuthorized) {
				id<QCServiceGatewayEventConnection> eventConnection = [self.connectionFactory gatewayEventConnectionWithConnection:serviceGatewayConnection pushMethod:PushMethod_All];

				[eventConnection addEventListenerWithTopic:@"com/qivicon/services/hdm/dco_property_changed" filter:nil listener:self error:&error];
				[eventConnection addEventListenerWithTopic:@"system/heartbeat/alive" filter:nil listener:self error:nil];
			} else {
				NSLog(@"serviceGatewayConnection is not authorized!");
			}
		}
	}
}

- (void)oAuth2View:(QCOAuth2View *)view didFinishWithError:(NSString *)errorMessage
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"%@", errorMessage);

	[self.auth2View removeFromSuperview];
}

#pragma mark - <QCPersistentTokenStorage>

- (void)deleteAllTokens
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)storeTokenForGatewayId:(NSString *)gatewayId token:(NSString *)refreshToken
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"%@ <-- %@", gatewayId, refreshToken);

	[[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:gatewayId];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)loadTokenForGatewayId:(NSString *)gatewayId
{
	NSLog(@"%@", NSStringFromSelector(_cmd));

	NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:gatewayId];

	NSLog(@"%@ --> %@", gatewayId, token);

	return token;
}

- (void)deleteTokenForGatewayId:(NSString *)gatewayId
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (IBAction)didTouchLoginButton:(id)sender
{
	[self login];
}

#pragma mark - <QCServiceGatewayEventListener>

- (void)onEvent:(id<QCServiceGatewayEvent>)event connection:(id<QCServiceGatewayEventConnection>)connection
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"Received Event: %@", event.topic);

	if ([event.topic isEqualToString:@"system/heartbeat/alive"]) {
		self.countLabel.text = [NSString stringWithFormat:@"%lld", event.sequenceNumber];

		self.heartImageView.alpha = 1.0f;
		[UIView animateWithDuration:5.0f
							  delay:0.0f
							options:UIViewAnimationOptionCurveEaseOut
						 animations:^{
			 self.heartImageView.alpha = 0.0f;
		 } completion:^(BOOL finished) {

		 }];
	} else {
		NSLog(@"%@", [event content]);
	}
}

- (void)onEventsLost:(int)numLostEvents connection:(id<QCServiceGatewayEventConnection>)connection
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onError:(NSError *)error connection:(id<QCServiceGatewayEventConnection>)connection
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
