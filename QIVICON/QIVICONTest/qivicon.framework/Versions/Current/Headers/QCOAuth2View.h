/*
 * (C) Copyright 2011-2013 by Deutsche Telekom AG.
 *
 * This software is property of Deutsche Telekom AG and has
 * been developed for QIVICON platform.
 *
 * See also http://www.qivicon.com
 *
 * DO NOT DISTRIBUTE OR COPY THIS SOFTWARE OR PARTS OF THE SOFTWARE
 * TO UNAUTHORIZED PERSONS OUTSIDE THE DEUTSCHE TELEKOM ORGANIZATION.
 *
 * VIOLATIONS WILL BE PURSUED!
 */

#import <UIKit/UIKit.h>

@class QCAuthorizedConnection;
@class QCOAuth2View;

/**
 * Provides delegates methods which are called by the QCAuth2View */
@protocol QCOAuthViewDelegate <NSObject>
@required
/**
 * This required delegate method is called when the authentication finished
 * successfully with a code.
 *
 * @param view
 *            The instance of the oAuth2View.
 * @param code
 *            initialized global settings object
 * @param connection
 *            The authorized connection for which this code was retrieved
 */
- (void)oAuth2View:(QCOAuth2View*)view didFinishWithCode:(NSString*)code
     forConnection:(QCAuthorizedConnection *)connection;

/**
 * This required delegate method is called when the authentication finished
 * with an error.
 *
 * @param view
 *            The instance of the oAuth2View.
 * @param errorMessage
 *            Error message
 */
- (void)oAuth2View:(QCOAuth2View*)view didFinishWithError:(NSString*)errorMessage;

@optional
/**
 * This optional delegate method is called when the authentication view
 * start loading its content.
 *
 * @param view
 *            The instance of the oAuth2View.
 */

- (void)oAuth2ViewDidStartLoad:(QCOAuth2View*)view;

/**
 * This optional delegate method is called when the authentication view
 * finished presenting its content.
 *
 * @param view
 *            The instance of the oAuth2View.
 */
- (void)oAuth2ViewDidFinishLoad:(QCOAuth2View*)view;

/**
 * This optional delegate method is called if the user clicked a link on the oAuth Page.
 * This should not happen, but opportunity is given to the delegate to handle the link
 *
 * @param view
 *            The instance of the oAuth2View.
 * @param url
 *            The clicked url
 */
- (void) oAuth2View:(QCOAuth2View *)view clickedLink:(NSURL *)url;
@end


/**
 * The QCOAuth2View presents the OAuth2 logon form specified in the global settings.
 * The caller can provide a delegate object which have to implememt the QCOAuthViewDelegate
 * protocol.
 */
@interface QCOAuth2View : UIView <UIWebViewDelegate>{
    BOOL finished;
}

@property (nonatomic, readonly) UIWebView *webView;
@property (nonatomic, readonly) QCAuthorizedConnection *connection;
@property (readwrite, weak)id<QCOAuthViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame __attribute__((unavailable("Use 'initWithFrame:connection:delegate:' instead")));

/**
 * Creates a new QCAuth2 view.
 *
 * @param frame
 *            The frame size for the view
 * @param connection
 *            The connection (to get the login url)
 * @param delegate
 *            The delegate object for the view. The object have to implememt the QCOAuthViewDelegate protocol.
 * @return initialized object
 */
- (id)initWithFrame:(CGRect)frame
         connection:(QCAuthorizedConnection *)connection
           delegate:( __weak id<QCOAuthViewDelegate>)delegate;

@end
