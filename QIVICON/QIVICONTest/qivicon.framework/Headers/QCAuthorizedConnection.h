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

#import <Foundation/Foundation.h>
#import "QCConnection.h"
#import "QCRemoteMethod.h"
#import "QCOAuth2Token.h"

extern NSString * const NOT_AUTHORIZED_MESSAGE;
extern NSString * const CANNOT_GET_ACCESS_TOKEN;

@protocol QCPersistentTokenStorage;
@protocol QCHTTPConnectionContext;
@class QCAuthorizedConnection;

typedef enum ConnectionType {
	ConnectionType_Service_Gateway_Remote,
	ConnectionType_Service_Gateway_Local,
	ConnectionType_Backend
} ConnectionType;

@protocol QCConnectionDelegate <NSObject>
- (void) connection:(id)connection didFailWithError:(NSError *)error;
- (void) connection:(id)connection didFinishWithResult:(NSArray *)result;
@end

/**
 * Provides methods to authorize and to perform call on the underlying
 * connections.
 */
@interface QCAuthorizedConnection : QCConnection

/**
 * Initializes a connection with default connection parameters. Token
 * storage will be provided.
 *
 * @param connectionContext
 *            connection context which will be used to establish the
 *            connection
 * @param tokenStorage
 *            token storage provider to persist the refresh token
 * @return initialized Object
 *
 */
- (id)initWithConnectionContext:(id <QCHTTPConnectionContext>)connectionContext tokenStorage:(id<QCPersistentTokenStorage>)tokenStorage;

/**
  * Authorize using the refresh token stored in persistent storage.
  *
  * @throws AuthException
  *             if there is no persistent token available
  */
- (void) authorizeWithError:(NSError * __autoreleasing *)error;

- (void) authorizeWithAuthCode:(NSString *) authCode error:(NSError **)error;


/**
 * Refresh the OAuth2 access token using the internally stored refresh
 * token. If persistent token storage is provided, the new refresh token
 * will be persisted.
 *
 * @param error
 *          Contains error, if appropriate. May be nil.
 * @return new refresh token
 * @throws AuthException
 *             on authorization errors
 */
- (NSString *) refreshWithError:(NSError **)error;

/**
 * Refresh the OAuth2 access token using the provided refresh token. If
 * persistent token storage is provided, the new refresh token will be
 * persisted.
 *
 * @param refreshToken
 *            OAuth2 refresh token, may be null
 * @param error
 *      Contains an error if appropriate, may be nil
 * @return new refresh token
 * @throws AuthException
 *             on authorization errors
 */
- (NSString *) refreshWithRefreshToken:(NSString *) refreshToken error:(NSError **)error;

/**
 * Checks whether this connection is already authorized.
 *
 * @return true if this connection is successful authorized
 */
- (BOOL) isAuthorized;

/**
 * Logout. The stored authorization is deleted. If persistent token storage
 * is provided, the persistent token will be deleted.
 */
- (void)logout;

/**
 * Calls a methods.
 *
 * @param method
 *            method to call
 * @param error
 *            Contains the error if the call has failed.
 * @return Call result
 * @throws Exception
 *             Thrown on argument errors.
 */
- (NSArray *) callWithMethod:(QCRemoteMethod *)method error:(NSError **)error;

/**
 * Calls one or more methods
 *
 * @param error
 *            Contains the error if the call has failed.
 * @param firstMethod,...
 *            methods to call
 * @return Call result
 * @throws Exception
 *             Thrown on argument errors.
 */
- (NSArray *) callWithError:(NSError **)error methods:(QCRemoteMethod *) firstMethod, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * Calls one or more methods
 *
 * @param error
 *            Contains the error if the call has failed.
 * @param methods
 *            methods to call
 * @return Call result
 * @throws Exception
 *             Thrown on argument errors.
 */
- (NSArray *) callAsBatchWithMethods:(NSArray *)methods error:(NSError *__autoreleasing *)error;

/**
 * Calls one or more methods asynchronously
 *
 * @param error
 *            Contains the error if the call has failed.
 * @param delegate
 *            Delegate to the call
 * @param methods
 *            methods to call
 * @return YES if sent sucessfully
 * @throws Exception
 *             Thrown on argument errors.
 */
- (BOOL) callAsyncAsBatchWithMethods:(NSArray *)methods delegate:(id)delegate error:(NSError *__autoreleasing *)error;

/**
 * Calls a method with some parameters. The result is mapped into the
 * generic type T .
 *
 * @param classOfT
 *            class for result
 * @param methods
 *            Array of methods to call
 * @param error
 *            Contains the error if the call has failed.
 * @return Call result
 * @throws Exception
 *             Thrown on argument errors.
 */
- (NSArray *) callWithReturnClass:(Class)classOfT methods:(NSArray *)methods error:(NSError * __autoreleasing *)error;

/**
 * Get a list of all available methods for this connection to call for the
 * provided user.
 *
 * @param error
 *            Contains the error if the allMethodsCall has failed.
 * @return list of methods
 * @throws Exception
 *             Thrown on argument errors.
 */
- (NSArray *)allMethodsWithError:(NSError * __autoreleasing *)error;

/**
 * Get the token storage provided to allow subclasses to use it.
 *
 * @return token storage provider or null if not set
 */
- (id<QCPersistentTokenStorage>)tokenStorage;

/**
 * Returns the connection's OAuth2 access token.
 *
 * @return OAuth2 access token
 *
 * @param error
 *            Contains the error if the call has failed.
 * @return either session id or OAuth2 access token
 *
 */
- (NSString *) accessTokenWithError:(NSError * __autoreleasing *)error;

@property (readonly) NSString *accessToken;

/**
 * Returns the connection's OAuth2 refresh token.
 *
 * @return current OAuth2 refresh token
 * @throws AuthException
 *             if connection is not authorized
 */
- (NSString *) refreshTokenWithError:(NSError * __autoreleasing *)error;

@property (readonly) NSString *refreshToken;

/**
 * Get the specific type of the connection.
 *
 * @see ConnectionType
 * @return Specific type of the implemented connection
 */
- (ConnectionType) connectionType;

/**
 * Get the OAuth2 login url. Use this url to display the OAuth2 provider's
 * login page to retrieve the authorization code. This code can than be used
 * with {@link #authorizeWithError:} to create an OAuth2 access token.
 * <p>
 * Use this method only, do not use
 * {@link QCGlobalSettings#loginURLForEndpoint:} directly.
 *
 * @since 2.0
 *
 * @return url
 */
- (NSURL *) loginURL;

/**
 * Get the OAuth2 login url. Use this url to display the OAuth2 provider's
 * login page to retrieve the authorization code. This code can than be used
 * with {@link #authorizeWithError:} to create an OAuth2 access token.
 * <p>
 * The state parameter will not be used by the client api. It is appended to
 * the url and should be returned unmodified after successful login.
 * <p>
 * Use this method only, do not use
 * {@link QCGlobalSettings#loginURLForEndpoint:state:} directly.
 *
 * @since 2.0
 *
 * @param state
 *            state parameter, may be null
 * @return OAuth2 login url
 */
- (NSURL *) loginURLForState:(NSString *) state;

/**
 * Get the connection specific {@link QCGlobalSettings} that are different
 * whether this is a local or a remote connection.
 *
 * @return {@link QCGlobalSettings}
 */
- (QCGlobalSettings *) connectionSettings;

@end
